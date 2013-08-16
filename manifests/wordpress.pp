class profiles::wordpress {
  $site_name               = hiera('profiles::wordpress::site_name')
  $wordpress_user_password = hiera('profiles::wordpress::wordpress_user_password')
  $mysql_root_password     = hiera('profiles::wordpress::mysql_root_password')
  $wordpress_db_host       = hiera('profiles::wordpress::wordpress_db_host')
  $wordpress_db_name       = hiera('profiles::wordpress::wordpress_db_name')
  $wordpress_db_password   = hiera('profiles::wordpress::wordpress_db_password')

  ## Create user
  group { 'wordpress':
    ensure => present,
  }
  user { 'wordpress':
    ensure   => present,
    gid      => 'wordpress',
    password => $wordpress_user_password,
    home     => '/var/www/wordpress',
  }

  ## Configure host entry
  host { $site_name:
    ensure       => present,
    ip           => $::ipaddress,
    host_aliases => ['wordpress'],
  }
    
  ## Configure mysql
  class { 'mysql::server':
    config_hash => { 'root_password' => $wordpress_root_password }
  }
  include mysql::php

  ## Configure apache
  include apache
  include apache::mod::php
  apache::vhost { $site_name:
    port    => '80',
    docroot => '/var/www/wordpress',
  }

  ## Configure ftp for installing updates/themes. Disallows root login
  include vsftpd

  ## Configure wordpress
  class { 'wordpress':
    install_dir => '/var/www/wordpress',
    db_name     => $wordpress_db_name,
    db_host     => $wordpress_db_host,
    db_user     => 'wordpress',
    db_password => $wordpress_db_password,
    wp_owner    => 'wordpress',
    wp_group    => 'wordpress',
  }
}
