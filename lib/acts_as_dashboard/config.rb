module ActsAsDashboard
  class Config
    attr_reader :widgets

    def initialize
      @widgets = []
    end

    def add_widget(widget)
      raise ArgumentError, 'The "widget" argument must be an ActsAsDashboard::Widget.' unless widget.is_a? ActsAsDashboard::Widget
      @widgets.push widget
    end

    def find_widget(name)
      raise ArgumentError, 'The "name" argument must respond to #to_sym .' unless name.respond_to? :to_sym

      # We specifically use #find_all here so that we can grab the last widget with that name.
      # This allows users to define multiple widgets with the same name, and have only the last
      # be used.
      @widgets.find_all {|w| w.name == name.to_sym}.last
    end
  end
end
