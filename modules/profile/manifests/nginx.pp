class profile::nginx (
  $package = 'nginx',
) {
  ensure_packages($package, {
    'ensure' => 'present'
  })

  ensure_resource('service', 'nginx', {
    'ensure'  => 'running',
    'enable'  => true,
    'require' => Package['nginx'],
  })

  file { 'nginx config':
    ensure  => file,
    path    => '/etc/nginx/nginx.conf',
    content => epp('data/nginx/nginx.conf.epp'),
    mode    => '0644',
  }

  $nginx_dirs = [
    '/etc/nginx',
    '/etc/nginx/sites-available',
    '/etc/nginx/sites-enabled',
  ]

  ensure_resource('file', $nginx_dirs, {
    'ensure' => 'directory',
  })
}
