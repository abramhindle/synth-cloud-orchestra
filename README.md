Synth Cloud Orchestra / Synth Cloud Orchestrator
================================================

An attempt to enable the orchestration of cloud computers for computer music synthesis.

The current problem probably facing the processing of live audio in the cloud is that of configuration. We want to make music and sound, not be devops/sysadmins.

Current goal: 

* use chef to deploy and run instruments as services [not done]
* Allow for flexible audio configurations [getting there]
* Allow for automatic setup/deployment of a instrument to a set of known hosts [getting there]
* Connect the audio links [in good shape]

Wishlist:

* Optimize network arrangement
* Provide RTSP and HTTP Streaming out

Need:

* gem install oj
* ansible http://docs.ansible.com/intro_installation.html#latest-releases-via-apt-ubuntu

    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible

TODO:

* Write test with allocation
* Write verifiable test


