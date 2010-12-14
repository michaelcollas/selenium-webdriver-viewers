require 'spec_helper'

describe WebViewer::ElementReader do

  before do
    @dummy_element = stub('webdriver element')
    @viewer = stub('viewer', :find_element => @dummy_element)
  end

  describe 'when the selector is a proc' do

    describe 'and the selector proc has parameters' do

      before do
        @reader = WebViewer::ElementReader.new(@viewer, proc {|argument| "proc based selector with #{argument}"}, :css)
      end
  
      it 'should require parameters' do
        @reader.requires_parameters?.should be_true
      end

      describe '#get' do
        
        it 'should return itself if parameters are not provided' do
          @reader.get.should == @reader
        end

        it 'should fetch the element from the viewer using the result of calling the proc if parameters are provided' do
          @viewer.should_receive(:find_element).with(:css, 'proc based selector with parameter value')
          @reader.get('parameter value')
        end

        it 'should return the fetched element if parameters are provided' do
          @reader.get('parameter value').should == @dummy_element
        end

      end  

      describe '#[]' do

        it 'should fetch the element from the viewer using the result of calling the proc if parameters are provided' do
          @viewer.should_receive(:find_element).with(:css, 'proc based selector with parameter value')
          @reader['parameter value']
        end

        it 'should return the fetched element if parameters are provided' do
          @reader['parameter value'].should == @dummy_element
        end

      end

    end

    describe 'and the selector proc has no parameters' do

      before do
        @reader = WebViewer::ElementReader.new(@viewer, proc {'proc based selector'}, :css)
      end

      it 'should not require parameters if the selector is a proc with no parameters' do
        @reader.requires_parameters?.should be_false
      end
  
      it 'should recognize that the selector is callable' do
        @reader.callable_selector?.should be_true
      end

      it 'should fetch the element from the viewer using the result of calling the proc' do
        @viewer.should_receive(:find_element).with(:css, 'proc based selector')
        @reader.get
      end

      it 'should return the fetched element' do
        @reader.get.should == @dummy_element
      end

    end

  end

  describe 'when the selector is a string' do

    before do
      @reader = WebViewer::ElementReader.new(@viewer, 'text based selector', :css)
    end

    it 'should not require parameters if the selector is a string' do
      @reader.requires_parameters?.should be_false
    end

    it 'should recognize that the selector is not callable' do
      @reader.callable_selector?.should be_false
    end

    it 'should fetch the element from the viewer' do
      @viewer.should_receive(:find_element).with(:css, 'text based selector')
      @reader.get
    end

    it 'should return the fetched element' do
      @reader.get.should == @dummy_element
    end

  end

end
