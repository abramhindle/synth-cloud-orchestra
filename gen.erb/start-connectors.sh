#!/bin/bash
#source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
<% for @connect in @connections %>
# <% @connect["src"]["name"] %> <% @connect["sink"]["name"] %> 
ssh <% @connect["sink"]["user"] %>@<% @connect["sink"]["hostname"] %>  bash <% "#{@syncdir}/#{@instrument}/gen/reciever.sh" %> "<% @connect["src"]["module"] %><% @connect["src"]["name"] %>" <% @connect["offset"] %> & 
ssh <% @connect["src"]["user"] %>@<% @connect["src"]["hostname"] %>  bash <% "#{@syncdir}/#{@instrument}/gen/sender.sh" %> "<% @connect["src"]["module"] %><% @connect["src"]["name"] %>" <% @connect["offset"] %> <% @connect["sink"]["hostname"] %> & 
<% end %>

