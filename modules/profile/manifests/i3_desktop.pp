class profile::i3_desktop (
  $packages = undef
) {
  package {$packages:
    ensure => latest,
  }

  file { 'i3exit':
    ensure  => file,
    path    => '/usr/local/bin/i3exit',
    content => 'puppet:///data/i3/i3exit',
    mode    => '0755',
    owner   => 'root',
  }
}
