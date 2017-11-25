class profile::i3_desktop (
  $packages
) {

  ensure_packages($packages, {'ensure' => 'present' })

  file { 'i3exit':
    ensure => file,
    path   => '/usr/local/bin/i3exit',
    source => 'puppet:///modules/data/i3/i3exit',
    mode   => '0755',
    owner  => 'root',
  }
}
