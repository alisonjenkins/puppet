class profile::sevendaystodie (
  Integer $server_telnet_port,
  String $server_telnet_password,
  Integer $server_auto_update,
  String $server_update_branch,
  String $world_path,
  String $backup_bucket_path,
  String $backup_retention,
  String $cron_service,
  String $cron_service_package,
) {

  docker::run {'7dtd':
    image   => 'didstopia/7dtd-server',
    ports   => [
      '26900:26900'
    ],
    expose  => [
      '26900',
    ],
    env     => [
      "SEVEN_DAYS_TO_DIE_TELNET_PORT=${server_telnet_port}",
      "SEVEN_DAYS_TO_DIE_TELNET_PASSWORD=${server_telnet_password}",
      "SEVEN_DAYS_TO_DIE_TELNET_PORT=${server_telnet_port}",
      "SEVEN_DAYS_TO_DIE_UPDATE_CHECKING=${server_auto_update}",
      "SEVEN_DAYS_TO_DIE=${server_update_branch}",
    ],
    volumes => [
      "${world_path}:/steamcmd/7dtd"
    ]
  }

  file { 'create 7dtd config file':
    path    => "${world_path}/server_data/serverconfig.xml",
    content => epp('data/7dtd/serverconfig.xml.epp'),
    mode    => '0664',
    notify  => Docker::Run['7dtd'],
  }

  ensure_packages([$cron_service_package, 'python2-boto'], { 'ensure' => 'present' })
  ensure_resource('service', $cron_service, { 'ensure' => 'running', 'enable' => true, })

  duplicity { '7dtd_backup':
    directory         => "${world_path}/server_data",
    target            => $backup_bucket_path,
    remove_older_than => $backup_retention,
    require           => Package[$cron_service_package],
  }

}
