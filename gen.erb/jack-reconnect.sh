#!/bin/bash
SOURCE=$1
SINK=$2
source ~/<%= "#{@syncdir}/#{@instrument}/gen/bashrc" %>
cd ~/<%= "#{@syncdir}/#{@instrument}/gen/" %>
ruby jack-reconnect.rb $1 $2
