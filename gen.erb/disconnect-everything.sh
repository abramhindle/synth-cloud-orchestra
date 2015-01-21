#!/bin/bash
# source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
ansible -i ./ansible/ all -u ubuntu -m shell -a '/bin/bash <%= "#{@syncdir}/#{@instrument}/gen/disconnectall.sh" %> &'
