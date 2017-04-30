define aurpkg (
  $user = undef,
  $packages = [],
) {
  # {{{ Install cower
  exec {'download cower':
    command => '/usr/bin/curl https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz -o /tmp/cower.tar.gz',
    unless  => '/usr/bin/pacman -Qi cower',
  }

  file { '/tmp/cower':
    ensure  => directory,
    owner   => $user,
    mode    => '0755',
  }

  exec { 'untar cower':
    command => '/usr/bin/tar xvf /tmp/cower.tar.gz',
    cwd     => '/tmp/',
    user    => $user,
    onlyif  => '/usr/bin/ls /tmp/cower.tar.gz',
    unless  => '/usr/bin/pacman -Qi cower',
    require => [
      Exec['download cower'],
      File['/tmp/cower']
    ]
  }

  exec { 'makepkg cower':
    command => '/usr/bin/makepkg --skippgpcheck',
    cwd     => '/tmp/cower',
    user    => $user,
    unless  => '/usr/bin/pacman -Qi cower',
    require => File['/tmp/cower']
  }

  exec { '/usr/bin/pacman --noconfirm -U cower*.pkg.tar.xz':
    cwd      => '/tmp/cower',
    unless   => '/usr/bin/pacman -Qi cower',
    provider => shell,
    require  => Exec['makepkg cower']
  }

  exec { '/usr/bin/rm -Rf /tmp/cower':
    onlyif => '/usr/bin/ls /tmp/cower'
  }
  # }}}
  # {{{ Install pacaur
  package { 'expac':
    ensure => latest,
  }

  exec {'download pacaur':
    command => '/usr/bin/curl https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz -o /tmp/pacaur.tar.gz',
    unless  => '/usr/bin/pacman -Qi pacaur',
  }

  file { '/tmp/pacaur':
    ensure  => directory,
    owner   => $user,
    mode    => '0755',
    require => Exec['download pacaur']
  }

  exec { 'untar pacaur':
    command => '/usr/bin/tar xvf /tmp/pacaur.tar.gz',
    cwd     => '/tmp/',
    user    => $user,
    onlyif  => '/usr/bin/ls /tmp/pacaur.tar.gz',
    unless  => '/usr/bin/pacman -Qi pacaur',
    require => [
      Exec['download pacaur'],
      File['/tmp/pacaur'],
    ]
  }


  exec { 'makepkg pacaur':
    command => '/usr/bin/makepkg',
    cwd     => '/tmp/pacaur',
    user    => $user,
    unless  => '/usr/bin/pacman -Qi pacaur',
    require => [
      File['/tmp/pacaur'],
      Package['expac']
    ]
  }

  exec { '/usr/bin/pacman --noconfirm -U pacaur*.pkg.tar.xz':
    cwd      => '/tmp/pacaur',
    unless   => '/usr/bin/pacman -Qi pacaur',
    provider => shell,
    require  => Exec['makepkg pacaur']
  }

  exec { '/usr/bin/rm -Rf /tmp/pacaur':
    onlyif => '/usr/bin/ls /tmp/pacaur'
  }
  # }}}
  # {{{ if package not installed
  exec { "/usr/bin/cower --d -d $title":
    cwd         => "/home/$user",
    provider    => shell,
    environment => [
      'HOME=/home/alan',
    ],
    user        => $user,
  }
  # }}}
  # {{{ if package already installed
  ## Get current installed version
  ## Get latest version
  # exec {"/usr/bin/curl https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=$title":
  # }

  ## If latest version newer than installed version


  # }}}
}
