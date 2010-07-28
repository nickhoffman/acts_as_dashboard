module ActsAsDashboard
  class LineGraphWidget < ActsAsDashboard::Widget
    @@default_height  = '200px'
    @@default_width   = '400px'

    attr_reader :height
    attr_reader :width
    attr_reader :line_colours
    attr_reader :x_axis

    def initialize(options = {})
      options.delete :type

      # Allow American spelling of the word "colours".
      if options[:line_colors]
        options[:line_colours] = options[:line_colors]
        options.delete :line_colors
      end

      self.type         = :line_graph
      self.height       = options[:height ] || @@default_height
      self.width        = options[:width  ] || @@default_width
      self.line_colours = options[:line_colours]  if options[:line_colours]
      self.x_axis       = options[:x_axis]        if options[:x_axis]

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

    def line_colours=(line_colours)
      raise ArgumentError, 'The "line_colours" argument must be an Array of Strings.' unless line_colours.is_a? Array
      line_colours.each {|c| raise ArgumentError, 'The "line_colours" argument must be an Array of Strings.' unless c.is_a? String}

      @line_colours = line_colours
    end

    def x_axis=(type)
      valid_types = [:dates, :numbers]
      raise ArgumentError, %Q(The "x_axis" argument must be one of the following symbols: #{valid_types.join ', '}) unless valid_types.include? type

      @x_axis = type
    end

    # Allow American spelling of the word "colours".
    def line_colors
      line_colours
    end

    def attributes
      super.merge({
        :height       => @height,
        :width        => @width,
        :line_colours => @line_colours,
      })
    end
  end
end
