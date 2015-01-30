#!/bin/bash
CONNECTOR=$1
OFFSET=$2
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
cloudorchestra/fm-lp-multi-host-example/bin/jacktrip -s -o $2 --clientname "remote$CONNECTOR"
