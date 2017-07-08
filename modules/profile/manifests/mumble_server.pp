class profile::mumble_server (
  $package = 'umurmur'
) {
  ensure_packages($package, {'ensure' => 'latest'})

  service { 'umurmur':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
