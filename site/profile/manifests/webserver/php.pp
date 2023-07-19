class profile::webserver::php (
  String $user,
  String $fqdn,
) inherits profile::webserver {

  $major_version = 8
  $minor_version = 1
  $version = "${major_version}.${minor_version}"

  class { '::php::globals':
    php_version => $version,
  }

  class { '::php':
    ensure       => ">=${version} <${major_version}.${$minor_version + 1}",
    manage_repos => true,
    dev          => false,
    composer     => false,
    pear         => false,
    phpunit      => false,
    fpm          => true,
    fpm_user     => 'www-data',
    fpm_group    => 'www-data',
    fpm_pools    => { },
    pool_purge   => true,
  }

  php::fpm::pool { "php-${version}-${user}":
    user         => $user,
    group        => $user,
    listen_owner => 'www-data',
    listen_group => 'www-data',
    listen_mode  => '0660',
    listen       => "/var/run/php-fpm/${user}-fpm.sock",
  }

  user { $user:
    ensure     => present,
    managehome => true,
    system     => true,
  }

  class { profile::application::phpinfo :
    user => $user,
  }

  nginx::resource::server { $fqdn:
    ensure   => present,
    www_root => "/home/${user}/www",
  }

  nginx::resource::location { "${user}_root":
    ensure      => present,
    server      => $fqdn,
    www_root    => "/home/${user}/www",
    location    => '~ \.php$',
    index_files => ['index.php'],
    fastcgi     => "unix:/var/run/php-fpm/${user}-fpm.sock",
  }
}