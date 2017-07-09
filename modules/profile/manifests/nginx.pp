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

  $nginx_dirs = [
    '/etc/nginx',
    '/etc/nginx/sites-available',
    '/etc/nginx/sites-enabled',
  ]

  ensure_resource('file', $nginx_dirs, {
    'ensure' => 'directory',
  })
}
