require File.join File.dirname(__FILE__), '..', 'spec_helper'

describe ActsAsDashboard::ClassMethods do
  it 'makes its "dashboard_config" instance variable readable' do
    class DashboardsController < ApplicationController
      acts_as_dashboard
    end

    DashboardsController.dashboard_config.should be_a ActsAsDashboard::Config
  end

  describe '#acts_as_dashboard' do # {{{
    before :each do
      @config = mock ActsAsDashboard::Config
      ActsAsDashboard::Config.stub(:new).and_return @config
      ActionController::Routing::Routes.stub :add_named_route
    end

    it 'creates a Config object' do
      ActsAsDashboard::Config.should_receive(:new).and_return @config

      class DashboardsController < ApplicationController
        acts_as_dashboard
      end
    end

    it 'includes ActsAsDashboard::InstanceMethods' do
      class DashboardsController < ApplicationController
        acts_as_dashboard
      end

      DashboardsController.included_modules.should include ActsAsDashboard::InstanceMethods
    end

    it %Q(adds a named route for the dashboard's "show" action) do
      ActionController::Routing::Routes.should_receive(:add_named_route).with(
        'dashboard',
        'dashboard',
        :controller => :dashboards,
        :action     => :show
      )

      class DashboardsController < ApplicationController
        acts_as_dashboard
      end
    end

    it %Q(adds a named route for the dashboard's "widget_data" action) do
      ActionController::Routing::Routes.should_receive :add_named_route
      ActionController::Routing::Routes.should_receive(:add_named_route).with(
        'dashboard_widgets',
        'dashboard/widgets/*path',
        :controller => :dashboards,
        :action     => :widget_data
      )

      class DashboardsController < ApplicationController
        acts_as_dashboard
      end
    end
  end # }}}

  describe '#dashboard_number' do # {{{
    def call_dashboard_number
      DashboardsController.instance_eval do
        dashboard_number {}
      end
    end

    before :each do
      class DashboardsController < ApplicationController
        acts_as_dashboard
      end

      @widget = ActsAsDashboard::Widget.new :type => :number

      @widget.stub(:instance_eval)
      ActsAsDashboard::Widget.stub(:new).and_return @widget
    end

    it "raises an error if a Proc isn't provided" do
      Proc.new {
        class DashboardsController
          dashboard_number
        end
      }.should raise_error ArgumentError, 'A Proc must be given.'
    end

    it 'creates a "number" Widget' do
      ActsAsDashboard::Widget.should_receive(:new).with(:type => :number).and_return @widget
      call_dashboard_number
    end

    it 'evaluates the given Proc within the widget' do
      @widget.should_receive :instance_eval
      call_dashboard_number
    end

    it 'adds the widget to its configuration' do
      DashboardsController.dashboard_config.should_receive(:add_widget).with(@widget).and_return [@widget]
      call_dashboard_number
    end
  end # }}}

  describe '#dashboard_short_messages' do # {{{
    def call_dashboard_short_messages
      DashboardsController.instance_eval do
        dashboard_short_messages {}
      end
    end

    before :each do
      class DashboardsController < ApplicationController
        acts_as_dashboard
      end

      @widget = ActsAsDashboard::ShortMessagesWidget.new

      @widget.stub(:instance_eval)
      ActsAsDashboard::ShortMessagesWidget.stub(:new).and_return @widget
    end

    it "raises an error if a Proc isn't provided" do
      Proc.new {
        class DashboardsController
          dashboard_short_messages
        end
      }.should raise_error ArgumentError, 'A Proc must be given.'
    end

    it 'creates a "short messages" Widget' do
      ActsAsDashboard::ShortMessagesWidget.should_receive(:new).with(no_args).and_return @widget
      call_dashboard_short_messages
    end

    it 'evaluates the given Proc within the widget' do
      @widget.should_receive :instance_eval
      call_dashboard_short_messages
    end

    it 'adds the widget to its configuration' do
      DashboardsController.dashboard_config.should_receive(:add_widget).with(@widget).and_return [@widget]
      call_dashboard_short_messages
    end
  end # }}}

  describe '#dashboard_line_graph' do # {{{
    def call_dashboard_line_graph
      DashboardsController.instance_eval do
        dashboard_line_graph {}
      end
    end

    before :each do
      class DashboardsController < ApplicationController
        acts_as_dashboard
      end

      @widget = ActsAsDashboard::LineGraphWidget.new

      @widget.stub(:instance_eval)
      ActsAsDashboard::LineGraphWidget.stub(:new).and_return @widget
    end

    it "raises an error if a Proc isn't provided" do
      Proc.new {
        class DashboardsController
          dashboard_line_graph
        end
      }.should raise_error ArgumentError, 'A Proc must be given.'
    end

    it 'creates a Line Graph Widget' do
      ActsAsDashboard::LineGraphWidget.should_receive(:new).with(no_args).and_return @widget
      call_dashboard_line_graph
    end

    it 'evaluates the given Proc within the widget' do
      @widget.should_receive :instance_eval
      call_dashboard_line_graph
    end

    it 'adds the widget to its configuration' do
      DashboardsController.dashboard_config.should_receive(:add_widget).with(@widget).and_return [@widget]
      call_dashboard_line_graph
    end
  end # }}}
end
