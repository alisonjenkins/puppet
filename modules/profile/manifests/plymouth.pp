class profile::plymouth (
  String $display_manager = 'sddm',
  Boolean $encryption = true,
  Boolean $systemd = true,
) {

  package { 'plymouth':
    ensure => installed,
  }

  if $encryption and $systemd {
    file_line { 'Enable encryption hook':
    }
  }

}
