#!/bin/bash

# Usage: ./deploy.sh [host]
P=`bash ../docker/base/port.sh`
host="${1:-ubuntu@127.0.0.1}"
port="${2:-$P}"

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null

tar cj . | ssh  -p $port -o 'StrictHostKeyChecking no' "$host" '
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh'
