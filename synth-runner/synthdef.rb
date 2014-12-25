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
      blocks["key"] = SynthBlock.new(key,hashblocks[key])
    end
  end

  def parse_connections( hashconnections )
    connections = []
    return hashconnections.collect do |conn|
      SynthConnection.new(conn)
    end    
  end

  def run()
    # bring up the blocks
    promises = @blocks.keys.collect do |blockkey|
      @blocks[blockkey].run()
    end
    # wait?
    promises.each do |promise|
      promise.join
    end
    # connect them
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

  def run(blocks)
    source = blocks[@source]
    sink   = blocks[@sink]
    jack = Jack.new
    inputs  = source.get_jack_outputs
    outputs = sink.get_jack_inputs
    for i in 0..outputs.length
      jack.connect(inputs[i], outputs[i])
    end
    return Done.new()
end

class SynthBlock
  attr_accessor :name, :module, :runner
  def initialize( name, hash )
    @name = name
    @module = hash["module"]
    # if we have a real manifest hash
    hash["path"] = "#{Dir.pwd}/#{@module}"
    if (hash["main"])
      @runner = Synthrunner.make_synth(hash)
    else
      # otherwise default filename
      @runner = Synthrunner.make_synth_from_file("#{@module}/manifest.json")
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

class Promise
  def join

  end
end

class Done < Promise

end
