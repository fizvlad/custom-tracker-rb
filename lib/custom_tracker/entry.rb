module CustomTracker

  ##
  # Single tracker entry.
  class Entry
    include Enumerable

    ##
    # Calls the given block once for each pair in data.
    #
    # @yieldparam [Symbol] key
    # @yieldparam [Object] value
    #
    # @return [self]
    def each(&block)
      @data.each &block
    end

    ##
    # @return [Time] time of entry creation
    attr_reader :time

    ##
    # @return [String] id of entry
    attr_reader :id

    ##
    # @return [Array<Symbols>] Array of column names.
    def columns
      @data.keys
    end

    ##
    # @param sym [Symbol]
    #
    # @return [Object] data from entry.
    def [](sym)
      @data[sym]
    end

    ##
    # @param sym [Symbol]
    #
    # @return [Boolean] whether entry stores this column.
    def has?(sym)
      @data.has_key?(sym)
    end

    ##
    # @return [String] human-readable string.
    def to_s
      <<~HEREDOC
        Entry #{@id} from #{@time}. Data: #{@data}
      HEREDOC
    end

    ##
    # Creates new entry.
    #
    # @param data [Hash<Symbol, Object>]
    def initialize(data)
      @time = Time.now
      @time.freeze

      # Generating id from current time and random suffix
      @id = (@time.to_i * 65536 + rand(65536)).to_s(16)
      @id.freeze

      @data = {}
      data.each_pair do |key, value|
        next unless key.is_a? Symbol
        @data[key] = value
      end
      @data.freeze
    end

  end

end
