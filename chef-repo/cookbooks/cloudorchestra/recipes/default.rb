#
# Cookbook Name:: cloudorchestra
# Recipe:: default
#
# Copyright 2014, Abram Hindle
#
# Apache 2.0 license
#

include_recipe "apache2"

apache_site "default" do
  enable true
end
