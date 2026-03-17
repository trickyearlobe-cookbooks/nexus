# Chef InSpec test for recipe nexus::default

# Verify the nexus group exists
describe group('nexus') do
  it { should exist }
end

# Verify the nexus user exists and is configured correctly
describe user('nexus') do
  it { should exist }
  its('group') { should eq 'nexus' }
  its('shell') { should eq '/bin/bash' }
end

# Verify installation directories exist with correct ownership
describe directory('/opt/nexus') do
  it { should exist }
  its('owner') { should eq 'nexus' }
  its('group') { should eq 'nexus' }
  its('mode') { should cmp '0755' }
end

describe directory('/opt/sonatype-work/nexus3') do
  it { should exist }
  its('owner') { should eq 'nexus' }
  its('group') { should eq 'nexus' }
  its('mode') { should cmp '0755' }
end

# Verify the nexus application was extracted
describe directory('/opt/nexus/nexus-3.90.1-01') do
  it { should exist }
  its('owner') { should eq 'nexus' }
  its('group') { should eq 'nexus' }
end

# Verify the symlink to the current version exists
describe file('/opt/nexus/nexus-current') do
  it { should be_symlink }
  its('link_path') { should eq '/opt/nexus/nexus-3.90.1-01' }
end

# Verify the nexus binary is present and executable
describe file('/opt/nexus/nexus-3.90.1-01/bin/nexus') do
  it { should exist }
  it { should be_file }
  it { should be_executable }
end

# Verify nexus.vmoptions is configured
describe file('/opt/nexus/nexus-3.90.1-01/bin/nexus.vmoptions') do
  it { should exist }
  its('owner') { should eq 'nexus' }
  its('content') { should match(/-Xms2703m/) }
  its('content') { should match(/-Xmx2703m/) }
  its('content') { should match(/-Xss250k/) }
  its('content') { should match(%r{-Dkaraf.data=/opt/sonatype-work/nexus3}) }
end

# Verify nexus.rc is configured with the run-as user
describe file('/opt/nexus/nexus-3.90.1-01/bin/nexus.rc') do
  it { should exist }
  its('content') { should match(/run_as_user=""/) }
end

# Verify nexus-default.properties is configured
describe file('/opt/nexus/nexus-3.90.1-01/etc/nexus-default.properties') do
  it { should exist }
  its('owner') { should eq 'nexus' }
  its('content') { should match(/application-port=8081/) }
  its('content') { should match(/application-host=0\.0\.0\.0/) }
  its('content') { should match(%r{nexus-context-path=/}) }
  its('content') { should match(/nexus-edition=nexus-oss-edition/) }
end

# Verify the systemd unit file is installed and enabled
describe systemd_service('nexus') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# Verify Nexus is listening on the expected port (may take time to start)
describe port(8081) do
  it { should be_listening }
  its('protocols') { should include('tcp') }
end
