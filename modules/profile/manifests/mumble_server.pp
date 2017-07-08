class profile::mumble_server (
  String $config,
  String $package = 'murmur',
  String $service = 'murmur',
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

  file { 'murmur config':
    ensure  => file,
    path    => '/etc/murmur.ini',
    owner   => 'murmur',
    group   => 'murmur',
    content => $config,
    mode    => '0640',
  }
}
