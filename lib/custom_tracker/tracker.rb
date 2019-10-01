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
    # @return [Table]
    def [](sym)
      @tables[sym]
    end

    ##
    # Creates new tracker.
    #
    # @param options [Hash]
    #
    # @option options [#call] saving_block callable object which must accept two
    #   parameters: [String] - name of table and {Array<Entry>} - entries to save.
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
    # @param options [Hash]
    #
    # @option options [Array<Symbol>] columns array of column names all the entries
    #   which are added to this table are required to store it.
    #
    # @return [Table] created table.
    def new_table(sym, options)
      raise ArgumentError, "sym must be a Symbol", caller unless sym.is_a? Symbol
      raise ArgumentError, "This table already exists", caller if @tables.has_key? sym
      table = Table.new(
        options.merge(
          saving_block: Proc.new do |arr|
            @saving_block.call(sym, arr)
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
    # @return [Entry, nil] {Entry} if it was saved or +nil+ if it wasn't.
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
