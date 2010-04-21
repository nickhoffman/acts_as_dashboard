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
      @widget_attributes  = {:name => :some_name, :title => 'Some Title', :update_interval => '10s', :type => :number}
      @json               = '[{"type":"number","title":"Some Title","name":"some_name","update_interval":"10s"}]'
      @widget             = mock ActsAsDashboard::Widget, :attributes => @widget_attributes
      @config             = mock ActsAsDashboard::Config, :widgets => [@widget]

      controller.stub(:dashboard_config).and_return @config
      controller.stub(:render)
    end

    it 'grabs the dashboard config' do
      controller.should_receive(:dashboard_config).and_return @config
      get :show
    end

    it "grabs each widget's attributes" do
      @widget.should_receive(:attributes).and_return @widget_attributes
      get :show
    end

    it "converts each widget's attributes to JSON" do
      @widget_attributes.should_receive(:to_json).and_return @json
      get :show
    end

    it 'assigns @json_widgets as a String of widget attributes in JSON' do
      get :show
      assigns[:json_widgets].should == @json
    end

    it 'assigns @dashboard_css_path as the path to the CSS script' do
      get :show

      assigns[:dashboard_css_path].should == File.expand_path(File.join(
        File.dirname(__FILE__), '..', '..', 'lib', 'acts_as_dashboard', 'public', 'stylesheets', 'dashboard.css'
      ))
    end

    it 'assigns @dashboard_css as the CSS for the dashboard' do
      get :show

      css_file = File.join File.dirname(__FILE__), '..', '..', 'lib', 'acts_as_dashboard', 'public', 'stylesheets', 'dashboard.css'
      assigns[:dashboard_css].should == File.open(css_file).read
    end

    it 'assigns @dashboard_js_path as the path to the JavaScript script' do
      get :show

      assigns[:dashboard_js_path].should == File.expand_path(File.join(
        File.dirname(__FILE__), '..', '..', 'lib', 'acts_as_dashboard', 'public', 'javascripts', 'dashboard.js'
      ))
    end

    it 'assigns @dashboard_js_path as the JavaScript for the dashboard' do
      get :show

      js_file = File.join File.dirname(__FILE__), '..', '..', 'lib', 'acts_as_dashboard', 'public', 'javascripts', 'dashboard.js'
      assigns[:dashboard_js].should == File.open(js_file).read
    end

    it 'renders the "show" view template within the gem' do
      path_to_gem   = File.expand_path File.dirname(__FILE__) + '/../../'
      path_to_view  = "#{path_to_gem}/lib/acts_as_dashboard/app/views/dashboards/show.html.erb"

      controller.should_receive(:render).with(:file => path_to_view)
      get :show
    end
  end # }}}

  describe 'GET /widget/returns_ten' do # {{{
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
  end # }}}
end
