#!/bin/bash
#source <% "#{syncdir}/#{instrument}" %>/bashrc
<% for @connect in @localconnections %>
# <% @connect["src"]["name"] %> <% @connect["sink"]["name"] %> 
ssh <% @connect["user"] %>@<% @connect["hostname"] %>  bash <% "#{syncdir}/#{instrument}/gen/connect-local.sh" %> "<% @connect["src"]["jack"] %>" "<% @connect["sink"]["jack"] %>"
<% end %>
