module ActsAsDashboard
  class ShortMessagesWidget < ActsAsDashboard::Widget
    @@default_max_data_items = 5

    attr_reader :max_data_items

    def initialize(options = {})
      options.delete :type

      self.type           = :short_messages
      self.max_data_items = options[:max_data_items] || @@default_max_data_items

      super
    end

    def max_data_items=(max_data_items)
      raise ArgumentError, 'The "max_data_items" argument must be a Fixnum.' unless max_data_items.is_a? Fixnum
      @max_data_items = max_data_items
    end

    def attributes
      super.merge(:max_data_items => @max_data_items)
    end
  end
end
