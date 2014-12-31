#!/bin/bash
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
# fm lp
ssh ubuntu@docker2  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "fmfm" 0 & 
ssh ubuntu@docker1  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "fmfm" 0 docker2  & 
# lp lp2 & 
ssh ubuntu@docker2  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "lplp" 1 & 
ssh ubuntu@docker1  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "lplp" 1 docker2  & 
# lp4 dac & 
ssh ubuntu@docker2  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "lplp4" 2 & 
ssh ubuntu@docker1  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "lplp4" 2 docker2  & 
# adc lp4 & 
ssh ubuntu@docker1  bash cloudorchestra/fm-lp-multi-host-example/gen/receiver.sh "adcadc" 3 & 
ssh ubuntu@docker2  bash cloudorchestra/fm-lp-multi-host-example/gen/sender.sh "adcadc" 3 docker1  & 
