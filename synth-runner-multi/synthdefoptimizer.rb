require_relative 'synthdef'

class SynthDefOptimizer
  attr_accessor :sd

  def initialize(synthdef)
    @sd = synthdef
  end

  def count_hosts
    counts = Hash.new
    for key,block in @sd.blocks
      if (block.host)
        hostname = block.host.alias
        counts[hostname] ||= 0
        counts[hostname] += 1
      end
    end
    counts
  end

  def choose_host
    counts = self.count_hosts
    (key,val) = counts.min
    return @sd.hosts[key]
  end

  def resolve(src)
    if src.is_a?(String)
      return @sd.blocks[src]
    else
      return src
    end
  end

  def extract_local_connections
    locals = @sd.connections.select do |conn|
      source  =  conn.source
      sink    =  conn.sink
      resolve(source).host == resolve(sink).host
    end
    locals
  end

  def extract_remote_connections
    remotes = @sd.connections.select do |conn|
      source  =  conn.source
      sink    =  conn.sink
      resolve(source).host != resolve(sink).host
    end
    remotes
  end

  def slaves
    @sd.slaves.slaves
  end

  def assign_hosts_to_slaves
    "assign hosts to slaves"
    count = self.count_hosts.sort_by {|k,v| [v,k]}.reverse
    slaves = self.slaves.sort_by {|v| v.cores}.reverse
    mapping = count.zip(slaves).map do |tuple|
      hostname = tuple[0][0]
      count = tuple[0][1]
      slave = tuple[1]
      [hostname, slave]
    end
    mapping.each do |tuple|
      (hostname,slave) = tuple
      @sd.hosts[hostname].slave = slave
    end
  end

  def optimize
    # this will mutate the synthdef
    # assign synths to hosts
    slaves = @sd.slaves.slaves
    slaves.length >= @sd.hosts.length or raise "Not enough slaves given definition! Too many hosts! Too few slaves!"
    cores_needed = @sd.blocks.length
    cores = slaves.map {|x| x.cores}.inject(:+)
    overload = cores_needed < cores
    !overload or warn "Too many cores needed"
    # try assign hosts to blocks
    for (key,block) in @sd.blocks
      if (!block.host)
        block.host = self.choose_host()
      end
    end
    #
    self.assign_hosts_to_slaves

    # once all the hosts are assigned we have to make local connections
    @sd.locals = self.extract_local_connections
    # once all the hosts are assigned we have to make remote connections
    @sd.remotes = self.extract_remote_connections
  end
end
