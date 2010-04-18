module ActsAsDashboard
  module ClassMethods
    def acts_as_dashboard
      @dashboard_config = ActsAsDashboard::Config.new

      include InstanceMethods
    end
  end
end
