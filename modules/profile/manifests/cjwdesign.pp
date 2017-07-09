class profile::cjwdesign (
) {
  require profile::php56
  include profile::nginx

  file {'cjwdesign nginx config':
    ensure  => file,
    path    => '/etc/nginx/sites-available/cjwdesign.net.conf',
    content => epp('data/cjwdesign.net/nginx.conf.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    notify  => Service['nginx'],
    require => [
      Service['nginx'],
      File['/etc/nginx/sites-available'],
    ]
  }

  file {'enable cjwdesign nginx config':
    ensure  => link,
    path    => '/etc/nginx/sites-enabled/cjwdesign.net.conf',
    source  => '/etc/nginx/sites-available/cjwdesign.net.conf',
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
}
