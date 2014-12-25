#!/usr/bin/ruby
name = ARGV[0]
# get the jack connection output
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

# for each connection we do see
# disconnect it
conns.each do |conn|
	source, sink = conn
	if (source.match(/^#{name}:/) || 
	    sink.match(/^#{name}:/) )
		system('jack_disconnect', source, sink)
	end
end
