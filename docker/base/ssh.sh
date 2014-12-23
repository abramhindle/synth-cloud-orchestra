ssh -p `docker port test_chefbase 22 | awk -F: '{print $2}'` root@localhost
