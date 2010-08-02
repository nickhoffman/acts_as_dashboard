module ActsAsDashboard
  module ClassMethods
    attr_reader :dashboard_config

    def acts_as_dashboard
      @dashboard_config = ActsAsDashboard::Config.new

      include InstanceMethods

      controller_name = self.to_s.underscore.sub('_controller', '').singularize

#     # This is commented out because having it here doesn't actually work. I believe this
#     # is because calls to #acts_as_dashboard within controllers aren't invoked until one
#     # of the controller's actions is called. However, it's impossible to call one of the
#     # actions of an acts_as_dashboard-enabled controller because there aren't any routes
#     # yet! It's a catch-22. Argh.
#
#     # Create the route for the "show" action. This will be something like:
#     #   /dashboard
#     ActionController::Routing::Routes.add_named_route(
#       'dashboard',
#       controller_name,
#       :controller => controller_name.pluralize.to_sym,
#       :action     => :show
#     )
#
#     # Create the route for the "widget_data" action. This will be something like:
#     #   /dashboard/widgets/*
#     ActionController::Routing::Routes.add_named_route(
#       "#{controller_name}_widgets",
#       "#{controller_name}/widgets/*path",
#       :controller => controller_name.pluralize.to_sym,
#       :action     => :widget_data
#     )
    end

    def dashboard_number(&block)
      raise ArgumentError, 'A Proc must be given.' unless block_given?

      widget = Widget.new   :type => :number
      widget.instance_eval  &block

      dashboard_config.add_widget widget
    end

    def dashboard_short_messages(&block)
      raise ArgumentError, 'A Proc must be given.' unless block_given?

      widget = ShortMessagesWidget.new
      widget.instance_eval &block

      dashboard_config.add_widget widget
    end

    def dashboard_line_graph(&block)
      raise ArgumentError, 'A Proc must be given.' unless block_given?

      widget = LineGraphWidget.new
      widget.instance_eval &block

      dashboard_config.add_widget widget
    end
  end
end
