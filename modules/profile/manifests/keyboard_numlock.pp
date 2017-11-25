class profile::keyboard_numlock (
  $default = 'on'
)
{
  if $default == 'on' {
    ini_setting {'enable numlock on boot':
      ensure  => present,
      path    => '/etc/sddm.conf',
      section => 'General',
      setting => 'Numlock',
      value   => 'on'
    }
  }
  else
  {
    ini_setting {'disable numlock on boot':
      ensure  => present,
      path    => '/etc/sddm.conf',
      section => 'General',
      setting => 'Numlock',
      value   => 'off'
    }
  }
}
