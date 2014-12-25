require_relative "synthrunner"

class SynthDef
  attr_accessor :blocks, :connections

  def initialize(hash)
    @blocks = self.parse_blocks(hash["blocks"])
    @connections = self.parse_connections(hash["connections"])
  end

  def parse_blocks( hashblocks )
    blocks = {}
    hashblocks.keys.each do |key|
      blocks[key] = SynthBlock.new(key,hashblocks[key])
    end
    blocks
  end

  def parse_connections( hashconnections )
    connections = []
    return hashconnections.collect do |conn|
      SynthConnection.new(conn)
    end    
  end

  def run()
    # bring up the blocks
    warn "Running"
    promises = @blocks.keys.collect do |blockkey|
      @blocks[blockkey].run()
    end
    # wait?
    promises.each do |promise|
      promise.join
    end
    # connect them
    warn "Connecting"
    promises = @connections.collect do |connection|
      connection.run(@blocks)
    end
    # wait?
    promises.each do |promise|
      promise.join
    end
  end

end

class SynthConnection
  attr_accessor :source, :sink
  def initialize( hash )
    @source = hash["source"]
    @sink = hash["sink"]
  end

  def process_key( key )
    dkey = key.downcase
    if (dkey == "adc" || dkey == "dac")
      return JackSinkSource.new
    end
    raise "no clue what to do with the key #{key}"
  end

  def run(blocks)    
    warn "#{@source} #{@sink} #{blocks.keys}"
    source = blocks[@source] 
    if ! source
      source = self.process_key(@source)      
    end
    sink   = blocks[@sink]  
    if ! sink
      sink = self.process_key(@sink)
    end
    jack = Jack.new
    inputs  = source.get_jack_outputs
    outputs = sink.get_jack_inputs
    for i in 0..(([outputs.length, inputs.length].min)-1)
      jack.connect(inputs[i], outputs[i])
    end
    return Done.new()
  end
end
  
class SynthBlock
  attr_accessor :name, :module, :runner
  def initialize( name, hash )
    @name = name
    @module = hash["module"]
    hash["name"] = name
    # if we have a real manifest hash
    hash["path"] = "#{Dir.pwd}/#{@module}"
    synthrunner = Synthrunner.new
    if (hash["main"])
      @runner = synthrunner.make_synth(hash)
    else
      # otherwise default filename
      @runner = synthrunner.make_synth_from_file("#{@module}/manifest.json", name=@name)
    end
  end
  
  def get_jack_outputs
    @runner.get_jack_outputs
  end
  def get_jack_inputs
    @runner.get_jack_inputs
  end
  def run
    @runner.run()
    return Done.new
  end
end

class JackSinkSource < SynthBlock
  attr_accessor :dac, :adc
  def initialize( )
    jack = Jack.new()
    @dac = jack.get_dac
    @adc = jack.get_adc
  end  
  def get_jack_outputs
    @adc
  end
  def get_jack_inputs
    @dac
  end
  def run
    return Done.new
  end
end



class Promise
  def join
    0
  end
end

class Done < Promise
  def join
    1
  end
end
