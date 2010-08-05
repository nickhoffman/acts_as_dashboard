class DashboardGenerator < Rails::Generator::Base
  attr_reader :base_name, :controller_name, :controller_filename

  @@default_name        = 'dashboard'
  @@show_view_file      = 'show.html.erb'
  @@dashboard_js_file   = 'dashboard.js'
  @@dashboard_css_file  = 'dashboard.css'
  @@jqplot_css_file     = 'jquery.jqplot.min.css'
  @@jqplot_js_dir       = 'jqplot-0.9.7'
  @@jsclass_js_dir      = 'js.class-2.1.4'
  @@jquery_ui_js_dir    = 'jquery-ui/js'
  @@jquery_ui_css_dir   = 'jquery-ui/css'
  @@public_js_dir       = File.join Rails.public_path, 'javascripts/'
  @@public_css_dir      = File.join Rails.public_path, 'stylesheets/'

  def manifest
    build_names args[0]
    build_routes @controller_name

    record do |m|
      m.directory File.join('app', 'views', @base_name)

      m.file @@show_view_file,      File.join('app',    'views',        @base_name, @@show_view_file)
      m.file @@dashboard_js_file,   File.join('public', 'javascripts',  @@dashboard_js_file         )
      m.file @@dashboard_css_file,  File.join('public', 'stylesheets',  @@dashboard_css_file        )
      m.file @@jqplot_css_file,     File.join('public', 'stylesheets',  @@jqplot_css_file           )

      m.template 'controller.erb',
        File.join('app', 'controllers', controller_filename),
        :assigns => {:controller_name => controller_name}

      if options[:command] == :create
        logger.directory File.join('public', 'javascripts', @@jqplot_js_dir , '/')
        FileUtils.cp_r source_path(@@jqplot_js_dir), @@public_js_dir unless options[:pretend]

        logger.directory File.join('public', 'javascripts', @@jsclass_js_dir , '/')
        FileUtils.cp_r source_path(@@jsclass_js_dir), @@public_js_dir unless options[:pretend]

        logger.directory File.join('public', 'javascripts', @@jquery_ui_js_dir, '/')
        m.directory File.join('public', 'javascripts', 'jquery-ui')
        FileUtils.cp_r source_path(@@jquery_ui_js_dir), File.join(@@public_js_dir, 'jquery-ui/') unless options[:pretend]

        logger.directory File.join('public', 'stylesheets', @@jquery_ui_css_dir, '/')
        m.directory File.join('public', 'stylesheets', 'jquery-ui')
        FileUtils.cp_r source_path(@@jquery_ui_css_dir), File.join(@@public_css_dir, 'jquery-ui/') unless options[:pretend]

        add_dashboard_routes controller_name
      elsif options[:command] == :destroy
        app_jqplot_js_dir   = File.join(@@public_js_dir, @@jqplot_js_dir)
        app_jsclass_js_dir  = File.join(@@public_js_dir, @@jsclass_js_dir)

        if File.directory? app_jqplot_js_dir and not options[:pretend]
          logger.rm File.join('public', 'javascripts', @@jqplot_js_dir , '/')
          FileUtils.rm_r app_jqplot_js_dir
        end

        if File.directory? app_jsclass_js_dir and not options[:pretend]
          logger.rm File.join('public', 'javascripts', @@jsclass_js_dir , '/')
          FileUtils.rm_r app_jsclass_js_dir
        end

        remove_dashboard_routes controller_name
      end
    end
  end

  protected

    def banner # {{{
      "Usage: #{$0} #{spec.name} [ControllerName]"
    end # }}}

    def build_names(original_name) # {{{
      @base_name            = (original_name || @@default_name).pluralize.downcase
      @controller_name      = @base_name.camelize   + 'Controller'
      @controller_filename  = @base_name.underscore + '_controller.rb'
    end # }}}
  
    def build_routes(controller_name) # {{{
      controller          = controller_name.downcase.gsub /controller$/, ''
      @singleton_resource = %Q(map.resource  :#{controller.singularize}, :only => :show)
      @widgets_route      = %Q(map.connect   '#{controller.singularize}/widgets/*path', :controller => :#{controller.pluralize}, :action => 'widget_data')
    end # }}}
  
    def add_dashboard_routes(controller_name) # {{{
      logger.route @singleton_resource
      logger.route @widgets_route
  
      return if options[:pretend]
  
      gsub_file 'config/routes.rb', /^end$/mi do |match|
        "\n  #{@singleton_resource}\n  #{@widgets_route}\n#{match}"
      end
    end # }}}
  
    def remove_dashboard_routes(controller_name) # {{{
      logger.route @singleton_resource
      logger.route @widgets_route
  
      return if options[:pretend]
  
      gsub_file 'config/routes.rb', /  #{Regexp.escape @singleton_resource}\n/mi, ''
      gsub_file 'config/routes.rb', /  #{Regexp.escape @widgets_route}\n/mi, ''
    end # }}}
  
    # Found in lib/rails_generator/commands.rb in Rails 2.3.5 .
    def gsub_file(relative_destination, regexp, *args, &block) # {{{
      path = destination_path(relative_destination)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end # }}}
end
