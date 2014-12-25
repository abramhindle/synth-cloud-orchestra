require_relative "jack"

class Csound
  attr_accessor :main
  attr_accessor :inputs
  attr_accessor :outputs


  def gen_name()
    "csound" + @module
  end

  def initialize( synthdef )
    @main = synthdef["main"]
    @inputs = synthdef["inputs"] || 1
    @outputs = synthdef["outputs"] || 1
    @module = synthdef["module"] || @main.split(/\./)[0]
    @name = synthdef["name"] || self.gen_name()
  end

  def run( )
    clientname = @name
    runstr = "csound -iadc -odac -+rtaudio=jack -+jack_client=#{clientname} -b 500 -B 2000 #{@main} &"    
    system(runstr)
    # Csound 6.04 < have a bug where it needs to be connected
    (1..5).each do
      Jack.new.disconnect(clientname)
      sleep 1
    end
  end
end
