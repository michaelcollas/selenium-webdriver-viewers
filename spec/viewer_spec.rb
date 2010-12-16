require 'spec_helper'

describe WebViewer, 'included in a class' do

  before do
    @viewer_class = Class.new(Object).extend(WebViewer)
  end

end
