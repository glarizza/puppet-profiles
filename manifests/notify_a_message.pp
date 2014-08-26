class profiles::notify_a_message {
  $the_message = hiera('message')

  class { 'notifyme':
    message => $the_message,
  }
}
