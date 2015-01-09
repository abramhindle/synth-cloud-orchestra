#!/bin/bash
#source ~/cloudorchestra/fm-lp-multi-host-example/bashrc
cd <% "#{@syncdir}/#{@instrument}" %> ~/cloudorchestra/fm-lp-multi-host-example
cd <% "#{@module}" %>
<% @command %>

