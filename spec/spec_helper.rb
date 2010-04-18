$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# Require the Rails application's spec_helper.
require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'spec', 'spec_helper')

Spec::Runner.configure do |config|
end

require 'acts_as_dashboard'
