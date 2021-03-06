#!/usr/bin/ruby
require "json"
require_relative "synthdef"
require_relative "synthrunner"


class SynthDefRunner
  def make_synthdef(synth_description)
    if (synth_description["type"] == "synthdef")
      return SynthDef.new(synth_description)
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
  synthrunner = SynthDefRunner.new()
  synth = synthrunner.make_synthdef_from_file("synthdef.json")
  puts synth.to_json
  synth.run()
end
