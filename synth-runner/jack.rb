#!/usr/bin/ruby

class Jack
  attr_accessor :connections
  def connections()
    output = `jack_lsp -c`
    
    # process the text, building connections
    connections = output.split(/\n/)
    last = connections.shift
    conns = []
    connections.each do |connection|
      matches = connection.match(/^ +(.*)$/)
      if (matches)
        sink = matches[1]
        source = last
        conns += [[source,sink]]
      else
        last = connection
      end
    end
    @connections = conns
    return conns
  end
  def disconnect( client )
    name = client
    self.connections.each do |conn|
      source, sink = conn
      if (source.match(/^#{name}:/) || 
          sink.match(/^#{name}:/) )
        system('jack_disconnect', source, sink)
      end
    end
  end
end

if $0 == __FILE__
  name = ARGV[0]
  jack = Jack.new()
  jack.disconnect( name )
end
