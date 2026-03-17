#
# Cookbook:: nexus
# Attributes:: default
#
# Copyright:: 2026, Richard Nixon, Apache-2.0 License

# Version
default['nexus']['version'] = '3.90.1-01'

# Map Ohai kernel machine to Sonatype's naming convention
# Note: Sonatype uses 'aarch_64' (with underscore) not 'aarch64'
nexus_arch = node['kernel']['machine'] == 'aarch64' ? 'aarch_64' : 'x86_64'

# Download URL (automatically selects the correct architecture)
default['nexus']['arch']         = nexus_arch
default['nexus']['download_url'] = "https://download.sonatype.com/nexus/3/nexus-#{node['nexus']['version']}-linux-#{nexus_arch}.tar.gz"

# OS user and group
default['nexus']['user']  = 'nexus'
default['nexus']['group'] = 'nexus'

# Installation paths
default['nexus']['home']     = '/opt/nexus'
default['nexus']['data_dir'] = '/opt/sonatype-work/nexus3'

# JVM options
default['nexus']['jvm']['xms'] = '2703m'
default['nexus']['jvm']['xmx'] = '2703m'
default['nexus']['jvm']['xss'] = '250k'

# Network binding
default['nexus']['host']         = '0.0.0.0'
default['nexus']['port']         = 8081
default['nexus']['context_path'] = '/'
