require 'spec_helper'

describe 'an object that includes WebPage' do

  class SampleWebPage
    include WebPage
  end

  before do
    @page = SampleWebPage.new
    @page.stub!(:navigate).and_return(stub('navigate interface'))
  end

  it 'should not have a url instance method if the url class method has not been called' do
    @page.respond_to?(:url).should == false
  end

  it 'should not have a path instance method if the path class method has not been called' do
    @page.respond_to?(:path).should == false
  end

  describe 'with a url set using the .url class method' do

    before do
      class << @page
        url 'http://somewhere'
      end
    end

    it 'should return the value from #url that was set by .url' do
      @page.url.should == 'http://somewhere'
    end

    it 'should navigate to the absolute url when load is called' do
      @page.navigate.should_receive(:to_absolute).with('http://somewhere')
      @page.load
    end

  end

  describe 'with a url set using the .url class method' do
  
    before do
      class << @page
        path '/somewhere'
      end
    end
  
    it 'should return the value from #path that was set by .path' do
      @page.path.should == '/somewhere'
    end

    it 'should navigate to the relative path when load is called' do
      @page.navigate.should_receive(:to_relative).with('/somewhere')
      @page.load
    end

  end

  it 'should construct itself and call #load when .load is called' do
    SampleWebPage.stub!(:new).and_return(@page)
    @page.should_receive(:load)
    SampleWebPage.load
  end

end
