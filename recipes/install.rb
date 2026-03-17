#
# Cookbook:: nexus
# Recipe:: install
#
# Copyright:: 2026, Richard Nixon, Apache-2.0 License

nexus_version      = node['nexus']['version']
nexus_download_url = node['nexus']['download_url']
nexus_home         = node['nexus']['home']
nexus_data_dir     = node['nexus']['data_dir']
nexus_user         = node['nexus']['user']
nexus_group        = node['nexus']['group']
nexus_arch         = node['nexus']['arch']
nexus_tarball      = "nexus-#{nexus_version}-linux-#{nexus_arch}.tar.gz"
nexus_extract_dir  = "#{nexus_home}/nexus-#{nexus_version}"

# Install packages needed to extract the tarball
package %w(tar gzip)

# Download the Nexus tarball
remote_file "#{Chef::Config[:file_cache_path]}/#{nexus_tarball}" do
  source   nexus_download_url
  mode     '0644'
  action   :create
  notifies :run, 'bash[extract_nexus]', :immediately
end

# Extract Nexus into the install directory
bash 'extract_nexus' do
  cwd  nexus_home
  user 'root'
  code <<~BASH
    tar xzf "#{Chef::Config[:file_cache_path]}/#{nexus_tarball}" -C "#{nexus_home}"
    chown -R #{nexus_user}:#{nexus_group} "#{nexus_extract_dir}"
    chown -R #{nexus_user}:#{nexus_group} "#{nexus_data_dir}"
  BASH
  action :nothing
end

# Symlink to the current version for stable paths in systemd / config
link "#{nexus_home}/nexus-current" do
  to    nexus_extract_dir
  owner nexus_user
  group nexus_group
end
