require_relative "helper"

include CustomTracker

puts "Spawning new table"
table = Table.new(
  columns: [:num, :zero],
  saving_block: Proc.new do |arr|
    puts "Saving table"
    CSV.open("table.csv", "a") do |csv|
      arr.each do |entry|
        csv << [ entry.id, entry.time.to_i, entry[:num], entry[:zero] ]
      end
    end
  end
)

2.times do |j|

  5.times do |i|
    puts "Spawning new entry"
    entry = Entry.new num: i, zero: 0

    puts "Recording entry"
    table.record entry
    sleep 1
  end

  table.save

  sleep 1
end

puts "Results are saved to table.csv file"
