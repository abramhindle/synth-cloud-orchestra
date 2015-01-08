#!/bin/bash
#source <% "#{syncdir}/#{instrument}/gen/bashrc" %>
ansible -i ./ansible/ all -u ubuntu -m shell -a 'jack_lsp -c'
