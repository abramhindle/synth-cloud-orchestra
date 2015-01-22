#!/bin/bash
#source ~/cloudorchestra/fm-lp-multi-host-example/bashrc
cd
cd <%= "#{@syncdir}/#{@instrument}" %> 
cd <%= "#{@module}" %>
<%= @command %>

