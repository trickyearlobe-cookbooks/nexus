#
# Cookbook:: nexus
# Recipe:: default
#
# Copyright:: 2026, Richard Nixon, Apache-2.0 License

include_recipe 'nexus::user'
include_recipe 'nexus::install'
include_recipe 'nexus::configure'
include_recipe 'nexus::service'
