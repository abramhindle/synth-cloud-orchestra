#!/bin/bash -x
SYNTH=$1
#source ~/cloudorchestra/fm-lp-multi-host-example/gen/bashrc
cd cloudorchestra/fm-lp-multi-host-example/gen
bash -x "synth-$1.sh" 
