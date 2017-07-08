class profile::mumble_server (
  $package = 'murmur',
  $service = 'murmur'
) {
  ensure_packages($package, {'ensure' => 'latest'})

  service { $service:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package[$package]
  }

  file { 'mumble database paths':
    ensure  => directory,
    owner   => 'murmur',
    group   => 'murmur',
    path    => '/var/lib/murmur',
    require => Service[$service],
  }
}
