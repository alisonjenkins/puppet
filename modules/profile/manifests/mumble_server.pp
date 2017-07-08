class profile::mumble_server (
  $package = 'murmur',
  $service = 'murmur'
) {
  ensure_packages($package, {'ensure' => 'latest'})

  service { 'murmur':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
