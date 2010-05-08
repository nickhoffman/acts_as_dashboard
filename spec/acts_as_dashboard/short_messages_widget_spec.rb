require File.join File.dirname(__FILE__), '..', 'spec_helper'
require File.join File.dirname(__FILE__), '..', 'shared', 'widget_behaviours'

describe ActsAsDashboard::ShortMessagesWidget do
  it_should_behave_like 'an ActsAsDashboard Widget'

  describe 'initialization' do # {{{
    before :each do
      @options = {
        :max_data_items => 5
      }
    end

    it 'removes the :type element from the given options' do
      options = {:type => :something}
      options.should_receive(:delete).with :type

      widget = ActsAsDashboard::ShortMessagesWidget.new options
    end

    it 'sets its type to :short_messages' do
      widget = ActsAsDashboard::ShortMessagesWidget.new
      widget.type.should equal :short_messages
    end

    it 'sets its max_data_items to the given value' do
      widget = ActsAsDashboard::ShortMessagesWidget.new :max_data_items => @options[:max_data_items]
      widget.instance_variable_get(:@max_data_items).should equal 5
    end
  end # }}}

  describe 'setting its "max_data_items" attribute' do # {{{
    it 'raises an error when given an invalid argument' do
      Proc.new {ActsAsDashboard::ShortMessagesWidget.new.max_data_items = 'fail'}.should raise_error ArgumentError,
        'The "max_data_items" argument must be a Fixnum.'
    end

    it 'is successful when given a Fixnum' do
      w                 = ActsAsDashboard::ShortMessagesWidget.new
      w.max_data_items  = 5

      w.instance_variable_get(:@max_data_items).should equal 5
    end
  end # }}}

  describe 'attributes' do # {{{
    before :each do
      @options = {
        :name             => :some_counter,
        :title            => 'Some Counter',
        :block            => Proc.new {123},
        :update_interval  => '10s',
        :max_data_items   => 5,
      }

      @widget = ActsAsDashboard::ShortMessagesWidget.new @options
    end

    it 'are returned in a Hash' do
      @options.delete :block    # Remove the "block" key because AAD::Widget#attributes doesn't return it on purpose.

      @widget.attributes.should == @options.merge(:type => :short_messages)
    end

    it 'returns the "max_data_items" attribute' do
      @widget.max_data_items.should equal @options[:max_data_items]
    end
  end # }}}
end
