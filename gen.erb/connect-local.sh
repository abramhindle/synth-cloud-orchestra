#!/bin/bash
source <%= "#{@syncdir}/#{@instrument}/gen/bashrc" %>
jack_connect $1 $2
