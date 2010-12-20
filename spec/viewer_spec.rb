require 'spec_helper'

describe WebViewer, 'included in a class' do

  before do
    @viewer_class = Class.new(Object).extend(WebViewer)
    @viewer = @viewer_class.new
    @fake_browser = stub
    @viewer.stub(:browser).and_return(@fake_browser)
  end

  describe '#base_element' do

    it 'should return the base element if one has been assigned' do
      pending
      fake_element = stub('fake element')
      @viewer.base_element = fake_element
      @viewer.base_element.should == fake_element
    end

  end

end
