module WebViewer

  # ElementReader fetches a Selenium::WebDriver::Element for a particular selector. If the selector
  # requires parameters, ElementReader defers reading from WebDriver until the parameters are
  # provided using the [] method.
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

end
