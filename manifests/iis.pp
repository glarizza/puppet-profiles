# A profile to manage IIS on Windows
#
#  - Sets up the IIS role
#  - Manages an IIS Site and App Pool
#
# USES:
#   - https://github.com/puppet-community/puppet-windowsfeature
#   - https://github.com/puppet-community/puppet-iis
class profiles::iis {

  # Add the Web Management Tools
  windowsfeature { 'Web-Mgmt-Tools':
    ensure             => present,
    installsubfeatures => true,
  }

  # Add the IIS Role
  windowsfeature { 'Web-WebServer':
    ensure                 => present,
    installmanagementtools => true,
  }

  # Remove the default IIS web site
  iis::manage_site { 'Default Web Site':
    ensure    => absent,
    site_path => 'any',
    app_pool  => 'DefaultAppPool',
    require   => Windowsfeature['Web-WebServer'],
  }

  service { 'w3svc':
    ensure  => running,
    enable  => true,
    require => Windowsfeature['Web-WebServer'],
  }

  # Manage an IIS Site
  #iis::manage_site {'internal.company.com':
  #  site_path   => 'C:\inetpub\wwwroot\company',
  #  port        => '80',
  #  ip_address  => '*',
  #  host_header => 'internal.company.com',
  #  app_pool    => 'cust_application_pool'
  #}

  ## Manage an App Pool
  #iis::manage_app_pool {'application_pool':
  #  enable_32_bit           => true,
  #  managed_runtime_version => 'v4.0',
  #}

  #iis::manage_virtual_application {'application1':
  #  site_name => 'internal.cust.com',
  #  site_path => 'C:\inetpub\wwwroot\application1',
  #  app_pool  => 'application_pool'
  #}

}
