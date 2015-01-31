#!/bin/bash
#source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
#cd `pwd`/gen || echo OK
bash -x sync.sh
bash -x start-jacks.sh
sleep 5
bash -x start-connectors.sh
sleep 5
bash -x start-synths.sh
sleep 5
bash -x disconnect-everything.sh
sleep 5
bash -x connect-synths.sh
sleep 5
bash -x listn-dac.sh
echo "Synthesizer should be up and running. Press <enter> to terminate"
read
bash -x teardown.sh
