class profile::bluetooth(
  $bluetooth_packages = [
    'bluez',
    'bluez-firmware',
    'bluez-libs',
    'bluez-utils',
    'pulseaudio-bluetooth'
  ]
) {
  package { $bluetooth_packages:
    ensure => installed,
  }

  service { 'bluetooth':
    hasstatus => true,
    enable    => true,
    require   => Package['bluez']
  }

  file_line { 'enable bluetooth on boot':
    ensure => present,
    line   => 'AutoEnable=true',
    path   => '/etc/bluetooth/main.conf',
    match  => '^#?AutoEnable=',
    notify => Service['bluetooth']
  }

  file_line { 'enable pulsaudio auto switch output':
    ensure => present,
    line   => 'load-module module-switch-on-connect',
    path   => '/etc/pulse/default.pa',
  }

  file_line { 'enable uinput module on boot':
    ensure => present,
    line   => 'uinput',
    path   => '/etc/modules-load.d/uinput.conf',
    notify => [
      Exec['load uinput'],
    ]
  }

  exec { 'load uinput':
    command     => '/usr/bin/modprobe uinput',
    notify      => Service['bluetooth'],
    refreshonly => true,
  }
}
