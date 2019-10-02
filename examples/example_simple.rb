require_relative "helper"

include CustomTracker

puts "Spawning new table"
table = Table.new(
  columns: [:num, :zero],
  saving_block: Proc.new do |arr, t|
    puts "Pretending to save #{arr.size} entries:"
    puts arr
  end
)

5.times do |i|
  puts "Spawning new entry"
  entry = Entry.new num: i, zero: 0

  puts "Recording entry"
  table.record entry
  sleep 1
end

table.save
