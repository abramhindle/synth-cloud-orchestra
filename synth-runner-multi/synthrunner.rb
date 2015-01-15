#!/usr/bin/ruby
require "json"
require "pathname"
require_relative "csound"

class Synthrunner
  def make_synth(synth_description)
    if (synth_description["synth"] == "csound")
      return Csound.new(synth_description)
    else
      raise "Can't handle synth: #{synth_description}"
    end
  end

  def make_synth_from_file( filename, name=nil )
    desc = JSON.load(open(filename).read)
    path = Pathname.new(filename).dirname
    desc["path"] ||= path 
    desc["name"] ||= name
    self.make_synth( desc )
  end

end

if $0 == __FILE__
  synthrunner = Synthrunner.new()
  synth = synthrunner.make_synth_from_file("manifest.json")
  puts synth.to_json
  synth.run()
end
