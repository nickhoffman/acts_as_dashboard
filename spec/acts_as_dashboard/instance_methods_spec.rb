require File.join File.dirname(__FILE__), '..', 'spec_helper'

describe ActsAsDashboard::InstanceMethods do
  it 'creates the "show" action for the controller' do
    class DashboardsController < ApplicationController
      acts_as_dashboard {}
    end

    DashboardsController.action_methods.should include 'show'
  end
end
