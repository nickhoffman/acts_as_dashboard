class ActionController::Base
  class << self
    def inherited_with_acts_as_dashboard_include(child)
      inherited_without_acts_as_dashboard_include child

      child.send :include, ActsAsDashboard
    end

    alias_method_chain :inherited, :acts_as_dashboard_include
  end
end

module ActsAsDashboard
  def self.included(base)
    base.extend ClassMethods
  end
end
