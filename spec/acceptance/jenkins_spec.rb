require 'spec_helper_acceptance'

describe 'profiles::jenkins class:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  jenkins_default = {
    'port'         => '9091',
    'dist'         => 'jdk',
    'service'      => 'jenkins',
    'java_version' => 'latest',
  }

  context 'default parameters' do
    it 'should be compile successfully and be idempotent' do
      pp = "class { '::profiles::jenkins': }"

      # Apply twice to ensure no errors the second time.
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service(jenkins_default['service']) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(jenkins_default['port']) do
      # Jenkins takes awhile to start...
      it { should be_listening }
    end

    describe command('java -version') do
      # `java -version` sends version info to stderr, nothing to stdout,
      # prints two lines with OpenJDK info, exits 0, and gives you the finger.
      #
      # NOTE: The matching test is probably gonna fail after today - it
      # only exists for demonstration purposes. Seriously.
      its(:exit_status) { should eq 0 }
      its(:stderr) { should match /1\.7\.0_85/ }
    end
  end
end
