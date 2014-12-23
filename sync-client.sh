#!/bin/bash
if [ -e chef-cloud ]
then
	cd chef-cloud
	git pull origin master	
else
	git config --global user.email "hindle1@ualberta.ca"
	git config --global user.name "abram hindle"
	git clone hindle1@10.10.12.10:/home/hindle1/projects/chef-cloud
fi
