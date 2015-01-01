#!/bin/bash
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
# fm lp
ssh ubuntu@172.17.0.3  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "fmfm" 0 & 
ssh ubuntu@172.17.0.2  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "fmfm" 0 172.17.0.3  & 
# lp lp2 & 
ssh ubuntu@172.17.0.3  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "lplp" 1 & 
ssh ubuntu@172.17.0.2  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "lplp" 1 172.17.0.3  & 
# lp4 dac & 
ssh ubuntu@172.17.0.3  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "lplp4" 2 & 
ssh ubuntu@172.17.0.2  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "lplp4" 2 172.17.0.3  & 
# adc lp4 & 
ssh ubuntu@172.17.0.2  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "adcadc" 3 & 
ssh ubuntu@172.17.0.3  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "adcadc" 3 172.17.0.2  & 
