#!/bin/bash
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
# bach
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp2"
ssh ubuntu@172.17.0.3 bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp3"
# xenakis
ssh ubuntu@172.17.0.2  bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp"
ssh ubuntu@172.17.0.2  bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "fm"
ssh ubuntu@172.17.0.2  bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp4"
