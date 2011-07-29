class puppetlabs::pluto {

  ssh::allowgroup { "developers": }
  ssh::allowgroup { "prosvc": }

  # Customer Groups
  Account::User <| group == vmware |>
  Group <| title == vmware |>
  ssh::allowgroup { "vmware": chroot => true; }

  Account::User <| group == motorola |>
  Group <| title == motorola |>
  ssh::allowgroup { "motorola": chroot => true; }

  Account::User <| group == nokia |>
  Group <| title == nokia |>
  ssh::allowgroup { "nokia": chroot => true; }

  Account::User <| group == blackrock |>
  Group <| title == blackrock |>
  ssh::allowgroup { "blackrock": chroot => true; }

  Account::User <| group == secureworks |>
  Group <| title == secureworks |>
  ssh::allowgroup { "secureworks": chroot => true; }

  Account::User <| group == bioware |>
  Group <| title == bioware |>
  ssh::allowgroup { "bioware": chroot => true; }

  Account::User <| group == wealthfront |>
  Group <| title == wealthfront |>
  ssh::allowgroup { "wealthfront": chroot => true; }

  Account::User <| tag == deploy |>
  Account::User <| tag == deploy |>
  ssh::allowgroup { "www-data": }

  #enterprise 
  package { "lsyncd": ensure => absent; }
  package { "daemontools": ensure => installed; }
  cron { "sync /opt/enterprise to tbdriver":
    minute  => '*/10',
    user    => root,
    command => '/usr/bin/setlock -nx /var/run/_opt_enterprise_sync.lock /usr/local/bin/_opt_enterprise_sync.sh';
  }

  file { "/usr/local/bin/_opt_enterprise_sync.sh":
    owner  => root,
    group  => root,
    mode   => 750,
    source => "puppet:///modules/puppetlabs/_opt_enterprise_sync.sh";
  }

  # Crypt filesystem
  package { "cryptsetup": ensure => installed; }
  exec    { "/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4": creates => '/var/chroot.key'; }
  file    { "/var/chroot.key": mode => 0400, require => Exec["/bin/dd if=/dev/urandom of=/var/chroot.key bs=512 count=4"]; }

  file {
    "/opt/enterprise":
      owner   => root,
      group   => developers,
      mode    => 0664,
      recurse => true;
    "/opt/puppet":
      ensure  => directory,
      owner   => root,
      group   => www-data,
      mode    => 0664,
      recurse => true;
    "/opt/puppet/nightly":
      ensure  => directory,
      owner   => root,
      group   => www-data,
      mode    => 0664;
  }

}
