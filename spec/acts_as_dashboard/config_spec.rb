require File.join File.dirname(__FILE__), '..', 'spec_helper'

describe ActsAsDashboard::Config do
  describe 'initialization' do # {{{
    it 'creates an array of widgets' do
      config = ActsAsDashboard::Config.new
      config.instance_variable_get(:@widgets).should == []
    end
  end # }}}

  describe 'attributes' do # {{{
    it 'returns the "widgets" attribute' do
      config = ActsAsDashboard::Config.new
      config.widgets.should equal config.instance_variable_get(:@widgets)
    end
  end # }}}

  describe 'adding a widget' do # {{{
    before :each do
      @config = ActsAsDashboard::Config.new
    end

    it 'raises an exception if given an invalid value' do
      Proc.new {@config.add_widget nil}.should raise_error ArgumentError,
        'The "widget" argument must be an ActsAsDashboard::Widget.'
    end

    it 'is successful when given an ActsAsDashboard::Widget' do
      widget = ActsAsDashboard::Widget.new

      @config.widgets.should == []
      @config.add_widget widget
      @config.widgets.should == [widget]
    end
  end # }}}
end
