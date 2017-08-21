class profile::tlp(
  $ensure = 'present',
) {

  package { 'tlp':
    ensure => $ensure,
  }

  if $ensure == 'present' {
    $tlp_service_enable = true
    $tlp_service_ensure = 'running'
  }

  service {'tlp':
    ensure => $tlp_service_ensure,
    enable => $tlp_service_enable,
  }

}
