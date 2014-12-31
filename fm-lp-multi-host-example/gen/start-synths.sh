#!/bin/bash
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
# bach
ssh ubuntu@docker2 bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp2"
ssh ubuntu@docker2 bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp3"
# xenakis
ssh ubuntu@docker1  bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp"
ssh ubuntu@docker1  bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "fm"
ssh ubuntu@docker1  bash cloudorchestra/fm-lp-multi-host-example/gen/run-synth.sh "lp4"
