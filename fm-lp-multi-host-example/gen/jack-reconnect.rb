#!/usr/bin/ruby

require_relative 'jack-disconnect'

if $0 == __FILE__
  # disconnect all
  jack = Jack.new()
  if (ARGV.length >= 2)
    orig = ARGV[0]
    newout = ARGV[1]
    conns = jack.connections
    outputs = conns.select do |conn|
       conn[1] == orig
    end
    outputs.each do |arg|
      puts "Connect #{arg[0]} #{arg[1]}"
      #jack.disconnect(arg[0], arg[1])
      jack.connect(arg[0], newout)
    end
  else
    puts "jack-reconnect.rb output1 output2"
  end
end
