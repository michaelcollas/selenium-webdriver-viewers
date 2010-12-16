require 'spec_helper'

describe WebViewer::ElementValueReader do

  share_as :UnimplementedOutputType do

    it 'should raise an exception' do
      output_type = self.class.options[:output_type]
      value_reader = WebViewer::ElementValueReader.new(@element_reader, output_type)
      read_operation = lambda { @element_reader.requires_parameters? ? value_reader['1'] : value_reader.get }
      read_operation.should raise_error "not yet implemented"
    end

  end

  describe 'when the element reader does not require parameters' do

    before do
      @dummy_element = stub(:value => 'element value')
      @element_reader = stub('element reader', :requires_parameters? => false, :get => @dummy_element)
    end

    describe 'and the output type is not a class' do

      before do
        @value_reader = WebViewer::ElementValueReader.new(@element_reader, :value)
      end

      describe '#get' do

        it 'should fetch the element from the element reader' do
          @element_reader.should_receive(:get).and_return(@dummy_element)
          @value_reader.get
        end

        it 'should call the method on the element with name equal to the output type parameter' do
          @dummy_element.should_receive(:value)
          @value_reader.get
        end

        it 'should return the result of calling the method on the element with name equal to the output type parameter' do
          @value_reader.get.should == 'element value'
        end

      end

    end

    describe('and the type is :auto', :output_type => :auto) { it_should_behave_like UnimplementedOutputType }
    describe('and the type is :link', :output_type => :link) { it_should_behave_like UnimplementedOutputType }
    describe('and the type is :select_by_text', :output_type => :select_by_text) { it_should_behave_like UnimplementedOutputType }
    describe('and the type is :select_by_value', :output_type => :select_by_value) { it_should_behave_like UnimplementedOutputType }

    describe 'and the output type is a class' do

      before do
        output_viewer_class = Class.new(Object)
        @output_viewer = stub('a different viewer', :base_element= => nil)
        output_viewer_class.stub(:new).and_return(@output_viewer)
        @value_reader = WebViewer::ElementValueReader.new(@element_reader, output_viewer_class)
      end

      it 'should return an instance of the specified class' do
        @value_reader.get.should == @output_viewer
      end

      it 'should put a base_element proc into the returned object' do
        @output_viewer.should_receive(:base_element=).with(a_kind_of(Proc))
        @value_reader.get
      end

    end

  end

  describe 'when the element reader requires parameters' do

    before do
      @dummy_element = stub(:value => 'element value')
      @element_reader = stub('element reader', :requires_parameters? => true, :get => @dummy_element)
    end

    describe 'and the output type is not a class' do

      before do
        @value_reader = WebViewer::ElementValueReader.new(@element_reader, :value)
      end

      it '#get should return the element value reader' do
        @value_reader.get.should == @value_reader
      end

      describe '#[]' do

        it 'should fetch the element from the element reader passing provided parameters' do
          @element_reader.should_receive(:get).with(1, 2, 3).and_return(@dummy_element)
          @value_reader[1, 2, 3]
        end

        it 'should call the method on the element with name equal to the output type parameter' do
          @dummy_element.should_receive(:value)
          @value_reader[1]
        end

        it 'should return the result of calling the method on the element with name equal to the output type parameter' do
          @value_reader[1].should == 'element value'
        end

      end

      describe '#[]=' do

        before do
          @fake_value_writer = stub(:value= => nil)
          WebViewer::ElementValueWriter.stub(:new).and_return(@fake_value_writer)
        end

        it 'should get the element from the element reader using all parameters except the assigned value' do
          @element_reader.should_receive(:get).with(1, 2, 3).and_return(@dummy_element)
          @value_reader[1, 2, 3] = 4
        end

        it 'should create an element value writer with the element and output type' do
          WebViewer::ElementValueWriter.should_receive(:new).with(@dummy_element, :value)
          @value_reader[1, 2, 3] = 4
        end

        it 'should assign the value to the writer using value=' do
          @fake_value_writer.should_receive(:value=).with(4)
          @value_reader[1, 2, 3] = 4
        end

      end

    end

    describe('and the type is :auto', :output_type => :auto) { it_should_behave_like UnimplementedOutputType }
    describe('and the type is :link', :output_type => :link) { it_should_behave_like UnimplementedOutputType }
    describe('and the type is :select_by_text', :output_type => :select_by_text) { it_should_behave_like UnimplementedOutputType }
    describe('and the type is :select_by_value', :output_type => :select_by_value) { it_should_behave_like UnimplementedOutputType }

    describe 'and the output type is a class' do

      before do
        output_viewer_class = Class.new(Object)
        @output_viewer = stub('a different viewer', :base_element= => nil)
        output_viewer_class.stub(:new).and_return(@output_viewer)
        @value_reader = WebViewer::ElementValueReader.new(@element_reader, output_viewer_class)
      end

      it 'should return an instance of the specified class' do
        @value_reader[1, 2].should == @output_viewer
      end

      it 'should put a base_element proc that gets the element from the reader into the returned object' do
        @output_viewer.stub(:base_element=) { |assigned_base_element_proc| assigned_base_element_proc.call }
        @element_reader.should_receive(:get).with(1, 2)
        @value_reader[1, 2]
      end

    end

  end

end
