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
tracker.new_table(:t1, columns: [:c1])
tracker.new_table(:t2, columns: [:c1, :c2])
tracker.new_table(:t3, columns: [:c2, :c3])
tracker.new_table(:t4, columns: [:c1, :c2, :c3])

entry1 = Entry.new c1: 1
entry2 = Entry.new c1: 2, c2: 3
entry3 = Entry.new c2: 4, c3: 5
entry4 = Entry.new c1: 6, c2:7, c3:8

tracker.record_all entry1
tracker.record_all entry2
tracker.record_all entry3
tracker.record_all entry4

tracker.save_all
