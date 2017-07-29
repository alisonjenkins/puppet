class profile::ctrlaltdave (
) {

  group { 'ctrlaltdave':
    ensure => present,
  }

  file {'ctrlaltdave nginx config':
    ensure  => file,
    path    => '/etc/nginx/sites-available/ctrlaltdave.conf',
    content => epp('data/ctrlaltdave/nginx.conf.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    notify  => Service['nginx'],
  }

  file {'enable ctrlaltdave nginx config':
    ensure  => link,
    path    => '/etc/nginx/sites-enabled/ctrlaltdave.conf',
    target  => '/etc/nginx/sites-available/ctrlaltdave.conf',
    require => [
      File['ctrlaltdave nginx config'],
      File['/etc/nginx/sites-enabled'],
    ],
    notify  => Service['nginx'],
  }

  file { 'ctrlaltdave site directory':
    ensure  => directory,
    path    => '/srv/http/ctrlaltdave',
    owner   => 'http',
    group   => 'ctrlaltdave',
    recurse => true,
    mode    => '0775',
    require => Group['ctrlaltdave'],
  }

}
