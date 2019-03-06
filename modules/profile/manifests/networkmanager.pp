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

  service { 'NetworkManager':
    enable  => true,
    require => [
      Package['networkmanager']
    ]
  }
}
