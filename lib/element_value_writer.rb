module WebViewer

  # ElementValueWriter assigns a value to a Selenium::WebDriver::Element. It uses the element_type
  # parameter passed in the constructor to determine how to write to the element.
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
