module ActsAsDashboard
  module InstanceMethods
    def show
      @widget_names = dashboard_config.widgets.map {|w| w.name}.join ', '

      render :file => File.join(File.dirname(__FILE__), 'app', 'views', 'dashboards', 'show.haml')
    end
  end

  protected

    # Make the ActsAsDashboard::Config instance variable easily accessible.
    def dashboard_config
      self.class.dashboard_config
    end
end
