#!/bin/bash
source cloudorchestra/fm-lp-multi-host-example/gen/bashrc
cd cloudorechestra/fm-lp-multi-host-example/
ruby synthrunner.rb "$1"
