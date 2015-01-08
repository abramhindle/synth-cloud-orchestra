#!/bin/bash
ansible -i ./ansible/ all -u ubuntu -m shell -a 'pgrep csound'
