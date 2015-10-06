class profiles::puppet_four_changes {

  # Empty strings are true boolean values in 4.0.0
  if '' {
    notify { 'Empty string as a true value': }
  }

  # Escapes are possible in single quoted strings in 4.0.0
  notify { 'There is a single forward slash in 4.0.0: \\ ': }

  # File Modes must be a string and not a numeric in 4.0.0
  file { '/var/tmp/foo':
    ensure => file,
    owner  => '0',
    group  => '0',
    mode   => 0644,
  }
}
