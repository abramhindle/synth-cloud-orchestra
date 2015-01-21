#!/bin/bash
#source <%= "#{@syncdir}/#{@instrument}" %>/bashrc
#cd <%= "#{@syncdir}/#{@instrument}" %> 

ansible -i ./ansible/ all -m shell -a 'mkdir <%= @syncdir %> || echo OK'
ansible -i ./ansible/ all -m synchronize -a 'src=<%= @instrumentpath %> dest=<%= @syncdir %>/'
<% for host in @hosts %>
# <%= host.alias %> <%= host.hostname %>
rsync ../../<%= @instrument %> <%= host.username %>@<%= host.hostname %>:<%= @syncdir %>
<%end%>
ansible -i ./ansible/ all -m shell -a 'chmod +x <%= "#{@syncdir}/#{@instrument}/bin/*'" %>'
