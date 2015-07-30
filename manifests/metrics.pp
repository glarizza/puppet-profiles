## Profile Dependencies
#   mod 'grafana', :git => 'https://github.com/bfraser/puppet-grafana.git', :tag => 'v2.0.2'
#   mod 'golja/influxdb', '0.1.2'
#   mod 'puppetlabs/firewall'

class profiles::metrics {
  $influxdb_port          = 8086
  $graphite_port          = 2003
  $collectd_port          = 25826
  $grafana_port           = 8080
  #$influxdb_version       = '0.9.2',
  $influxdb_version       = 'nightly'
  $grafana_version        = '2.0.2'
  $metrics_database       = 'graphite'
  $grafana_database       = 'grafana'
  $influxdb_root_user     = 'root'
  $influxdb_root_password = 'root'

  class { '::influxdb::server':
    api_port      => $influxdb_port,
    version       => $influxdb_version,
  }

  # We can't use ini_setting on this file because there are settings with
  # double brackets, I hate people, software is terrible, and everything
  # is awful [[graphite]]
  file { '/etc/opt/influxdb/influxdb.conf':
    ensure => file,
    owner  => 'influxdb',
    group  => 'influxdb',
    mode   => '0644',
    source => 'puppet:///modules/profiles/metrics/influxdb.conf',
    notify => Service['influxdb'],
  }

  ## This file is not managed by the influxdb module
  ## but needs to be removed to enable the
  ## file containing our desired configuration
  #file { '/opt/influxdb/current/config.toml':
  #  ensure => absent,
  #  notify => Service['influxdb'],
  #}

  # Newer versions of InfluxDB don't include this directory, but
  # the module has yet to deal with it...
  file { '/opt/influxdb/shared/':
    ensure => directory,
    owner  => 'influxdb',
    group  => 'influxdb',
    mode   => '0644',
  }

  class { 'grafana':
    cfg => {
      app_mode => 'production',
      server   => {
        http_port  => $grafana_port,
      },
    },
  }

  # So, Grafana is a service that uses a grafana user, so it must use a port
  # that's greater than 1024. This is a redirection for port 80 to the Grafana
  # port.
  firewall {"102 redirect port 80 to ${grafana_port}":
    table       => 'nat',
    chain       => 'PREROUTING',
    proto       => 'tcp',
    dport       => '80',
    jump        => 'REDIRECT',
    toports     => $grafana_port,
  }
}
