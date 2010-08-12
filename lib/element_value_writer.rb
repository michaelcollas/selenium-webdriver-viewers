module WebViewer

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

end
