class profile::php56 (
  Array $volumes,
  Integer $listen_port = 9000,
  Array $dns_servers = [
    '1.1.1.1',
    '1.0.0.1',
  ]
) {

  ensure_resource('service', 'docker' => { ensure => running, enable => true })

  file { '/tmp/php56':
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { 'php56-dockerfile':
    path    => '/tmp/php56/Dockerfile',
    content => template('data/php56/Dockerfile.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => File['/tmp/php56']
  }

  exec {"/usr/bin/docker build -t php56 .":
    cwd     => '/tmp/php56/',
    unless  => '/usr/bin/docker images | /usr/bin/grep php56',
    require => [
      Service['docker'],
      File['php56-dockerfile']
    ]
  }

  $volume_string_stage1 = join($volumes, ' -v ')
  $volumes_string = "-v ${volume_string_stage1}"

  exec {"/usr/bin/docker run -p ${listen_port}:9000 ${volumes_string} -d --restart='unless-stopped' --name php56 php56":
    unless  => '/usr/bin/docker ps | /usr/bin/awk \'NR>1 { print $13; }\' | grep php56',
    require => [
      Service['docker'],
      File['php56-dockerfile']
    ]
  }
}
