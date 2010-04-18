require File.join File.dirname(__FILE__), '..', 'spec_helper'

describe ActsAsDashboard::Widget do
  before :each do
    @options = {
      :type             => :number,
      :name             => :some_counter,
      :title            => 'Some Counter',
      :block            => Proc.new {123},
      :update_interval  => '10s',
    }
  end

  describe 'initialization' do # {{{
    it 'accepts no args' do
      Proc.new {ActsAsDashboard::Widget.new}.should_not raise_error
    end

    it 'sets its "type" attribute' do
      w = ActsAsDashboard::Widget.new :type => @options[:type]
      w.instance_variable_get(:@type).should equal @options[:type]
    end

    it 'sets its "name" attribute' do
      w = ActsAsDashboard::Widget.new :name => @options[:name]
      w.instance_variable_get(:@name).should equal @options[:name]
    end

    it 'sets its "title" attribute' do
      w = ActsAsDashboard::Widget.new :title => @options[:title]
      w.instance_variable_get(:@title).should == @options[:title]
    end

    it 'sets its "block" attribute' do
      w = ActsAsDashboard::Widget.new :block => @options[:block]
      w.instance_variable_get(:@block).should equal @options[:block]
    end

    it 'sets its "update_interval" attribute to a String' do
      w = ActsAsDashboard::Widget.new :update_interval => '10s'
      w.instance_variable_get(:@update_interval).should == '10s'
    end

    it 'sets its "update_interval" attribute to a Fixnum' do
      w = ActsAsDashboard::Widget.new :update_interval => 123
      w.instance_variable_get(:@update_interval).should equal 123
    end
  end # }}}

  describe 'setting its "type" attribute' do # {{{
    it 'is successful when given a Symbol' do
      w       = ActsAsDashboard::Widget.new
      w.type  = @options[:type]

      w.instance_variable_get(:@type).should equal @options[:type]
    end

    it 'raises an exception if given an invalid value' do
      Proc.new {ActsAsDashboard::Widget.new.type = 'fail'}.should raise_error ArgumentError,
        'The "type" argument must be a Symbol.'
    end
  end # }}}

  describe 'setting its "name" attribute' do # {{{
    it 'is successful when given a Symbol' do
      w       = ActsAsDashboard::Widget.new
      w.name  = @options[:name]

      w.instance_variable_get(:@name).should equal @options[:name]
    end

    it 'raises an exception if given an invalid value' do
      Proc.new {ActsAsDashboard::Widget.new.name = 'fail'}.should raise_error ArgumentError,
        'The "name" argument must be a Symbol.'
    end
  end # }}}

  describe 'setting its "title" attribute' do # {{{
    it 'is successful when given a String' do
      w       = ActsAsDashboard::Widget.new
      w.title = @options[:title]

      w.instance_variable_get(:@title).should == @options[:title]
    end

    it 'raises an exception if given an invalid value' do
      Proc.new {ActsAsDashboard::Widget.new.title = 123}.should raise_error ArgumentError,
        'The "title" argument must be a String.'
    end
  end # }}}

  describe 'setting its "block" attribute' do # {{{
    it 'is successful when given a Proc' do
      w       = ActsAsDashboard::Widget.new
      w.block = @options[:block]

      w.instance_variable_get(:@block).should equal @options[:block]
    end

    it 'raises an exception if given an invalid value' do
      Proc.new {ActsAsDashboard::Widget.new.block = 'fail'}.should raise_error ArgumentError,
        'The "block" argument must be a Proc.'
    end

    it 'can be passed as a block' do
      w = ActsAsDashboard::Widget.new

      w.instance_variable_get(:@block).should be_nil
      w.data do; end

      w.instance_variable_get(:@block).should be_a Proc
    end
  end # }}}

  describe 'setting its "update_interval" attribute' do # {{{
    it 'is successful when given a String' do
      w                 = ActsAsDashboard::Widget.new
      w.update_interval = '10s'

      w.instance_variable_get(:@update_interval).should == '10s'
    end

    it 'is successful when given a Fixnum' do
      w                 = ActsAsDashboard::Widget.new
      w.update_interval = 123

      w.instance_variable_get(:@update_interval).should equal 123
    end

    it 'raises an exception if given an invalid value' do
      Proc.new {ActsAsDashboard::Widget.new.update_interval = :fail}.should raise_error ArgumentError,
        'The "update_interval" argument must be a Fixnum or String.'
    end
  end # }}}

  describe 'attributes' do # {{{
    before :each do
      @widget = ActsAsDashboard::Widget.new @options
    end

    it 'are returned in a Hash' do
      @options.delete :block    # Remove the "block" key because AAD::Widget#attributes doesn't return it on purpose.

      @widget.attributes.should == @options
    end

    it 'returns the "type" attribute' do
      @widget.type.should equal @options[:type]
    end

    it 'returns the "name" attribute' do
      @widget.name.should equal @options[:name]
    end

    it 'returns the "title" attribute' do
      @widget.title.should == @options[:title]
    end

    it 'returns the "block" attribute' do
      @widget.block.should equal @options[:block]
    end

    it 'returns the "update_interval" attribute' do
      @widget.update_interval.should == @options[:update_interval]
    end
  end # }}}
end
