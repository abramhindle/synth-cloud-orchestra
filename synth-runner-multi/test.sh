#!/bin/bash -x
set -e
cd .. && \
(rm -rf test-synth || echo Fine) && \
cp -r fm-lp-multi-host-example test-synth && \
cd test-synth && \
(rm -rf gen || echo Fine) && \
( ruby ../synth-runner-multi/synthdefrunner.rb || echo FAILURE ) && \
 diff ../fm-lp-multi-host-example/gen/start-synths.sh gen/start-synths.sh || \
 diff ../fm-lp-multi-host-example/gen/connect-synths.sh gen/connect-synths.sh

