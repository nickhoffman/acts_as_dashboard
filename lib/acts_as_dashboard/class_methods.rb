module ActsAsDashboard
  module ClassMethods
    attr_reader :dashboard_config

    def acts_as_dashboard
      @dashboard_config = ActsAsDashboard::Config.new

      include InstanceMethods
    end

    def dashboard_number(&block)
      raise ArgumentError, 'A Proc must be given.' unless block_given?

      widget = Widget.new   :type => :number
      widget.instance_eval  &block

      dashboard_config.add_widget widget
    end
  end
end
