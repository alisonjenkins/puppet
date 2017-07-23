class profile::php56 (
  Integer $listen_port,
  Array $volumes,
  Array $dns_servers,
) {
  docker::run { 'php56':
    image            => 'php:5.6-fpm-alpine',
    ports            => [
      "9000:${listen_port}",
    ],
    expose           => [
      "${listen_port}/tcp"
    ],
    volumes          => $volumes,
    restart_service  => true,
    dns              => ['8.8.8.8', '8.8.4.4'],
    pull_on_start    => true,
    extra_parameters => ['--restart=always'],
  }
}
