class profile::sevendaystodie (
  Integer $server_telnet_port,
  String $server_telnet_password,
  Integer $server_auto_update,
  String $world_path,
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
      "SEVEN_DAYS_TO_DIE_UPDATE_CHECKING=${server_auto_update}",
    ],
    volumes => [
      "${world_path}:/steamcmd/7dtd"
    ]
  }
}
