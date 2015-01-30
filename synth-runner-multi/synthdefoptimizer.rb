require_relative 'synthdef'

class SynthDefOptimizer
  attr_accessor :sd

  def initialize(synthdef)
    @sd = synthdef
  end

  def count_hosts
    counts = Hash.new
    for key,host in @sd.hosts
      counts[host.alias] = 0
    end
    for key,block in @sd.blocks
      if (block.host)
        hostname = block.host.alias
        counts[hostname] ||= 0
        counts[hostname] += 1
      end
    end
    counts
  end

  def minhash(h)
    if h.length == 0
      return [nil,nil]
    end
    m = nil
    mk = nil
    h.each do |key,val|
      if m 
        if m > val
          mk = key
          m = val
        end
      else
        mk = key
        m = val
      end
    end
    return [mk,m]
  end
  def choose_host
    counts = self.count_hosts
    (key,val) = self.minhash(counts)
    return @sd.hosts[key]
  end

  def resolve(src)
    if src.is_a?(String)
      return @sd.blocks[src]
    else
      return src
    end
  end

  def remote(str)
    return "_remote:#{str}"
  end

  def extract_local_connections
    locals = @sd.connections.select do |conn|
      source  =  conn.source
      sink    =  conn.sink
      resolve(source).host == resolve(sink).host
    end
    remotes = self.extract_remote_connections
    localremotes = remotes.map do |conn|
      source  =  conn.source
      sink    =  conn.sink
      remsrc = self.remote(source)
      [SynthConnection.from(source, remsrc),SynthConnection.from(remsrc, sink)]
    end
    locals + localremotes.flatten
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
    @sd.slaves
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
      slave.alias = hostname
    end
  end

  def optimize
    # this will mutate the synthdef
    # assign synths to hosts
    slaves = self.slaves
    slaves.length >= @sd.hosts.length or raise "Not enough slaves given definition! Too many hosts! Too few slaves!"
    cores_needed = @sd.blocks.length
    cores = slaves.map {|x| x.cores}.inject(:+)
    overload = cores_needed < cores
    !overload or warn "Too many cores needed"
    # try assign hosts to blocks
    for (key,block) in @sd.blocks
      if (!block.host)
        block.host = self.choose_host()
        warn "Choosing HOST! #{block.host.alias}"
      end
    end
    #
    self.assign_hosts_to_slaves

    # once all the hosts are assigned we have to make local connections
    @sd.locals = self.extract_local_connections
    puts "SD LOCAL #{@sd.locals}"
    # once all the hosts are assigned we have to make remote connections
    @sd.remotes = self.extract_remote_connections
  end
end
