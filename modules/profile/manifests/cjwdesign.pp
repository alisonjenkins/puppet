class profile::cjwdesign (
  String $cjwdesign_db_host,
  String $cjwdesign_db_database,
  String $cjwdesign_db_user,
  String $cjwdesign_db_pass,
  String $drupal_config_path,
) {


  file {'cjwdesign nginx config':
    ensure  => file,
    path    => '/etc/nginx/sites-available/cjwdesign.net.conf',
    content => epp('data/cjwdesign.net/nginx.conf.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    notify  => Service['nginx'],
  }

  file {'enable cjwdesign nginx config':
    ensure  => link,
    path    => '/etc/nginx/sites-enabled/cjwdesign.net.conf',
    target  => '/etc/nginx/sites-available/cjwdesign.net.conf',
    require => [
      File['cjwdesign nginx config'],
      File['/etc/nginx/sites-enabled'],
    ],
    notify  => Service['nginx'],
  }

  file { 'cjwdesign site directory':
    ensure => directory,
    path   => '/srv/http/cjwdesign.net',
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }

  file_line { 'cjwdesign db host':
    ensure => present,
    line   => "^  'host' => '${cjwdesign_db_host}',",
    match  => '^  \'host\' => .*$',
    path   => $drupal_config_path,
    notify => Service['nginx'],
  }

  file_line { 'cjwdesign db database':
    ensure => present,
    line   => "^  'database' => '${cjwdesign_db_database}',",
    match  => '^  \'database\' => .*$',
    path   => $drupal_config_path,
    notify => Service['nginx'],
  }

  file_line { 'cjwdesign db user':
    ensure => present,
    line   => "^  'username' => '${cjwdesign_db_user}',",
    match  => '^  \'username\' => .*$',
    path   => $drupal_config_path,
    notify => Service['nginx'],
  }

  file_line { 'cjwdesign db pass':
    ensure => present,
    line   => "^  'password' => '${cjwdesign_db_pass}',",
    match  => '^  \'password\' => .*$',
    path   => $drupal_config_path,
    notify => Service['nginx'],
  }

  mysql::db { $cjwdesign_db_database:
    user     => $cjwdesign_db_database,
    password => $cjwdesign_db_pass,
    host     => $cjwdesign_db_host,
    grant    => [
      'SELECT',
      'UPDATE',
      'INSERT',
      'CREATE'
    ],
    require  => Service['mysql'],
  }

}
