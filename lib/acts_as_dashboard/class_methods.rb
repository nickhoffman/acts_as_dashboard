module ActsAsDashboard
  module ClassMethods
    def acts_as_dashboard
      include InstanceMethods
    end
  end
end
