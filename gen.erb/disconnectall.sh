#!/bin/bash
source <% "#{@syncdir}/#{@instrument}/gen/bashrc" %>
cd <% "#{@syncdir}/#{@instrument}/gen" %>
ruby jack-disconnect.rb
