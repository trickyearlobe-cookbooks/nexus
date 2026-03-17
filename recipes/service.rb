#
# Cookbook:: nexus
# Recipe:: service
#
# Copyright:: 2026, Richard Nixon, Apache-2.0 License

nexus_home = "#{node['nexus']['home']}/nexus-#{node['nexus']['version']}"

systemd_unit 'nexus.service' do
  content({
    Unit: {
      Description: 'Sonatype Nexus Repository Manager',
      After: 'network.target',
    },
    Service: {
      Type: 'forking',
      LimitNOFILE: 65_536,
      WorkingDirectory: nexus_home,
      ExecStart: "#{nexus_home}/bin/nexus start",
      ExecStop: "#{nexus_home}/bin/nexus stop",
      User: node['nexus']['user'],
      Restart: 'on-abort',
      TimeoutSec: 600,
    },
    Install: {
      WantedBy: 'multi-user.target',
    },
  })
  action [:create, :enable]
  notifies :restart, 'service[nexus]', :delayed
end

service 'nexus' do
  action [:start]
end
