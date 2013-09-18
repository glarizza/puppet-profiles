class profiles::jenkins {
  include jenkins
  class { 'java':
    distribution => 'jdk',
    version      => 'latest',
    before       => Class['jenkins'],
  }
}
