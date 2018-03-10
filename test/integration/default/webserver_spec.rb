# Nginx Installation
describe package('nginx') do
  it { should be_installed }
end

# Extend tests with metadata
control '01' do
  impact 0.7
  title 'Verify nginx service'
  desc 'Ensures nginx service is up and running'
  describe service('nginx') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
    its('protocols') {should include 'tcp'}
  end
end

# Implement os dependent tests
web_user = 'www-data'
web_user = 'nginx' if os[:family] == 'centos'

describe user(web_user) do
  it { should exist }
end
