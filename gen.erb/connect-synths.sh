#!/bin/bash
#source <% "#{@syncdir}/#{@instrument}" %>/bashrc
<% for connect in @localconnections %>
<% src = synth_of(connect.source) %>
<% sink = synth_of(connect.sink) %>
# <%= synth_of(connect.source).name %> <%= synth_of(connect.sink).name %> 
ssh <%= src.host.slave.username %>@<%= src.host.slave.hostname %>  bash <%= "#{@syncdir}/#{@instrument}/gen/connect-local.sh" %> "<%= src.get_jack_outputs[0] %>" "<%= sink.get_jack_inputs[0] %>"
<% end %>
