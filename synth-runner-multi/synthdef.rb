require_relative "synthrunner"
require_relative "synthdefoptimizer"

class SynthDef
  attr_accessor :blocks, :connections, :hosts, :slaves, :locals, :remotes

  def initialize(hash, slaves)
    @slaves = self.load_slaves(slaves)
    @hosts = self.parse_hosts(hash["hosts"])
    @blocks = self.parse_blocks(hash["blocks"])
    @connections = self.parse_connections(hash["connections"])
  end

  def load_slaves(slaves)
    return slaves
  end

  def parse_hosts( hashhosts )
    hosts = {}
    hashhosts.keys.each do |key|
      hosts[key] = SynthHost.new(key,hashhosts[key])
    end
    hosts
  end


  def parse_blocks( hashblocks )
    blocks = {}
    hashblocks.keys.each do |key|
      h = hashblocks[key]
      if h["host"]
        if @hosts[h["host"]]
          h["host"] = @hosts[h["host"]]
        end
      end
      blocks[key] = SynthBlock.new(key,h)
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

  def optimize
    optimizer = SynthDefOptimizer.new(self)
    optimizer.optimize()
  end
  def generate
    raise "Undone"
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
  attr_accessor :name, :module, :runner, :host
  def initialize( name, hash )
    @name = name
    @module = hash["module"]
    @host = hash["host"]
    hash["name"] = name
    # if we have a real manifest hash
    hash["path"] = "#{Dir.pwd}/#{@module}"
    synthrunner = Synthrunner.new
    if (hash["main"])
      @runner = synthrunner.make_synth(hash)
    else
      # otherwise default filename
      @runner = synthrunner.make_from_module(@module, name=@name)
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

class SynthHost
  attr_accessor :alias, :meta, :slave
  def initialize(hostalias,hash)
    @alias = hostalias
    @meta = hash
  end
end
