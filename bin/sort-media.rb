require 'optparse'
require_relative '../lib/media_sorter'

options = { batch_size: 100, dry_run: true }

option_parser = OptionParser.new do |opts|
  opts.banner = "Usage: sort-media.rb [source_dir] [target_dir] [options]"

  opts.on("-b", "--batch-size SIZE", Integer, "Number of files to process in a batch") do |b|
    options[:batch_size] = b
  end

  opts.on("--no-dry-run", "Run the sorter without dry run mode") do
    options[:dry_run] = false
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end

if ARGV.length < 2
  puts "Error: Source and target directories are required."
  puts option_parser
  exit 1
end

source_dir = ARGV[0]
target_dir = ARGV[1]

begin
  option_parser.parse!
  if ARGV.empty?
    puts option_parser
    exit
  end
rescue OptionParser::InvalidOption => e
  puts e.message
  puts option_parser
  exit 1
end

puts "Source directory: #{source_dir}"
puts "Target directory: #{target_dir}"
puts "Batch size: #{options[:batch_size]}"
puts "Dry run: #{options[:dry_run]}"
puts "-------------------------"
puts

sorter = MediaSorter.new(
  source_dir,
  target_dir,
  batch_size: options[:batch_size],
  dry_run: options[:dry_run]
)
sorter.run

