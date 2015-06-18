# Manage the puppetdb.conf file on the puppeet master. See README.md for more
# details.
class puppetdb::master::puppetdb_conf (
  $server             = 'localhost',
  $port               = '8081',
  $soft_write_failure = $puppetdb::disable_ssl ? {
    true => true,
    default => false,
  },
  $puppet_confdir     = $puppetdb::params::puppet_confdir,
) inherits puppetdb::params {

  file { "${puppet_confdir}/puppetdb.conf":
    ensure => present,
    owner  => 'root',
    group  => 'puppet',
    mode   => '0640',
  }

  Ini_setting {
    ensure  => present,
    section => 'main',
    path    => "${puppet_confdir}/puppetdb.conf",
    require => File["${puppet_confdir}/puppetdb.conf"],
  }

  ini_setting { 'puppetdbserver':
    setting => 'server',
    value   => $server,
    require => File["${puppet_confdir}/puppetdb.conf"],
  }

  ini_setting { 'puppetdbport':
    setting => 'port',
    value   => $port,
    require => File["${puppet_confdir}/puppetdb.conf"],
  }

  ini_setting { 'soft_write_failure':
    setting => 'soft_write_failure',
    value   => $soft_write_failure,
    require => File["${puppet_confdir}/puppetdb.conf"],
  }
}
