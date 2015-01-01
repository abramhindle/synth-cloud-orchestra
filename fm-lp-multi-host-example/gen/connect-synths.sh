#!/bin/bash
#source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
# fm lp
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundfmfm:output1" "csoundlplp:input1"
# lp lp2
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp:output1" "remotelplp:send_1"
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "remotelplp:receive_1" "csoundlplp2:input1"
# lp2 lp3
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp2:output1" "csoundlplp3:input1"
# lp3 dac
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp3:output1" "system:playback_1"
# lp4 dac
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "csoundlplp:output1" "remotelplp4:send_1"
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "remotelplp4:receive_1" "system:playback_1"
# adc lp4
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "system:capture_1" "remoteadcadc:send_1"
ssh ubuntu@172.17.0.2 bash cloudorchestra/fm-lp-multi-host-example/gen/connect-local.sh "remoteadcadc:receive_1" "csoundlplp4:input1"
