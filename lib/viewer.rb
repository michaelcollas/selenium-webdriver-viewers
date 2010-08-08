require 'browser-instance'
require 'webdriver-extensions'
require 'forwardable'

module WebViewer
  
  extend Forwardable
  def_delegators :browser, :close, :current_url, :execute_script, :get, :manage, :navigate, :page_source, 
                           :save_screenshot, :screenshot_as, :script, :switch_to, :title, :visible=, :visible?, 
                           :window_handle, :window_handles  
  def_delegators :base_element, :[], :all, :attribute, :clear, :click, :displayed?, :drag_and_drop_by, :drag_and_drop_on, 
                                :enabled?, :find_element, :find_elements, :first, :hover, :location, :ref, :select, :selected?, 
                                :send_key, :send_keys, :size, :style, :submit, :tag_name, :text, :toggle, :value, 
                                :element_present?, :wait_for_element_present
            

  def self.included(target)
    super
    target.extend ClassMethods
  end
  
  def base_element
    return @base_element_proc.call if @base_element_proc
    browser.find_element(:tag_name, 'html')
  end

  def showing?
    base_element
    true
    rescue Selenium::WebDriver::Error::NoSuchElementError
      false
  end

  private

  class ElementReader

    def initialize(viewer, selector, selector_type)
      @viewer = viewer
      @selector = selector
      @selector_type = selector_type
    end
 
    def requires_parameters?
      @selector.respond_to?(:call) && @selector.respond_to?(:arity) && @selector.arity > 0
    end

    def callable_selector?
      @selector.respond_to?(:call) 
    end

    # return either self or element depending on whether selector needs parameters
    def get(*arguments)
      return element unless callable_selector?
      if (arguments.length > 0) || !requires_parameters?
        element(@selector.call(*arguments))
      else
        self
      end
    end

    def [](*arguments)
      selector_text = @selector.call(*arguments)
      self.element(selector_text)
    end

    def element(selector_text = @selector)
      @viewer.find_element(@selector_type, selector_text)
    end

  end

  class ElementValueReader

    def initialize(element_reader, output_type)
      @element_reader = element_reader
      @output_type = output_type
    end

    # return either self or element_value depending on whether selector needs parameters
    def get
      if @element_reader.requires_parameters?
        self
      else
        element_value
      end
    end

    def [](*args)
      element_value(*args)
    end

    def []=(*arguments)
      value_to_assign = arguments.pop
      element = @element_reader.get(*arguments)
      ElementValueWriter.new(element, @output_type).value = value_to_assign
    end

    def element_value(*arguments)
      if (Class === @output_type)
        element_as_viewer(*arguments)
      elsif [:auto, :link, :select_by_text, :select_by_value].include? @output_type
        raise "not yet implemented"
      else
        @element_reader.get(*arguments).send(@output_type)
      end
    end

    def element_as_viewer(*arguments)
      viewer = @output_type.new
      base_element_proc = lambda { @element_reader.get(*arguments) }
      viewer.instance_variable_set(:@base_element_proc, base_element_proc)
      viewer
    end

  end

  class ElementValueWriter

    def initialize(web_element, element_type)
      @web_element = web_element
      @element_type = element_type
    end

    def value=(new_value)
      # do smart things with element_type in here
      @web_element.value = new_value
    end

  end

  module ClassMethods
    
    def base_element(selector, selector_type=:id)
      define_method(:base_element) do
        browser.find_element selector_type, selector
      end
    end

    def default_selector_type(selector_type)
      @default_selector_type = selector_type
    end

    # :as options: :auto, :text, :click, :link, :select_by_text, :select_by_value, :hover, :location, :size, :toggle, :value, ViewerClass
    def element(name, selector=name.to_s, options={}, &selector_proc)
      if options.empty? && selector.is_a?(::Hash)
        options = selector
        selector = name
      end
      selector = selector_proc if selector_proc
      selector_type = options[:by] || @default_selector_type || :id
      output_type = options[:as] || :value

      define_method("#{name}_element_reader") do
        ElementReader.new(self, selector, selector_type)
      end

      define_method("#{name}_element") do 
        send("#{name}_element_reader").get
      end

      define_method(name) do 
        element_reader = send("#{name}_element_reader")
        ElementValueReader.new(element_reader, output_type).get
      end

      # only define this method if result type suggests assignability
      define_method("#{name}=") do |new_value|
        element_reader = send("#{name}_element_reader")
        raise "parameters required" if element_reader.requires_parameters?
        ElementValueWriter.new(element_reader.get, output_type).value = new_value
      end

      define_method("#{name}_present?") do |*arguments|
        raise ArgumentError(1, arguments.length) if arguments.length > 1
        timeout = arguments[0].to_f
        element_present? selector_type, selector, timeout
      end
      alias_method "has_#{name}?", "#{name}_present?"

    end

  end

end

class WebViewerObject
  include BrowserInstance
  include WebViewer
end

