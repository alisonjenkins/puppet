class profile::plymouth (
  $display_manager = 'lightdm',
  $encryption = true,
  $systemd = true,
) {

  package { 'plymouth':
    ensure => installed,
  }

  if $encryption and $systemd {
    file_line { 'Enable encryption hook':
    }
  }

}
