class profile::cjwdesign (
  $packages = [
    'nginx'
  ],
) {
  import 'docker'

  ensure_packages($packages, {
    'ensure' => 'present'
  })

  ensure_resource('service', 'nginx', {
    'ensure'  => 'running',
    'enable'  => true,
    'require' => Package['nginx'],
  })

  $nginx_dirs = [
    '/etc/nginx',
    '/etc/nginx/sites-available',
    '/etc/nginx/sites-enabled',
  ]

  ensure_resources('file', $nginx_dirs, {
    'ensure' => 'directory',
  })

  file {'cjwdesign nginx config':
    ensure  => file,
    path    => '/etc/nginx/sites-available/cjwdesign.net.conf',
    content => epp('data/cjwdesign.net/nginx.conf.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    require => File['/etc/nginx/sites-available'],
    notify  => Service['nginx'],
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

  docker::run { 'php56':
    image            => 'php:5.6-fpm-alpine',
    ports            => [
      '9001:9001',
    ],
    expose           => [
      '9000'
    ],
    restart_service  => true,
    dns              => ['8.8.8.8', '8.8.4.4'],
    pull_on_start    => true,
    extra_parameters => ['--restart=always'],
  }
}
