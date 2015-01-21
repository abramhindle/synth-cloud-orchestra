ssh -p `docker port test_synthcloud 22 | awk -F: '{print $2}'` root@localhost
