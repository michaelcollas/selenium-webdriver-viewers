require 'selenium-webdriver'

module HumaneWebDriverExtensions
  # deal with different html element types:
  #    boolean for checkboxes, radio buttons, and individual options in select controls
  #    string for inputs, textarea, and selects
  #    send JavaScript for hidden inputs?
  def value=(new_value)
    case self.tag_name.to_sym
      when :input, :textarea
        clear
        send_keys new_value.to_s
      else
        raise "cannot set value for a #{self.tag_name} element - only input and textarea supported"
    end
  end
end

module Selenium
  module WebDriver

    module Find
      
      def element_present?(how, what, how_long=0)
        wait_for_element_present(how, what, how_long)
        true
        rescue Selenium::WebDriver::Error::NoSuchElementError
          false
      end
      
      def wait_for_element_present(how, what, how_long)
        attempts_left = how_long / 0.1
        begin
          find_element(how, what)
        rescue Selenium::WebDriver::Error::NoSuchElementError
          if attempts_left > 0
            attempts_left -= 1
            sleep 0.1
            retry
          end
          fail
        end
      end
      
    end

    class Element
      include HumaneWebDriverExtensions
    end
 
  end
end

