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
end
