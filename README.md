# CustomTracker

This small gem is created to help saving data on some common events.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'custom_tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install custom_tracker

## Usage

### Entries

Data bout some event must be stored in `Entry` object. Each of them stores it's unique ID, time of creation and provided data hash:

```ruby
entry = CustomTracker::Entry.new(
  type: :command_call,
  command: :help,
  author: "username",
  author_status: nil,
  server_id: 8675309
)
entry.id # => "5d943aa8a61d"
entry.time # => 2019-10-02 08:50:32 +0300
entry.columns # => [:type, :command, :author, :author_status, :server_id]
``` 
Notice that keys of provided hash must be symbols.

### Tables

`Table` objects provide interface for storing and exporting objects:

```ruby
server_events = CustomTracker::Table.new(
  columns: [:type, :server_id], # List of data which MUST exist in entries
  saving_block: Proc.new do |entries, table|
    # This block recieves array of entries which must be saved somewhere
    CSV.open("table.csv", "a") do |csv|
      entries.each do |entry|
        csv << [ entry.id, entry.time.to_i ] + table.columns.map { |c| entry[c] }
      end
    end
  end
)
```

To add event to table simply use method `Table#record`:

```ruby
server_events.record entry
server_events.size_unsaved # => 1
server_events.save # Export recorded entries using block above
server_events.size_unsaved # => 0
```

### Tracker

You can handle several tables using `Tracker`:

```ruby
tracker = CustomTracker::Tracker.new(
  saving_block: Proc.new do |entries, table_sym, table|
    # This block receives name entries to save, table symbol and table itself
    CSV.open("table_#{ table_sym }.csv", "a") do |csv|
      entries.each do |entry|
        csv << [ entry.id, entry.time.to_i ] + table.columns.map { |c| entry[c] }
      end
    end
  end
)

# Adding tables
tracker.new_table(:command_events, columns: [:type, :command])
tracker.new_table(:authored_events, columns: [:type, :author, :author_status])

# Recording
tracker.record_all entry

# Saving
tracker.save_all
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/custom_tracker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
