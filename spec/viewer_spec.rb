require 'spec_helper'

describe WebViewer, 'included in a class' do

  before do
    @viewer_class = Class.new(Object).extend(WebViewer)
    @viewer = @viewer_class.new
    @fake_browser = stub
    @viewer.stub(browser).and_return(@fake_browser)
  end

end
