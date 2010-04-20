module ActsAsDashboard
  module ClassMethods
    attr_reader :dashboard_config

    def acts_as_dashboard
      @dashboard_config = ActsAsDashboard::Config.new

      include InstanceMethods

      controller_name = self.to_s.underscore.sub('_controller', '').singularize.to_sym

      ActionController::Routing::Routes.draw do |map|
        map.resource  controller_name, :only => :show
      end
    end

    def dashboard_number(&block)
      raise ArgumentError, 'A Proc must be given.' unless block_given?

      widget = Widget.new   :type => :number
      widget.instance_eval  &block

      dashboard_config.add_widget widget
    end
  end
end
