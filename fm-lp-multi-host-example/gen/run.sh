#!/bin/bash
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
cd `pwd`/gen || echo OK
bash -x sync.sh
bash -x start-jacks.sh
bash -x start-connectors.sh
bash -x start-synths.sh
bash -x connect-synths.sh
echo "Synthesizer should be up and running. Press <enter> to terminate"
read
bash -x teardown.sh
