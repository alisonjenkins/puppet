class profile::mysql(
  String $root_password,
  String $server_package = 'mariadb',
  String $client_package = 'mariadb-clients',
  String $service_name = 'mariadb',
) {

  class { '::mysql::server':
    package_name            => $server_package,
    root_password           => $root_password,
    service_name            => $service_name,
    remove_default_accounts => true,
    override_options        => {
      mysqld => { bind-address => '0.0.0.0'}
    },
  }

  class { '::mysql::client':
    package_name    => $client_package,
  }

}
