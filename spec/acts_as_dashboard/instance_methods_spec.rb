require File.join File.dirname(__FILE__), '..', 'spec_helper'

class DashboardsController < ApplicationController
  acts_as_dashboard
end

describe ActsAsDashboard::InstanceMethods do
  it 'creates the "show" action for the controller' do
    DashboardsController.action_methods.should include 'show'
  end
end

describe DashboardsController, :type => :controller do
  describe 'GET "show"' do # {{{
    before :each do
      @widget_name1 = 'widget_name1'
      @widget_name2 = 'widget_name2'
      @widget1      = mock ActsAsDashboard::Widget, :name => @widget_name1
      @widget2      = mock ActsAsDashboard::Widget, :name => @widget_name2
      @widgets      = [@widget1, @widget2]
      @config       = mock ActsAsDashboard::Config, :widgets => @widgets

      controller.stub(:dashboard_config).and_return @config
      controller.stub(:render)
    end

    it 'grabs the dashboard config' do
      controller.should_receive(:dashboard_config).and_return @config
      get :show
    end

    it 'assigns @widgets as a String of widget names' do
      get :show
      assigns[:widget_names].should == "#{@widget_name1}, #{@widget_name2}"
    end

    it 'renders the "show" view template within the gem' do
      path_to_gem   = File.expand_path File.dirname(__FILE__) + '/../../'
      path_to_view  = "#{path_to_gem}/lib/acts_as_dashboard/app/views/dashboards/show.html.erb"

      controller.should_receive(:render).with(:file => path_to_view)
      get :show
    end
  end # }}}

  describe 'GET /widget/returns_ten' do
    before :each do
      @widget_name  = 'returns_ten'
      @block        = Proc.new {10}
      @widget       = mock ActsAsDashboard::Widget, :block => @block
      @config       = mock ActsAsDashboard::Config, :find_widget => @widget
      @params       = {:path => [@widget_name]}

      controller.stub(:dashboard_config).and_return @config
      controller.stub(:render)
    end

    describe 'when the widget exists' do # {{{
      it 'finds the requested widget' do
        @config.should_receive(:find_widget).with(@widget_name.to_s).and_return @widget
        get :widget_data, @params
      end

      it "calls the widget's block" do
        @block.should_receive(:call).with(no_args).and_return 10
        get :widget_data, @params
      end

      it "renders the output from the widget's block as text" do
        controller.should_receive(:render).with(:text => 10)
        get :widget_data, @params
      end
    end # }}}

    describe "when the widget doesn't exist" do # {{{
      before :each do
        @config.stub(:find_widget).and_return nil
      end

      it 'fails to find the widget' do
        @config.should_receive(:find_widget).and_return nil

        begin
          get :widget_data, @params
        rescue ActsAsDashboard::WidgetNotFound => e
        end
      end

      it 'raises an ActsAsDashboard::WidgetNotFound error' do
        Proc.new {
          get :widget_data, @params
        }.should raise_error ActsAsDashboard::WidgetNotFound, 'No widget named "returns_ten" found.'
      end
    end # }}}
  end
end
