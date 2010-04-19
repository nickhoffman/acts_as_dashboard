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
end
