#!/bin/bash
source <% "#{@syncdir}/#{@instrument}" %>/bashrc
<% for @host in @hosts %>
# <% @host["alias"] %> <% @host["hostname"] %>
  <% for @synth in @host["synths"] %>
     ssh <% @host["username"] %>@<% @host["hostname"] %> bash <% "#{@syncdir}/#{@instrument}/gen/run-synth.sh" %> "<% @synth["name"] %>"   &
  <% end %>
<% end %>
