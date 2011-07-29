# Class: nagios::dbservices
#
# This class installs and configures the Nagios hosts and services
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nagios::dbservices {

  #@@nagios_service { "check_mysql_${hostname}":
  #  use => 'generic-service',
  #  check_command => 'check_nrpe!check_mysql',
  #  host_name => "$fqdn",
  #  service_description => "check_mysql_${hostname}",
  #  target => '/etc/nagios3/conf.d/nagios_service.cfg',
  #  notify => Service[$nagios::params::nagios_service],
  #}

  @@nagios_service { "check_mysqld_${hostname}":
    use => 'generic-service',
    host_name => "$fqdn",
    check_command => 'check_nrpe!check_proc!1:1 mysqld',
    service_description => "check_mysqld_${hostname}",
    target => '/etc/nagios3/conf.d/nagios_service.cfg',
    notify => Service[$nagios::params::nagios_service],
  }

}