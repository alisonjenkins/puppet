class profile::tlp(
  $ensure = 'present',
) {

  package { 'tlp':
    ensure => $ensure,
  }

  if $ensure == 'present' {
    $service_enabled = true
    $service_ensure = 'started'_
  }

  service {'tlp':
    ensure  => $service_ensure,
    enabled => $service_enabled,
  }

}
