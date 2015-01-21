class NoSynth
  attr_accessor :main, :inputs, :outputs, :path, :module, :name

  def gen_name(name=nil)
    @module + ( name ? name : "")
  end

  def initialize( synthdef )
    @main = synthdef["main"]
    @inputs = synthdef["inputs"] || 1
    @outputs = synthdef["outputs"] || 1
    @module = synthdef["module"] || @main.split(/\./)[0]
    @name = self.gen_name( synthdef["name"] )
    @path = synthdef["path"] || "."
  end

  def run( )
  end

  def get_jack_outputs
    (1..@outputs).collect { |i| "system:capture_#{i}" }
  end

  def get_jack_inputs
    (1..@outputs).collect { |i| "system:playback_#{i}" }
  end

  def command()
    ""
  end

end
