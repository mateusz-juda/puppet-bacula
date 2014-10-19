# Class: bacula::ssl
#
# Manage the SSL deployment for bacula components, Director, Storage, and File.
class bacula::ssl (
  $ssl_dir  = $bacula::params::ssl_dir,
  $conf_dir = $bacula::params::conf_dir,
  $certfile = $bacula::params::certfile,
  $keyfile  = $bacula::params::keyfile,
  $cafile   = $bacula::params::cafile,
  $packages = $bacula::params::bacula_client_packages,
) inherits bacula::params {

  $ssl_files = [
    $certfile,
    $keyfile,
    $cafile
  ]

  File {
    owner   => 'bacula',
    group   => '0',
    mode    => '0640',
    require => Package[$packages],
  }

  file { $conf_dir:
    ensure => 'directory'
  } ->

  file { "${conf_dir}/ssl":
    ensure => 'directory'
  }

  file { $certfile:
    source  => "${ssl_dir}/certs/${::clientcert}.pem",
    require => File["${conf_dir}/ssl"],
  }

  file { $keyfile:
    source  => "${ssl_dir}/private_keys/${::clientcert}.pem",
    require => File["${conf_dir}/ssl"],
  }

  file { $cafile:
    ensure  => 'file',
    source  => "${ssl_dir}/certs/ca.pem",
    require => File["${conf_dir}/ssl"],
  }

  exec { 'generate_bacula_dhkey':
    command => 'openssl dhparam -out dh1024.pem -5 1024',
    cwd     => "${conf_dir}/ssl",
    creates => "${conf_dir}/ssl/dh1024.pem",
    require => File["${conf_dir}/ssl"],
  }
}
