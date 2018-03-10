# Ensure TeamCity Server service is running
control '02' do
  impact 0.7
  title 'Verify teamcity-server service'
  desc 'Ensures teamcity-server service is up and running'
  describe service('teamcity-server') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end

  describe port(8111) do
    it { should be_listening }
    its('protocols') {should include 'tcp'}
  end
end
