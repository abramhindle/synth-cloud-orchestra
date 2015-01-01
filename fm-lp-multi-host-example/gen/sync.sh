#!/bin/bash
ansible -i ./ansible/ all -u  ubuntu -m shell -a 'mkdir cloudorchestra/ || echo OK'
#ansible -i ./ansible/ all -u  ubuntu -m shell -a 'rm -rf cloudorchestra/fm-lp-multi-host-example'
#ansible -i ./ansible/ all -u  ubuntu -m copy -a 'src=../../fm-lp-multi-host-example dest=cloudorchestra/'
ansible -i ./ansible/ all -u  ubuntu -m synchronize -a 'src=../../fm-lp-multi-host-example dest=cloudorchestra/'
ansible -i ./ansible/ all -u  ubuntu -m shell -a 'chmod +x cloudorchestra/fm-lp-multi-host-example/bin/*'
#fgrep docker /etc/hosts > docker.hosts
#ansible -i ./ansible/ all -u  ubuntu -m copy -a 'src=docker.hosts /tmp/docker.hosts'
#ansible -i ./ansible/ all -u  ubuntu -m shell -a 'cat /etc/hosts /tmp/docker.hosts > /etc/hosts
