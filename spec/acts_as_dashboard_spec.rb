require File.join File.dirname(__FILE__), 'spec_helper'

describe ActsAsDashboard do
  it 'includes itself into classes that inherit from ActionController::Base' do
    class FooController < ActionController::Base; end

    FooController.included_modules.should include ActsAsDashboard
  end
end
