require 'spec_helper'

describe BrowserInstance do

  describe '#base_url' do

    before do
      BrowserInstance.base_url = nil
    end

    after do
      BrowserInstance.base_url = nil
    end

    it 'should have an empty base url by default' do
      BrowserInstance.base_url.should == ''
    end
  
    it 'should have the base url set by base_url=' do
      BrowserInstance.base_url = 'http://something'
      BrowserInstance.base_url.should == 'http://something'
    end
  
    it 'should have a base url provided by environment variable if none has been set by base_url=' do
      ENV.stub!(:[]).with('BASE_URL').and_return('http://from-environment')
      BrowserInstance.base_url.should == 'http://from-environment'
    end

  end

  describe 'browser_instance' do

    before do
      @driver = stub('firefox driver')
      class << @driver
        attr_reader :last_to_location
        def to(location)
          @last_to_location = location
        end
      end
      @driver.stub!(:navigate).and_return(@driver)
      Selenium::WebDriver.stub!(:for).and_return(@driver)
    end

    after do
      BrowserInstance.instance_variable_set(:@browser, nil)
    end

    it 'should create a new WebDriver driver instance for firefox' do
      Selenium::WebDriver.should_receive(:for).with(:firefox).and_return(@driver)
      BrowserInstance.browser_instance
    end 

    it 'should return the created driver from browser_instance' do
      BrowserInstance.browser_instance.should equal(@driver)
    end

    describe 'navigate interface' do

      before do
        BrowserInstance.base_url = 'http://flibble'
        @browser = BrowserInstance.browser_instance
      end

      it 'should prepend the base url when to is used' do
        @browser.navigate.to '/somewhere'
        @browser.last_to_location.should == 'http://flibble/somewhere'
      end
  
      it 'should ignore the base url when navigate.to_absolute is used' do
        @browser.navigate.to_absolute '/somewhere'
        @browser.last_to_location.should == '/somewhere'
      end

    end

    describe 'when a browser has already been requested' do

      before do
        BrowserInstance.browser_instance
      end

      it 'should not create another WebDriver driver instance' do
        Selenium::WebDriver.should_not_receive(:for)
        BrowserInstance.browser_instance
      end

      it 'should return the same instance on subsequent calls' do
        BrowserInstance.browser_instance.should equal(BrowserInstance.browser_instance)
      end

    end

  end

end
