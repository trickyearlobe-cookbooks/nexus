#
# Cookbook:: nexus
# Spec:: default
#
# Copyright:: 2026, Richard Nixon, Apache-2.0 License

require 'spec_helper'

describe 'nexus::default' do
  context 'When all attributes are default, on Ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the user recipe' do
      expect(chef_run).to include_recipe('nexus::user')
    end

    it 'includes the install recipe' do
      expect(chef_run).to include_recipe('nexus::install')
    end

    it 'includes the configure recipe' do
      expect(chef_run).to include_recipe('nexus::configure')
    end

    it 'includes the service recipe' do
      expect(chef_run).to include_recipe('nexus::service')
    end

    it 'creates the nexus group' do
      expect(chef_run).to create_group('nexus')
    end

    it 'creates the nexus user' do
      expect(chef_run).to create_user('nexus').with(
        shell: '/bin/bash',
        system: true
      )
    end

    it 'creates the install directory' do
      expect(chef_run).to create_directory('/opt/nexus').with(
        owner: 'nexus',
        group: 'nexus',
        mode: '0755'
      )
    end

    it 'creates the data directory' do
      expect(chef_run).to create_directory('/opt/sonatype-work/nexus3').with(
        owner: 'nexus',
        group: 'nexus',
        mode: '0755'
      )
    end

    it 'installs tar and gzip packages' do
      expect(chef_run).to install_package(%w(tar gzip))
    end

    it 'downloads the nexus tarball' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/nexus-3.90.1-01-linux-x86_64.tar.gz")
    end

    it 'creates the nexus.vmoptions template' do
      expect(chef_run).to create_template('/opt/nexus/nexus-3.90.1-01/bin/nexus.vmoptions').with(
        owner: 'nexus',
        group: 'nexus',
        mode: '0644'
      )
    end

    it 'creates the nexus.rc template' do
      expect(chef_run).to create_template('/opt/nexus/nexus-3.90.1-01/bin/nexus.rc').with(
        owner: 'root',
        group: 'root',
        mode: '0644'
      )
    end

    it 'creates the nexus-default.properties template' do
      expect(chef_run).to create_template('/opt/nexus/nexus-3.90.1-01/etc/nexus-default.properties').with(
        owner: 'nexus',
        group: 'nexus',
        mode: '0644'
      )
    end

    it 'creates and enables the systemd unit' do
      expect(chef_run).to create_systemd_unit('nexus.service')
      expect(chef_run).to enable_systemd_unit('nexus.service')
    end

    it 'starts the nexus service' do
      expect(chef_run).to start_service('nexus')
    end
  end

  context 'When all attributes are default, on AlmaLinux 9' do
    platform 'almalinux', '9'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'includes the user recipe' do
      expect(chef_run).to include_recipe('nexus::user')
    end

    it 'includes the install recipe' do
      expect(chef_run).to include_recipe('nexus::install')
    end

    it 'includes the configure recipe' do
      expect(chef_run).to include_recipe('nexus::configure')
    end

    it 'includes the service recipe' do
      expect(chef_run).to include_recipe('nexus::service')
    end

    it 'creates the nexus group' do
      expect(chef_run).to create_group('nexus')
    end

    it 'creates the nexus user' do
      expect(chef_run).to create_user('nexus').with(
        shell: '/bin/bash',
        system: true
      )
    end

    it 'installs tar and gzip packages' do
      expect(chef_run).to install_package(%w(tar gzip))
    end

    it 'downloads the nexus tarball' do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/nexus-3.90.1-01-linux-x86_64.tar.gz")
    end

    it 'creates and enables the systemd unit' do
      expect(chef_run).to create_systemd_unit('nexus.service')
      expect(chef_run).to enable_systemd_unit('nexus.service')
    end

    it 'starts the nexus service' do
      expect(chef_run).to start_service('nexus')
    end
  end
end
