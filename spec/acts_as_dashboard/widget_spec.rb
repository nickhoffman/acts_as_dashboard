require File.join File.dirname(__FILE__), '..', 'spec_helper'
require File.join File.dirname(__FILE__), '..', 'shared', 'widget_behaviours'

describe ActsAsDashboard::Widget do
  it_should_behave_like 'an ActsAsDashboard Widget'
end
