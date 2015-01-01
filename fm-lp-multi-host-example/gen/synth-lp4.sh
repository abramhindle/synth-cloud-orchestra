#!/bin/bash
source ~/cloudorchestra/fm-lp-multi-host-example/bashrc
cd ~/cloudorchestra/fm-lp-multi-host-example
cd lp
csound -iadc -odac -+rtaudio=jack -+jack_client=csoundlplp4 -b 500 -B 2000 lp.csd
