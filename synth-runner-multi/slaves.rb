require "json"
class Slave
  attr_accessor :name, :host, :username, :cores, :memory, :masterjack, :alias
  def initialize(hash)
    @name = hash["name"]    
    @host = hash["host"]
    @username = hash["username"]
    @cores = hash["cores"] || 1
    @memory = hash["memory"] || 512
    @masterjack = hash["masterjack"] || 0
    @alias = hash["alias"] || nil
  end
  def self.make_slaves_from_hashes(list_of_hashes)
    return list_of_hashes.map {|x| Slave.new(x) }
  end
  def self.make_slaves_from_file(filename)
    desc = JSON.load(open(filename).read)
    return Slave.make_slaves_from_hashes( desc )
  end
  def hostname
    self.host
  end
end

