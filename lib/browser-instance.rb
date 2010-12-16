require 'selenium-webdriver'

module BrowserInstance

  class << self
    
    def base_url=(new_value)
      @base_url = new_value
      @browser.navigate.base_url = @base_url if @browser
    end
    
    def base_url
      @base_url || ENV['BASE_URL'] || ''
    end

    def browser_instance
      @browser ||= create_browser
    end
  
    def create_browser
      browser = Selenium::WebDriver.for :firefox
      browser.navigate.extend(BaseUrl).base_url = base_url
      browser
    end
    
    def quit
      return unless @browser
      @browser.quit
      @browser = nil
    end
    
  end

  def browser
    BrowserInstance.browser_instance
  end

end

module BaseUrl
  
  def self.extended(target)
    super
    class << target
      alias_method :to_absolute, :to
      alias_method :to, :to_relative
    end
  end

  def to_relative(new_location)
    to_absolute(@base_url + new_location)
  end
  
  def base_url=(base)
    @base_url = base
  end
  
end


