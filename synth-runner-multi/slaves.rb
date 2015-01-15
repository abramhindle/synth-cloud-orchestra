require "json"
class Slave
  attr_accessor :name, :host, :username, :cores, :memory, :masterjack
  def initialize(hash)
    @name = hash["name"]
    @host = hash["host"]
    @username = hash["username"]
    @cores = hash["cores"] || 1
    @memory = hash["memory"] || 512
    @masterjack = hash["masterjack"] || 0
  end
end

class Slaves
  attr_accessor :slaves
  def initialize(list_of_hashes)
    @slaves = hashes.map {|x| Slave.new(x) } 
  end
  def self.make_slaves_from_file(filename)
    desc = JSON.load(open(filename).read)
    Slaves.new( desc )
  end
end

