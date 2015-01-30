#!/bin/bash
SOURCE=$1
SINK=$2
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
cd  cloudorchestra/fm-lp-multi-host-example/gen/
ruby jack-reconnect.rb $1 $2
