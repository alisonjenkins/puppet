class profile::xps13bluetooth (
  $windows_driver_url = 'http://downloads.dell.com/FOLDER03272920M/1/9350_Network_Driver_XMJK7_WN32_12.0.1.720_A00.EXE',
  $firmware_path = '/lib/firmware/brcm/BCM-0a5c-6412.hcd',
  $script_path = '/usr/local/bin/xps13-bluetooth-firmware'
)
{
  file { 'install bluetooth firmware script':
    source  => "puppet:///modules/data/xps13/XPS13-BLUETOOTH-FIRMWARE.sh",
    mode    => '0700',
    path    => $script_path,
  }

  exec { 'run xps13 firmware installation script':
    command => "$script_path $windows_driver_url",
    creates => $firmware_path,
    require => Package['p7zip']
  }
}
