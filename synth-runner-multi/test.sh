#!/bin/bash -x
set -e
cd .. && \
(rm -rf test-synth || echo Fine) && \
cp -r fm-lp-multi-host-example test-synth && \
cd test-synth && \
(rm -rf gen || echo Fine) && \
( ruby ../synth-runner-multi/synthdefrunner.rb || echo FAILURE ) && \
( diff -b -r  ../fm-lp-multi-host-example/gen/ gen/ | gvim - )
# diff -b ../fm-lp-multi-host-example/gen/start-synths.sh gen/start-synths.sh || \
# diff -b ../fm-lp-multi-host-example/gen/start-synths.sh gen/start-connectors.sh || \
# diff -b ../fm-lp-multi-host-example/gen/connect-synths.sh gen/connect-synths.sh

