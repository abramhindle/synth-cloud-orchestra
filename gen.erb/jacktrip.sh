#!/bin/bash
CONNECTOR=$1
OFFSET=$2
source <%= "#{@syncdir}/#{@instrument}/gen/bashrc" %>
<%= "#{@syncdir}/#{@instrument}/bin/jacktrip" %> $*
