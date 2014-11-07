class profiles::jenkins {
  # Set variables. I'm using the 'default' second value
  # for demonstration purposes only in case I need to run
  # this demo on a system that doesn't have Hiera configured.
  $jenkins_port = hiera('jenkins_port', '9091')
  $java_dist    = hiera('java_dist', 'jdk')
  $java_version = hiera('java_version', 'latest')

  class { '::jenkins':
    configure_firewall => true,
    install_java       => false,
    port               => $jenkins_port,
    config_hash        => {
      'HTTP_PORT'    => { 'value' => $jenkins_port },
      'JENKINS_PORT' => { 'value' => $jenkins_port },
    },
  }

  class { '::java':
    distribution => $java_dist,
    version      => $java_version,
    before       => Class['jenkins'],
  }
}
