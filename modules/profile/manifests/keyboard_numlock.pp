class profile::keyboard (
  String $numlock_default = 'on',
  String $capslock_mode = '',
  String $model = 'pc104',
  String $layout = 'gb',
  String $variant = ',dvorak',
  String $options = '',
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
