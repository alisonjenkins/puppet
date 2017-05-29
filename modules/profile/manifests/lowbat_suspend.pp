class profile::lowbat_suspend(
  Integer $low_percentage = 8,
  String $command = '/usr/bin/systemctl suspend',
) {
  exec { 'reload udev rules':
    command     => '/usr/bin/udevadm control --reload',
    refreshonly => true,
  }
  file { 'create low battery udev rule':
    path    => '/etc/udev/rules.d/99-lowbat.rules',
    content => epp('data/udev/lowbat.rules.epp'),
    mode    => '0644',
    notify  => Exec['reload udev rules'],
  }
}
