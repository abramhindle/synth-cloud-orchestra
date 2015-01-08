#!/bin/bash
#source <% "#{syncdir}/#{instrument}" %>/bashrc
#cd <% "#{syncdir}/#{instrument}" %> 

ansible -i ./ansible/ all -m shell -a 'mkdir <% syncdir %> || echo OK'
ansible -i ./ansible/ all -m synchronize -a 'src=<% instrumentpath %> dest=<% syncdir %>/'
ansible -i ./ansible/ all -m shell -a 'chmod +x <% "#{syncdir}/#{instrument}/bin/*'" %>'
