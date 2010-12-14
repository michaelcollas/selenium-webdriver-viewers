require 'spec_helper'

describe WebViewer::ElementValueWriter do

  describe "#value=" do

    it 'should assign the new value to its web element using value=' do
      web_element = stub('WebDriver::Element')
      writer = WebViewer::ElementValueWriter.new(web_element, :value)
      web_element.should_receive(:value=).with('new value')
      writer.value = 'new value'
    end

  end

end
