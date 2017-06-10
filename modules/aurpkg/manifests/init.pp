define aurpkg (
  $user = undef,
  $packages = [],
) {
  package { 'cower':
    ensure => latest,
  }
  package { 'pacaur':
    ensure => latest,
  }

  exec { "/usr/bin/cower --d -d $title":
    cwd         => "/home/$user",
    provider    => shell,
    environment => [
      'HOME=/home/alan',
    ],
    user        => $user,
  }
}
