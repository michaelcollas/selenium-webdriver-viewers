module WebViewer

  # ElementValueReader acts on a Selenium::WebDriver::Element by fetching its value, clicking on it,
  # reading its text, etc. 
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

end
