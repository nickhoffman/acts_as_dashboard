module ActsAsDashboard
  module ClassMethods
    attr_reader :dashboard_config

    def acts_as_dashboard
      @dashboard_config = ActsAsDashboard::Config.new

      include InstanceMethods

      controller_name = self.to_s.underscore.sub('_controller', '').singularize

      ActionController::Routing::Routes.draw do |map|
        map.resource  controller_name.to_sym, :only => :show
        map.connect   "#{controller_name}/widgets/*path", :controller => controller_name.pluralize, :action => 'widget_data'
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
