class profile::secure_ssh(
) {
  file_line { 'set no ssh password authentication':
    ensure => present,
    path   => '/etc/ssh/sshd_config',
    line   => 'PasswordAuthentication no',
    match  => '^PasswordAuthentication ',
    notify => Service['sshd']
  }

  file_line { 'set no ssh challenge response authentication':
    ensure => present,
    path   => '/etc/ssh/sshd_config',
    line   => 'ChallengeResponseAuthentication no',
    match  => 'ChallengeResponseAuthentication ',
    notify => Service['sshd']
  }
}
