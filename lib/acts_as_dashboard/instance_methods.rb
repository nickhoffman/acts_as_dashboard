module ActsAsDashboard
  module InstanceMethods
    def show
      @widget_names = dashboard_config.widgets.map {|w| w.name}.join ', '

      render :file => File.join(File.dirname(__FILE__), 'app', 'views', 'dashboards', 'show.html.erb')
    end
  end

  def widget_data
    name    = params[:path].first
    widget  = dashboard_config.find_widget name

    raise WidgetNotFound, %Q(No widget named "#{name}" found.) if widget.nil?

    render :text => widget.block.call
  end

  protected

    # Make the ActsAsDashboard::Config instance variable easily accessible.
    def dashboard_config
      self.class.dashboard_config
    end
end
