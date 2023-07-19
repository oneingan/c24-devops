class profile::base {

  user { 'juanjop':
    ensure     => present,
    managehome => true,
    shell      => '/bin/bash',
  }

  ssh_authorized_key { 'juanjop@x2100':
    ensure => present,
    user   => 'juanjop',
    type   => 'ssh-ed25519',
    key    => 'AAAAC3NzaC1lZDI1NTE5AAAAIFVuLMi6+cF9iDvs7wZaeIWxd20nnBeqxQVoz0r/3y+E',
  }

  class { 'sudo':
    purge => false,
  }

  sudo::conf { 'juanjop':
    content  => 'juanjop ALL=(ALL) NOPASSWD: ALL',
  }
}