#
# Cookbook:: nexus
# Recipe:: user
#
# Copyright:: 2026, Richard Nixon, Apache-2.0 License

group node['nexus']['group'] do
  system true
end

user node['nexus']['user'] do
  comment 'Nexus Repository Manager service account'
  home    node['nexus']['data_dir']
  shell   '/bin/bash'
  gid     node['nexus']['group']
  system  true
  manage_home false
end

# Create installation and data directories
[node['nexus']['home'], node['nexus']['data_dir']].each do |dir|
  directory dir do
    owner     node['nexus']['user']
    group     node['nexus']['group']
    mode      '0755'
    recursive true
  end
end
