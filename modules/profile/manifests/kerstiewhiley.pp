class profile::kerstiewhiley (
) {

  group { 'kerstiewhiley':
    ensure => present,
  }

  file {'kerstiewhiley nginx config':
    ensure  => file,
    path    => '/etc/nginx/sites-available/kerstiewhiley.conf',
    content => epp('data/kerstiewhiley/nginx.conf.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    notify  => Service['nginx'],
  }

  file {'enable kerstiewhiley nginx config':
    ensure  => link,
    path    => '/etc/nginx/sites-enabled/kerstiewhiley.conf',
    target  => '/etc/nginx/sites-available/kerstiewhiley.conf',
    require => [
      File['kerstiewhiley nginx config'],
      File['/etc/nginx/sites-enabled'],
    ],
    notify  => Service['nginx'],
  }

  file { 'kerstiewhiley site directory':
    ensure  => directory,
    path    => '/srv/http/kerstiewhiley',
    owner   => 'http',
    group   => 'kerstiewhiley',
    recurse => true,
    mode    => '0644',
    require => Group['kerstiewhiley'],
  }

}
