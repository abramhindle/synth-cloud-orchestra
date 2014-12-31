#!/bin/bash
ansible -i ./ansible/ all -u  ubuntu -m shell -a 'mkdir ~/cloudorchestra/ || echo OK'
ansible -i ./ansible/ all -u  ubuntu -m shell -a 'rm -rf ~/cloudorchestra/fm-lp-multi-host-example'
ansible -i ./ansible/ all -u  ubuntu -m copy -a 'src=../../fm-lp-multi-host-example dest=cloudorchestra/'
