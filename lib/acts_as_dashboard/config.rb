module ActsAsDashboard
  class Config
    attr_reader :widgets

    def initialize
      @widgets = []
    end
  end
end
