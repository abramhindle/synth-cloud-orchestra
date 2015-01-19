#!/bin/bash
source <%= "#{@syncdir}/#{@instrument}/gen" %>/bashrc
<% for host in @hosts %>
# <%= host.alias %> <%= host.hostname %>
<% for synth in synths_of(host) %>
ssh <%= host.username %>@<%= host.hostname %> bash <%= "#{@syncdir}/#{@instrument}/gen/run-synth.sh" %> "<%= synth.name %>" &<% end %>
<% end %>
