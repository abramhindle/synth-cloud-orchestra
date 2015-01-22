#!/bin/bash
MYIP=$1
USERHOST=$2
CL=${3:-"cloudorchestra"}
MYO=666
../bin/jacktrip -s -o $MYO --clientname $CL &
ssh $USERHOST <%= "#{@syncdir}/#{@instrument}/bin/jacktrip" %> -c $MYIP -o $MYO --clientname $CL &
#ssh $USERHOST bash  <%= "#{@syncdir}/#{@instrument}/gen/jack-reconnect.sh" %> system:playback_1 ${CL}:send_1
ruby jack-disconnect.rb $CL
sleep 3
ruby jack-disconnect.rb $CL
ssh $USERHOST bash  <%= "#{@syncdir}/#{@instrument}/gen/jack-reconnect.sh" %> system:playback_1 ${CL}:send_1
jack_connect $CL:receive_1 system:playback_1
