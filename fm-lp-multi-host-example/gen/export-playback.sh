#!/bin/bash
MYIP=$1
USERHOST=$2
MYO=666
jacktrip -s -o $MYO --clientname cloudorchestra &
ssh $USERHOST cloudorchestra/fm-lp-multi-host-example/bin/jacktrip -c $MYIP -o $MYO --clientname cloudorchestra &
ssh $USERHOST cloudorchestra/fm-lp-multi-host-example/gen/jack-reconnect.sh system:playback_1 cloudorchestra:send_1

