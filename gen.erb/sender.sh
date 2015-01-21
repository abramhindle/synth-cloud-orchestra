#!/bin/bash
CONNECTOR=$1
OFFSET=$2
HOST=$3
source <%= "#{@syncdir}/#{@instrument}" %>/bashrc
<%= "#{@syncdir}/#{@instrument}/bin/jacktrip" %> -c $HOST -o $2 --clientname "remote$CONNECTOR"
