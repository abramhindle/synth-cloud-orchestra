<% offset = 666 %>
<% for host in @hosts %>
# <%= host.alias %> <%= host.hostname %>
bash -x export-playback.sh 172.17.42.1 <%= host.username %>@<%= host.hostname %> <%= host.alias %> <%= offset %>
read
<% offset += 1 %>
<%end%>

# bash -x export-playback.sh 172.17.42.1 ubuntu@docker2
