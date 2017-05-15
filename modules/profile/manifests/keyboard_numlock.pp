class profile::keyboard_numlock (
  $default = 'on'
)
{
  if $default == 'on' {
    package { 'numlockx':
      ensure => installed,
    }

    file_line { 'enable numlock':
      ensure => present,
      line   => 'greeter-setup-script=/usr/bin/numlockx on',
      match  => '^#?greeter-setup-script=',
      path   => '/etc/lightdm/lightdm.conf'
    }
  }
  else
  {
    package { 'numlockx':
      ensure => absent
    }

    file_line { 'disable numlock config':
      ensure => present,
      line   => '#greeter-setup-script=',
      match  => '^greeter-setup-script=',
      path   => '/etc/lightdm/lightdm.conf'
    }
  }
}
