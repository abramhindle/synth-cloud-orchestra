#scp -p `docker port test_chefbase 22 | awk -F: '{print $2}'` -v sync-client.sh ubuntu@localhost:~/
#ssh -p `docker port test_chefbase 22 | awk -F: '{print $2}'` -v ubuntu@localhost bash sync-client.sh 
tar cj sync*.sh |  ssh -v -p `bash docker/base/port.sh` 'ubuntu@localhost' -t 'cd && tar xj'
ssh -v -p `bash docker/base/port.sh` 'ubuntu@localhost' -t 'bash -x sync-client.sh'

