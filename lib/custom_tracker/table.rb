module CustomTracker

  ##
  # A group of entries with similar data.
  class Table
    include Enumerable

    ##
    # @return [Integer] total amount of entries.
    def size
      size_unsaved + size_saved
    end

    ##
    # @return [Integer] amount of unsaved entries.
    def size_unsaved
      @unsaved_entries.size
    end

    ##
    # @return [Integer] amount of saved entries.
    def size_saved
      @size_saved
    end

    ##
    # @return [Array<Symbol>] Array of column names.
    attr_reader :columns

    ##
    # Creates new table.
    #
    # @param options [Hash]
    #
    # @option options [Array<Symbol>] columns array of column names all the entries
    #   which are added to this table are required to store it.
    # @option options [#call] saving_block callable object which must accept
    #   +Array<Entry>+ - array of entries to save and +Table+ - +self+
    def initialize(options)
      @columns = options[:columns].select { |s| s.is_a? Symbol }
      @columns.freeze

      @saving_block = options[:saving_block]
      unless @saving_block.respond_to? :call
        raise ArgumentError, "saving_block is not responding to call method!", caller
      end

      @size_saved = 0
      @unsaved_entries = []
      @mutex = Mutex.new
    end

    ##
    # @param entry [Entry]
    # 
    # @return [Boolean] whether this entry is acceptable.
    def accepts?(entry)
      @columns.all? { |sym| entry.has? sym }
    end

    ##
    # Checks whether this entry is acceptable and saves it.
    #
    # @param entry [Entry, Hash<Symbol, Object>] if +Hash+ provided, +Entry+ will
    #   be created automatically with {Entry#initialize}.
    # @param options [Hash]
    #
    # @option options [Boolean] instant_save if enabled {Table#save} will be called after adding.
    #
    # @return [Entry, nil] +Entry+ if it was saved or +nil+ if it wasn't.
    def record(entry, options = {})
      entry = Entry.new(entry) if entry.is_a? Hash

      instant_save = !!options[:instant_save]

      if accepts? entry
        @unsaved_entries.push(entry)
        save if instant_save
        entry
      else
        nil
      end
    end

    ##
    # Saves all unsaved entries.
    #
    # Execution of this method is syncronized with +Mutex+ local to current table.
    #
    # @return [Integer] amount of saved entries.
    def save
      @mutex.synchronize do
        @saving_block.call(@unsaved_entries, self)
        re = @unsaved_entries.size
        @size_saved += re
        @unsaved_entries.clear

        re
      end
    end

  end

end
