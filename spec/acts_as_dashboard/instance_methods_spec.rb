require File.join File.dirname(__FILE__), '..', 'spec_helper'

class DashboardsController < ApplicationController
  acts_as_dashboard {}
end

describe ActsAsDashboard::InstanceMethods do
  it 'creates the "show" action for the controller' do
    DashboardsController.action_methods.should include 'show'
  end
end

describe DashboardsController, :type => :controller do
  describe 'GET "show"' do
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
  end
end
