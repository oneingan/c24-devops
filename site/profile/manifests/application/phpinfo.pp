class profile::application::phpinfo (
  String $user,
) {

  file { "/home/${user}/www":
    ensure => directory,
  }

  file { "/home/${user}/www/index.php":
    ensure => file,
    content => '<?php phpinfo();?>',
  }
}