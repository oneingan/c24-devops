class profile::server {
  class { 'ssh::server':
    storeconfigs_enabled => false,
    options => {
      'PasswordAuthentication' => 'no',
      'X11Forwarding' => 'no',
      'KbdInteractiveAuthentication' => 'no',
      'UseDns' => 'no',
    },
  }
}