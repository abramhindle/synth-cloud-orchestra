#!/bin/bash
MYIP=$1
USERHOST=$2
MYO=666
../bin/jacktrip -s -o $MYO --clientname cloudorchestra &
ssh $USERHOST <%= "#{@syncdir}/#{@instrument}/bin/jacktrip" %> -c $MYIP -o $MYO --clientname cloudorchestra &
ssh $USERHOST bash  <%= "#{@syncdir}/#{@instrument}/bin/jack-reconnect.sh" %> system:playback_1 cloudorchestra:send_1
ruby jack-disconnect.rb cloudorchestra
sleep 3
ruby jack-disconnect.rb cloudorchestra
jack_connect cloudorchestra:receive_1 system:playback_1
