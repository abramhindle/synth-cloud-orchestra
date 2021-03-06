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
    dflname = Pathname.new(filename).realpath.dirname.basename.to_s
    desc["name"] ||= dflname
    self.make_synthdef( desc )
  end

end

def json_dump_to_file(obj,filename)
  require 'oj'
  str = Oj::dump obj, :indent => 2
  puts str
  f = File.new(filename,"w")
  f.write( str )
  f.close
end

if $0 == __FILE__
  slaves = Slave.make_slaves_from_file("slaves.json")
  synthrunner = SynthDefRunner.new(slaves)
  synth = synthrunner.make_synthdef_from_file("synthdef.json")
  json_dump_to_file(synth,"pass1.json")
  # in the gen folder make all the shell scripts we need
  synth.optimize()
  json_dump_to_file(synth,"pass2.json")
  synth.generate()
end

