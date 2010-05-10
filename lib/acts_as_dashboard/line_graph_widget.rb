module ActsAsDashboard
  class LineGraphWidget < ActsAsDashboard::Widget
    @@default_height  = '200px'
    @@default_width   = '400px'

    attr_reader :height
    attr_reader :width

    def initialize(options = {})
      options.delete :type

      self.type   = :line_graph
      self.height = options[:height ] || @@default_height
      self.width  = options[:width  ] || @@default_width

      super
    end

    def height=(height)
      raise ArgumentError, 'The "height" argument must be a String.' unless height.is_a? String
      @height = height
    end

    def width=(width)
      raise ArgumentError, 'The "width" argument must be a String.' unless width.is_a? String
      @width = width
    end

    def attributes
      super.merge({
        :height => @height,
        :width  => @width,
      })
    end
  end
end
