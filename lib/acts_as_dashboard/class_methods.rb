module ActsAsDashboard
  module ClassMethods
    attr_reader :dashboard_config

    def acts_as_dashboard
      @dashboard_config = ActsAsDashboard::Config.new

      include InstanceMethods

      controller_name = self.to_s.underscore.sub('_controller', '').singularize

#     # This is commented out because I haven't figured out how to tell Rails to
#     # actually recognize the new routes that are being created.
#     ActionController::Routing::Routes.draw do |map|
#       map.resource  controller_name.to_sym, :only => :show
#       map.connect   "#{controller_name}/widgets/*path", :controller => controller_name.pluralize, :action => 'widget_data'
#     end
    end

    def dashboard_number(&block)
      raise ArgumentError, 'A Proc must be given.' unless block_given?

      widget = Widget.new   :type => :number
      widget.instance_eval  &block

      dashboard_config.add_widget widget
    end

    def dashboard_short_messages(&block)
      raise ArgumentError, 'A Proc must be given.' unless block_given?

      widget = Widget.new :type => :short_messages
      widget.instance_eval &block

      dashboard_config.add_widget widget
    end
  end
end
