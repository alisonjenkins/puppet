class profile::cups (
  Boolean $install_gui = true,
  String $gui_package = 'system-config-printer',
  Array $packages = [
    'cups',
    'gtk3',
  ],
  String $cups_service_name = 'org.cups.cupsd.service',
) {
  if $install_gui == true
  {
    $install_packages = concat($packages, $gui_package)
  }
  else
  {
    $install_packages = $packages
  }

  ensure_packages($install_packages, {'ensure' => 'present'})

  service { $cups_service_name:
    hasstatus => true,
    enable    => true,
    ensure    => running,
    require   => Package['cups'],
  }
}
