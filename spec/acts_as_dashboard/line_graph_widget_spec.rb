require File.join File.dirname(__FILE__), '..', 'spec_helper'
require File.join File.dirname(__FILE__), '..', 'shared', 'widget_behaviours'

describe ActsAsDashboard::LineGraphWidget do
  it_should_behave_like 'an ActsAsDashboard Widget'

  describe 'initialization' do # {{{
    before :each do
      @options = {
        :width          => '400px',
        :height         => '200px',
        :line_colours   =>  %w(#4bb2c5 #c5b47f),
        :x_axis         => :dates,
      }
    end

    it 'removes the :type element from the given options' do
      options = {:type => :something}
      options.should_receive(:delete).with :type

      widget = ActsAsDashboard::LineGraphWidget.new options
    end

    it 'sets its type to :line_graph' do
      widget = ActsAsDashboard::LineGraphWidget.new
      widget.type.should equal :line_graph
    end

    it 'sets its height to the given value' do
      widget = ActsAsDashboard::LineGraphWidget.new :height => @options[:height]
      widget.height.should == @options[:height]
    end

    it 'sets its height to the default value if no value is given' do
      widget = ActsAsDashboard::LineGraphWidget.new
      widget.height.should == ActsAsDashboard::LineGraphWidget.send(:class_variable_get, :@@default_height)
    end

    it 'sets its width to the given value' do
      widget = ActsAsDashboard::LineGraphWidget.new :width => @options[:width]
      widget.width.should == @options[:width]
    end

    it 'sets its width to the default value if no value is given' do
      widget = ActsAsDashboard::LineGraphWidget.new
      widget.width.should == ActsAsDashboard::LineGraphWidget.send(:class_variable_get, :@@default_width)
    end

    it 'sets its line colours to the given value' do
      widget = ActsAsDashboard::LineGraphWidget.new :line_colours => @options[:line_colours]
      widget.line_colours.should == @options[:line_colours]
    end

    describe 'when given the "line_colors" (American spelling) option' do # {{{
      it 'copies the value to "line_colours"' do
        options = {:line_colors => @options[:line_colours]}
        widget = ActsAsDashboard::LineGraphWidget.new options
        options[:line_colours].should equal @options[:line_colours]
      end

      it 'deletes the "line_colors" option' do
        options = {:line_colors => @options[:line_colours]}
        widget = ActsAsDashboard::LineGraphWidget.new options
        options.should_not have_key :line_colors
      end

      it 'uses the value of "line_colors" as "line_colours"' do
        widget = ActsAsDashboard::LineGraphWidget.new :line_colors => @options[:line_colours]
        widget.line_colours.should == @options[:line_colours]
      end
    end # }}}

    it 'sets its x-axis to the given value' do
      widget = ActsAsDashboard::LineGraphWidget.new :x_axis => @options[:x_axis]
      widget.x_axis.should == @options[:x_axis]
    end

    it 'sets its x-axis to the default value if no value is given' do
      widget = ActsAsDashboard::LineGraphWidget.new
      widget.x_axis.should == ActsAsDashboard::LineGraphWidget.send(:class_variable_get, :@@default_x_axis)
    end
  end # }}}

  describe 'setting its "x_axis" attribute' do # {{{
    it 'raises an error when given an invalid value' do
      Proc.new {ActsAsDashboard::LineGraphWidget.new :x_axis => 'asdf'}.should raise_error ArgumentError,
        'The "x_axis" argument must be one of the following symbols: dates, numbers'
    end

    it 'is successful when given :dates' do
      widget = ActsAsDashboard::LineGraphWidget.new :x_axis => :dates
      widget.x_axis.should equal :dates
    end

    it 'is successful when given :numbers' do
      widget = ActsAsDashboard::LineGraphWidget.new :x_axis => :numbers
      widget.x_axis.should equal :numbers
    end
  end # }}}

  describe 'settings its "line_colours" attribute via #line_colour' do # {{{
    it 'raises an error when not given a String' do
      Proc.new {ActsAsDashboard::LineGraphWidget.new.line_colour = [1]}.should raise_error ArgumentError,
        'The "line_colour" argument must be a String.'
    end

    it 'passes the String in an Array to #line_colours=' do
      line_colour = 'green'
      w           = ActsAsDashboard::LineGraphWidget.new

      w.should_receive(:'line_colours=').with [line_colour]

      w.line_colour = line_colour
    end
  end # }}}

  describe 'setting its "line_colours" attribute' do # {{{
    it 'raises an error when not given an Array' do
      Proc.new {ActsAsDashboard::LineGraphWidget.new.line_colours = 'fail'}.should raise_error ArgumentError,
        'The "line_colours" argument must be an Array of Strings.'
    end

    it 'raises an error when not given an Array of Strings' do
      Proc.new {ActsAsDashboard::LineGraphWidget.new.line_colours = [1]}.should raise_error ArgumentError,
        'The "line_colours" argument must be an Array of Strings.'
    end

    it 'is successful when given an Array of Strings' do
      line_colours    = %w(#4bb2c5 #c5b47f)
      w                 = ActsAsDashboard::LineGraphWidget.new
      w.line_colours  = line_colours

      w.instance_variable_get(:@line_colours).should == line_colours
    end
  end # }}}

  describe 'attributes' do # {{{
    before :each do
      @options = {
        :name             => :some_counter,
        :title            => 'Some Counter',
        :block            => Proc.new {123},
        :update_interval  => '10s',
        :height           => '100px',
        :width            => '200px',
        :line_colours     => %w(#4bb2c5 #c5b47f),
        :x_axis           => :dates,
      }

      @widget = ActsAsDashboard::LineGraphWidget.new @options
    end

    it 'are returned in a Hash' do
      @options.delete :block    # Remove the "block" key because AAD::Widget#attributes doesn't return it on purpose.

      @widget.attributes.should == @options.merge(:type => :line_graph)
    end

    it 'returns the "height" attribute' do
      @widget.height.should equal @options[:height]
    end

    it 'returns the "width" attribute' do
      @widget.width.should equal @options[:width]
    end

    it 'returns the "line_colours" attribute' do
      @widget.line_colours.should equal @options[:line_colours]
    end

    describe 'when given the "line_colors" (American spelling) option' do # {{{
      it 'returns the "line_colours" attribute' do
        @widget.line_colors.should equal @options[:line_colours]
      end
    end # }}}

    it 'returns the "x_axis" attribute' do
      @widget.x_axis.should equal @options[:x_axis]
    end
  end # }}}
end
