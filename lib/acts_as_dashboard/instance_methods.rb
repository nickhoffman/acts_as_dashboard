module ActsAsDashboard
  module InstanceMethods
    def show
      @json_widgets       = dashboard_config.widgets.map {|w| w.attributes}.to_json

      @dashboard_css_path = File.join(File.dirname(__FILE__), 'public', 'stylesheets', 'dashboard.css')
      @dashboard_css      = File.open(@dashboard_css_path).read

      @dashboard_js_path  = File.join(File.dirname(__FILE__), 'public', 'javascripts', 'dashboard.js')
      @dashboard_js       = File.open(@dashboard_js_path).read

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
