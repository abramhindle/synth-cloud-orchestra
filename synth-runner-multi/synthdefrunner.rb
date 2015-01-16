#!/usr/bin/ruby
require "json"
require_relative "synthdef"
require_relative "synthrunner"
require_relative "slaves"


class SynthDefRunner
  attr_accessor :slaves
  def initialize(slaves)
    @slaves = slaves
  end
  def make_synthdef(synth_description)
    if (synth_description["type"] == "synthdef")
      return SynthDef.new(synth_description, slaves)
    else
      raise "Can't handle synth: #{synth_description}"
    end
  end

  def make_synthdef_from_file( filename )
    desc = JSON.load(open(filename).read)
    self.make_synthdef( desc )
  end

end


if $0 == __FILE__
  slaves = Slaves.make_slaves_from_file("slaves.json")
  synthrunner = SynthDefRunner.new(slaves)
  synth = synthrunner.make_synthdef_from_file("synthdef.json")
  require 'oj'
  puts Oj::dump synth, :indent => 2
  # in the gen folder make all the shell scripts we need
  synth.optimize()
  puts Oj::dump synth, :indent => 2
  synth.generate()
end

