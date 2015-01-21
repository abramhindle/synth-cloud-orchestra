#!/bin/bash
# This script starts the jacktrips to receive and send
#source <%= "#{@syncdir}/#{@instrument}" %>/bashrc
<% offset = 0 %>
<% for connect in @connections %>
<% src, sink = connection_synths( connect ) %>
# <%= src.name %> <%= sink.name %> 
ssh <%= sink.username %>@<%= sink.hostname %>  bash <%= "#{@syncdir}/#{@instrument}/gen/reciever.sh" %> "<%= src.get_jack_output_portname %>" <%= offset %> &
ssh <%= src.username %>@<%= src.hostname %>  bash <%= "#{@syncdir}/#{@instrument}/gen/sender.sh" %> "<%= src.get_jack_output_portname %>" <%= offset %> <%= sink.hostname %> &

# was src.module src.name
<% offset += 1 %>
<% end %>


