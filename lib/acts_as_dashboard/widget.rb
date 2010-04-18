module ActsAsDashboard
  class Widget
    attr_reader :type
    attr_reader :name
    attr_reader :title
    attr_reader :block
    attr_reader :update_interval

    def initialize(options = {})
      self.type             = options[:type]            if options[:type]
      self.name             = options[:name]            if options[:name]
      self.title            = options[:title]           if options[:title]
      self.block            = options[:block]           if options[:block]
      self.update_interval  = options[:update_interval] if options[:update_interval]
    end

    def type=(type)
      raise ArgumentError, 'The "type" argument must be a Symbol.' unless type.is_a? Symbol
      @type = type
    end

    def name=(name)
      raise ArgumentError, 'The "name" argument must be a Symbol.' unless name.is_a? Symbol
      @name = name
    end

    def title=(title)
      raise ArgumentError, 'The "title" argument must be a String.' unless title.is_a? String
      @title = title
    end

    def block=(block)
      raise ArgumentError, 'The "block" argument must be a Proc.' unless block.is_a? Proc
      @block = block
    end

    def data(&block)
      self.block = block
    end

    def update_interval=(update_interval)
      raise ArgumentError, 'The "update_interval" argument must be a Fixnum or String.' unless [Fixnum, String].include? update_interval.class
      @update_interval = update_interval
    end

    def attributes
      {
        :type             => @type,
        :name             => @name,
        :title            => @title,
        :update_interval  => @update_interval,
      }
    end
  end
end
