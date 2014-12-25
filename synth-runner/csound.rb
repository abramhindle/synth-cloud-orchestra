require_relative "jack"

class Csound
  attr_accessor :main, :inputs, :outputs, :path, :module, :name

  def gen_name()
    "csound" + @module
  end

  def initialize( synthdef )
    @main = synthdef["main"]
    @inputs = synthdef["inputs"] || 1
    @outputs = synthdef["outputs"] || 1
    @module = synthdef["module"] || @main.split(/\./)[0]
    @name = synthdef["name"] || self.gen_name()
    @path = synthdef["path"] || "."
  end

  def run( )
    clientname = @name
    # unsafe
    runstr = "cd #{@path} ; csound -iadc -odac -+rtaudio=jack -+jack_client=#{clientname} -b 500 -B 2000 #{@main} &"    
    system(runstr)
    # Csound 6.04 < have a bug where it needs to be connected
    (1..5).each do
      Jack.new.disconnect(clientname)
      sleep 1
    end
  end

  def get_jack_outputs
    (1..@outputs).collect { |i| "#{@name}:output#{i}" }
  end

  def get_jack_inputs
    (1..@outputs).collect { |i| "#{@name}:input#{i}" }
  end

end
