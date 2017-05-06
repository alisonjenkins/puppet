class profile::xps13_touchpad(
  $acceleration_profile = 'adaptive',
  $acceleration_speed = '0.7',
  $click_method = 'clickfinger',
  $config_path = '/etc/X11/xorg.conf.d/30-touchpad.conf',
  $disable_while_typing = 'true',
  $horizontal_scrolling = 'true',
  $natural_scrolling = 'false',
  $scroll_method = 'two-finger',
  $tap_to_click = 'off'
) {
  file { 'X11 touchpad configuration':
    source => epp("puppet://modules/data/x11/touchpad.conf"),
    path   => $config_path,
    mode   => '0744'
  }
}
