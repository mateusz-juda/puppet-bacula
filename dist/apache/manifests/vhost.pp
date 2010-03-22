define apache::vhost(
    $port, 
    $docroot,
    $webdir,
    $ssl=true, 
    $template='apache/vhost-default.conf.erb'
  ) {
  include apache
  $apachedir = $operatingsystem? {
    'ubuntu' => '/etc/apache2/sites-enabled/',
    default  => '/etc/httpd/conf.d',
  }
  file{"${apachedir}/${name}":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => '777',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
}
