require File.join File.dirname(__FILE__), 'spec_helper'

describe ActsAsDashboard do
  before :each do
    class FoosController < ActionController::Base; end
  end

  it 'includes itself into classes that inherit from ActionController::Base' do
    FoosController.included_modules.should include ActsAsDashboard
  end

  it 'extends ActsAsDashboard::ClassMethods into classes that include it' do
    FoosController.extended_by.should include ActsAsDashboard::ClassMethods
  end
end
