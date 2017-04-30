define aurpkg (
  $user = undef
) {
  # {{{ Install cower
  remote_file {"$title - download cower":
    ensure => present,
    path   => '/tmp/cower.tar.gz',
    source => 'https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz',
    unless => '/usr/bin/pacman -Qi cower'
  }

  exec {"$title - untar cower":
    command => '/usr/bin/tar xvf /tmp/cower.tar.gz',
    cwd     => '/tmp/',
    onlyif  => '/usr/bin/ls /tmp/cower.tar.gz',
    unless  => '/usr/bin/pacman -Qi cower',
    require => Remote_file["$title - download cower"]
  }

  file { "$title - fix cower dir perms":
    path    => '/tmp/cower',
    ensure  => directory,
    owner   => $user,
    mode    => '0777',
    require => Exec["$title - untar cower"]
  }

  exec { "$title - makepkg cower":
    command => '/usr/bin/makepkg --skippgpcheck',
    cwd     => '/tmp/cower',
    user    => $user,
    unless  => '/usr/bin/pacman -Qi cower',
    require => File["$title - fix cower dir perms"]
  }

  exec { "$title - install cower":
    command  => '/usr/bin/pacman --noconfirm -U cower*.pkg.tar.xz',
    cwd      => '/tmp/cower',
    unless   => '/usr/bin/pacman -Qi cower',
    provider => shell,
    require  => Exec['makepkg cower']
  }

  file { "$title - cower cleanup":
    ensure => absent,
    path   => '/tmp/cower'
  }
  # }}}
  # {{{ Install pacaur
  # package { 'expac':
  #   ensure => latest,
  # }

  # remote_file {'/tmp/pacaur.tar.gz':
  #   ensure => present,
  #   source => 'https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz',
  #   unless => '/usr/bin/pacman -Qi pacaur',
  # }

  # exec { '/usr/bin/tar xvf /tmp/pacaur.tar.gz':
  #   cwd     => '/tmp/',
  #   onlyif  => '/usr/bin/ls /tmp/pacaur.tar.gz',
  #   unless  => '/usr/bin/pacman -Qi pacaur',
  #   require => Remote_file['/tmp/pacaur.tar.gz']
  # }

  # file { '/tmp/pacaur':
  #   ensure  => directory,
  #   owner   => $user,
  #   mode    => '0777',
  #   require => Exec['/usr/bin/tar xvf /tmp/pacaur.tar.gz']
  # }

  # exec { 'makepkg pacaur':
  #   command => '/usr/bin/makepkg',
  #   cwd     => '/tmp/pacaur',
  #   user    => $user,
  #   unless  => '/usr/bin/pacman -Qi pacaur',
  #   require => [
  #     File['/tmp/pacaur'],
  #     Package['expac']
  #   ]
  # }

  # exec { '/usr/bin/pacman --noconfirm -U pacaur*.pkg.tar.xz':
  #   cwd      => '/tmp/pacaur',
  #   unless   => '/usr/bin/pacman -Qi pacaur',
  #   provider => shell,
  #   require  => Exec['makepkg pacaur']
  # }

  # exec { '/usr/bin/rm -Rf /tmp/pacaur':
  #   onlyif => '/usr/bin/ls /tmp/pacaur'
  # }
  # # }}}
  # # {{{ if package not installed
  # exec { "/usr/bin/cower --d -d $title":
  #   cwd         => "/home/$user",
  #   provider    => shell,
  #   environment => [
  #     'HOME=/home/alan',
  #   ],
  #   user        => $user,
  # }
  # # }}}
  # {{{ if package already installed
  ## Get current installed version
  ## Get latest version
  # exec {"/usr/bin/curl https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=$title":
  # }

  ## If latest version newer than installed version


  # }}}
}
