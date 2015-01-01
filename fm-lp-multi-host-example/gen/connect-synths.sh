#!/bin/bash
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
# fm lp
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundfmfm:output_1" "csoundlplp:input_1"
# lp lp2
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp:output_1" "remotelplp:input_1"
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "remotelplp:output_1" "csoundlplp2:input_1"
# lp2 lp3
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp2:output_1" "csoundlplp3:input_1"
# lp3 dac
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp3:output_1" "system:playback_1"
# lp4 dac
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp:output_1" "remotelplp4:input_1"
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "remotelplp4:output_1" "system:playback_1"
# adc lp4
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "system:capture_1" "remoteadcadc:input_1"
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "remoteadcadc:output_1" "csoundlplp4:input_1"
