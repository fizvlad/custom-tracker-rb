module CustomTracker

  ##
  # A class to handle several tables.
  class Tracker

    ##
    # @return [Array<Symbol>] array of table names.
    def tables
      @tables.keys
    end

    ##
    # Access stored table.
    #
    # @return [Table]
    def [](sym)
      @tables[sym]
    end

    ##
    # Creates new tracker.
    #
    # @param options [Hash]
    #
    # @option options [#call] saving_block callable object which must accept following
    #   parameters: +Array<Entry>+ - entries to save, +Symbol+ - name of table and
    #   +Table+ for which this block will be called.
    def initialize(options)
      @saving_block = options[:saving_block]
      unless @saving_block.respond_to? :call
        raise ArgumentError, "saving_block is not responding to call method!", caller
      end

      @tables = {}
    end

    ##
    # Create new table and add it to handling.
    #
    # @param sym [Symbol]
    # @param options [Hash] options which will be passed to {Table.initialize}.
    #
    # @return [Table] created table.
    def new_table(sym, options)
      raise ArgumentError, "sym must be a Symbol", caller unless sym.is_a? Symbol
      raise ArgumentError, "This table already exists", caller if @tables.has_key? sym
      table = Table.new(
        options.merge(
          saving_block: Proc.new do |arr, table_local|
            @saving_block.call(arr, sym, table_local)
          end
        )
      )
      @tables[sym] = table

      table
    end

    ##
    # Records entry for every table
    #
    # @param entry [Entry]
    #
    # @return [Integer] amount of tables which registred 
    def record_all(entry)
      @tables.values.count { |t| t.record entry }
    end

    ##
    # Records entry for table.
    #
    # @param table_name [Symbol] name of table.
    # @param entry [Entry]
    #
    # @return [Entry, nil] +Entry+ if it was saved or +nil+ if it wasn't.
    def record(table_name, entry)
      @tables[table_name].record entry
    end

    ##
    # Saves all the tables.
    #
    # @return [nil]
    def save_all
      @tables.values.each(&:save)
      nil
    end

    ##
    # Saves the table.
    #
    # @param table_name [Symbol] name of table.
    #
    # @return [Integer] amount of saved entries.
    def save(table_name)
      @tables[table_name].save
    end

  end

end
