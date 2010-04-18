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
  end
end
