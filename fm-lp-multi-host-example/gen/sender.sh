#!/bin/bash
CONNECTOR=$1
OFFSET=$2
HOST=$3
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
cloudorechestra/fm-lp-multi-host-example/bin/jacktrip -c $HOST -o $2 --clientname "remote$CONNECTOR"
