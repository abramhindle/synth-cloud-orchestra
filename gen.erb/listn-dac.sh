<% offset = 777 %>
<% host = host_of("dac") %>
# <%= host.alias %> <%= host.hostname %>
bash -x export-playback.sh 172.17.42.1 <%= host.username %>@<%= host.hostname %> <%= host.alias %> <%= offset %>

