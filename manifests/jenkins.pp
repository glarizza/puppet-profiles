class profiles::jenkins {
  include ::jenkins
  class { 'java':
    distribution => 'jdk',
    version      => 'latest',
    before       => Class['jenkins'],
  }
  firewall { '100 allow jenkins access':
    port   => '8080',
    proto  => 'tcp',
    action => 'accept',
  }
}
