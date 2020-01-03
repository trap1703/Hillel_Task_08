# # encoding: utf-8

# Inspec test for recipe 777::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end
#===============================
describe package('apache2') do
  it { should be_installed }
end
describe package('mysql-server') do
  it { should be_installed }
end

describe package('php7.2') do
  it { should be_installed }
end

describe package('ruby') do
  it { should be_installed }
end

describe file('/var/www/wp-config.php') do
  it { should exist }
end

describe service('apache2') do
  it { should be_enabled }
  it { should be_installed }
  it { should be_running }
end

describe port(22) do
  it { should be_listening }
#  its('sshd') {should include 'syslog'}
end

describe port(22) do
  its('processes') { should include 'sshd' }
  its('protocols') { should include 'tcp' }
  its('addresses') { should include '0.0.0.0' }
end

describe user('cthulhu01') do
  it { should exist }
end
describe user('cthulhu02') do
  it { should exist }
end
describe user('cthulhu03') do
  it { should exist }
end
describe user('cthulhu04') do
  it { should exist }
end

