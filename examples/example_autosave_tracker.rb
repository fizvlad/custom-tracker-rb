require_relative "helper"

include CustomTracker

puts "Spawning new tracker"
tracker = Tracker.new(
  saving_block: Proc.new do |arr, sym, t|
    puts "Pretending to save #{arr.size} entries in #{sym} table"
    arr.each do |entry|
      puts  "#{entry.id} at #{entry.time}: " + t.columns.map { |column| entry[column] }.join(", ")
    end
  end
)

puts "Adding tables"
tracker.new_table(:t1, columns: [:c1], autosave: 5)

entries = [
  Entry.new(c1: 1),
  Entry.new(c1: 2),
  Entry.new(c1: 3),
  Entry.new(c1: 4),
  Entry.new(c1: 5),
  Entry.new(c1: 6),
]

entries.each.with_index(1) do |e, i|
  puts "Saving entry #{i}"
  tracker.record_all e
end

# Only t4 table must save data
