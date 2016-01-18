require "option_parser"

require "./converter"

begin
  OptionParser.parse! do |parser|
    parser.banner = "Usage: oracle [options] source destination"
    parser.on("-h", "--help", "Show help") { puts parser }
    parser.unknown_args do |args1, args2|
      args = args1 + args2

      if args.empty? || args.size != 2
        puts parser
      else
        source, destination = args

        converter = Converter.new source, destination
        converter.convert
      end
    end
  end
rescue ex
  puts ex
end
