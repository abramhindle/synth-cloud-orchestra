#!/bin/bash
#source ~/cloudorchestra/fm-lp-multi-host-example/bashrc
cd ~/cloudorchestra/fm-lp-multi-host-example
cd fm
csound -iadc -odac -+rtaudio=jack -+jack_client=csoundfmfm -b 500 -B 2000 fm.csd
