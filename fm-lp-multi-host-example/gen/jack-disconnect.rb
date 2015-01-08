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
  def disconnect( source, sink )
    puts "jack_disconnect #{source} #{sink}"
    system('jack_disconnect', source, sink)
  end
  def disconnect_match( client )
    name = client
    self.connections.each do |conn|
      source, sink = conn
      if (source.match(/^#{name}:/) || 
          sink.match(/^#{name}:/) )
        self.disconnect(source, sink)
      end
    end
  end
  def connect( source, sink )
        system('jack_connect', source, sink)   
  end
  def get_dac
    return ["system:playback_1", "system:playback_2"]
  end
  def get_adc
    return ["system:capture_1", "system:capture_2"]
  end

end

if $0 == __FILE__
  # disconnect all
  jack = Jack.new()
  if (ARGV.length > 0)
    ARGV.each do |arg|
      jack.disconnect_match(arg)
    end
  else
    connections = jack.connections()
    connections.each do |conn| 
      jack.disconnect(conn[0], conn[1])
    end	
  end
end
