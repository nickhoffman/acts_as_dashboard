require File.join File.dirname(__FILE__), '..', 'spec_helper'

describe ActsAsDashboard::ClassMethods do
  describe '#acts_as_dashboard' do
    it 'includes ActsAsDashboard::InstanceMethods' do
      class FoosController < ApplicationController
        acts_as_dashboard
      end

      FoosController.included_modules.should include ActsAsDashboard::InstanceMethods
    end
  end
end
