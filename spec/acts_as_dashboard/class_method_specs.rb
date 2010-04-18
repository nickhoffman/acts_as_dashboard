require File.join File.dirname(__FILE__), '..', 'spec_helper'

describe ActsAsDashboard::ClassMethods do
  describe '#acts_as_dashboard' do # {{{
    before :each do
      @config = mock ActsAsDashboard::Config
      ActsAsDashboard::Config.stub(:new).and_return @config
    end

    it 'includes ActsAsDashboard::InstanceMethods' do
      class FoosController < ApplicationController
        acts_as_dashboard
      end

      FoosController.included_modules.should include ActsAsDashboard::InstanceMethods
    end

    it 'creates a Config object' do
      ActsAsDashboard::Config.should_receive(:new).and_return @config

      class FoosController < ApplicationController
        acts_as_dashboard
      end
    end
  end # }}}
end
