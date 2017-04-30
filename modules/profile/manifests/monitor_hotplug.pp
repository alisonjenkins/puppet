class profile::monitor_hotplug
(
  $user,
  $int_display_name = 'eDP-1',
  $ext_display_name = 'DP-1',
  $ext_display_drm_path = '/sys/class/drm/card0-DP-1',
  $locations = {},
) {
  exec {'systemctl daemon-reload':
    command     => '/usr/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  package {'jq':
    ensure => latest,
  }

  # install monitor hotplug script
  file {'/usr/local/bin/monitor_hotplug':
    ensure  => file,
    content => epp('data/monitor_hotplug/script.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  } ->

  # install udev rule
  file {'/etc/udev/rules.d/99-monitor_hotplug.rules':
    ensure  => file,
    content => epp('data/monitor_hotplug/udev_rules.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  } ->

  # add systemd unit file
  file {'/etc/systemd/system/monitor_hotplug.service':
    ensure  => file,
    content => epp('data/monitor_hotplug/systemd_service.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    notify  => Exec['systemctl daemon-reload'],
  } ->
  service { 'monitor_hotplug':
    enable    => true,
  }

  # instill i3 move workspace script
  file {'/usr/local/bin/i3-move-workspaces':
    ensure  => file,
    mode    => '0755',
    content => epp('data/monitor_hotplug/i3_move_workspaces.epp'),
  }
}
