class profile::networkmanager(
  Array $packages = [
  'network-manager-applet',
  'networkmanager',
  'networkmanager-openconnect',
  'networkmanager-openvpn',
  'networkmanager-pptp',
  'networkmanager-vpnc',
  ]
){

  ensure_packages($packages, { 'ensure' => 'present' })

  package { 'networkmanager':
    ensure => installed,
  } ->
  service { 'NetworkManager':
    enable    => true,
  }
}
