#
# Cookbook:: nexus
# Recipe:: configure
#
# Copyright:: 2026, Richard Nixon, Apache-2.0 License

nexus_home = "#{node['nexus']['home']}/nexus-#{node['nexus']['version']}"
nexus_data = node['nexus']['data_dir']

# Configure JVM options
template "#{nexus_home}/bin/nexus.vmoptions" do
  source 'nexus.vmoptions.erb'
  owner node['nexus']['user']
  group node['nexus']['group']
  mode '0644'
  variables(
    data_dir: nexus_data,
    xms: node['nexus']['jvm']['xms'],
    xmx: node['nexus']['jvm']['xmx'],
    xss: node['nexus']['jvm']['xss']
  )
  notifies :restart, 'service[nexus]', :delayed
end

# Configure nexus.rc — run_as_user is left empty because systemd User= handles it
template "#{nexus_home}/bin/nexus.rc" do
  source 'nexus.rc.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[nexus]', :delayed
end

# Configure nexus-default.properties for port and host binding
template "#{nexus_home}/etc/nexus-default.properties" do
  source 'nexus-default.properties.erb'
  owner node['nexus']['user']
  group node['nexus']['group']
  mode '0644'
  variables(
    host: node['nexus']['host'],
    port: node['nexus']['port'],
    context_path: node['nexus']['context_path']
  )
  notifies :restart, 'service[nexus]', :delayed
end
