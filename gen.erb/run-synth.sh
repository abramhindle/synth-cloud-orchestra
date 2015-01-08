#!/bin/bash -x
SYNTH=$1
source <% "#{syncdir}/#{instrument}" %>/bashrc
cd <% "#{syncdir}/#{instrument}/gen" %>
bash -x "synth-$1.sh" 
