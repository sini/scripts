#!/usr/bin/env ruby
#

@block_regexp = Regexp.compile(/([\w|@]+)\b:\s(\S+(?:\s+(?:@\s[\w\[\]\s]+|[\d\:\.]+))?)?/)

def parse_message(msg)
  #split the message into comment block and queries
  block, q_head, q_tail = msg.split(/^([^#])/, 2)
  q_block = q_head + q_tail

  block_values = {}
  block.scan(@block_regexp).each do |y|
    block_values[y[0].to_s] = y[1] != nil ? y[1].strip : nil
  end

  queries = q_block.strip.split(";").map {|x| x.strip + ";" }

  return block_values, queries
end

filename = "example.log"
messages = File.read(filename).split("# Time").drop(1).map { |msg| "# Time" + msg }
messages.each do |msg|
  fields, queries = parse_message(msg)
  puts "Fields: "
  fields.each do |k,v|
    puts "\t[#{k}]: \"#{v}\""
  end
  puts "Queries: "
  queries.each do |q|
    print "Query:\n\t#{q}\n"
  end
  puts "-------------------------------------------------------------------------"
end
