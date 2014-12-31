#!/bin/bash
source cloudorechestra/fm-lp-multi-host-example/gen/bashrc
# bach
ssh ubuntu@docker2 bash cloudorechestra/fm-lp-multi-host-example/gen/run-synth.sh "lp2"
ssh ubuntu@docker2 bash cloudorechestra/fm-lp-multi-host-example/gen/run-synth.sh "lp3"
# xenakis
ssh ubuntu@docker1  bash cloudorechestra/fm-lp-multi-host-example/gen/run-synth.sh "lp"
ssh ubuntu@docker1  bash cloudorechestra/fm-lp-multi-host-example/gen/run-synth.sh "fm"
ssh ubuntu@docker1  bash cloudorechestra/fm-lp-multi-host-example/gen/run-synth.sh "lp4"
