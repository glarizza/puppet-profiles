class profiles::wordpress_localhost {
  # This class creates a Wordpress Install setup to listen on localhost
  # of a node...which is good for quick-provisioning examples with Vagrant
  # (hint hint)
  
  $wordpress_user_password =  'wordpress'
  $mysql_root_password     =  'password'
  $wordpress_db_host       =  'localhost'
  $wordpress_db_name       =  'wordpress'
  $wordpress_db_password   =  'wordpress'


  ## Create user
  group { 'wordpress':
    ensure => present,
  }
  user { 'wordpress':
    ensure   => present,
    gid      => 'wordpress',
    password => $wordpress_user_password,
    home     => '/var/www/wordpress',
    require  => Package['httpd'],
  }

  ## Configure mysql
  class { 'mysql::server':
    root_password => $wordpress_root_password, 
  }
  
  class {'mysql::bindings':
    php_enable => true,
  }

  ## Configure apache
  include apache
  include apache::mod::php

  ## Configure ftp for installing updates/themes. Disallows root login
  include vsftpd

  ## Configure wordpress
  class { '::wordpress':
    install_dir => '/var/www/html',
    db_name     => $wordpress_db_name,
    db_host     => $wordpress_db_host,
    db_user     => 'wordpress',
    db_password => $wordpress_db_password,
    wp_owner    => 'wordpress',
    wp_group    => 'wordpress',
    require     => Package['httpd'],
  }

  firewall { '100 allow http access':
    port   => '80',
    proto  => 'tcp',
    action => 'accept',
  }
}
