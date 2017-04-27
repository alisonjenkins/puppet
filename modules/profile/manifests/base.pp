class profile::base (
  $ntp_servers = [],
  $fallback_ntp_servers = [],
  $base_packages = [
      'augeas',
      'aws-cli',
      'htop',
      'moreutils',
      'ncdu',
      'ranger',
      'rsync',
      'ruby-augeas',
      'tmux'
  ],
  $user_accounts = {},
)
{
  if $facts['os']['family'] =~ /linux$/ {
    # {{{ Define refresh packages command
    exec {'pacman-Sy':
        command     => '/usr/bin/pacman -Sy',
        refreshonly => true,
    } # }}}
    # {{{ Add my custom Arch repository
    file { '/etc/pacman.conf':
        ensure  => file,
        content => template('data/arch/pacman.conf.epp'),
        notify  => Exec['pacman-Sy'],
    } # }}}
    # {{{ Install packages that should be on all machines.
    package {$base_packages:
      ensure => present,
    } # }}}
# {{{ Sort out timesync and timezones
    class { 'timezone': }

    file_line { 'NTP config':
      ensure => present,
      path   => '/etc/systemd/timesyncd.conf',
      line   => 'NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org',
      match  => '^NTP=',
    } ->
    file_line { 'NTP config fallback':
      ensure => present,
      path   => '/etc/systemd/timesyncd.conf',
      line   => 'FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org',
      match  => '^FallbackNTP=',
    } ->
    exec { 'systemd-timesyncd':
      command => "/usr/bin/timedatectl set-ntp true",
      unless  => '/usr/bin/timedatectl status | /usr/bin/grep \'NTP synchronized: yes\''
    }# }}}
  # {{{ sudo configuration
    file { '/etc/sudoers.d/wheel':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0444',
    } ->
    file_line { 'wheel sudo access':
      ensure => present,
      line   => '%wheel ALL=(ALL) ALL',
      path   => '/etc/sudoers.d/wheel',
    }

    # }}}
    # {{{ User creation
    account {'users':
      users => $user_accounts
    }
    # }}}
  }
  elsif $facts['os']['family'] == 'windows' {# {{{
    include stdlib
    include chocolatey

    $puppetconfig = @(EOT)
    [main]
    server=puppet.alan-jenkins.com
    autoflush=true
    environment=production
    | EOT

    file {'C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf':
      ensure  => file,
      content => $puppetconfig
    }

    Package { provider => chocolatey, }

    package {'googlechrome':
      ensure => latest,
    }
    package {'filezilla':
      ensure => latest,
    }
    package {'gimp':
      ensure => latest,
    }
    package {'inkscape':
      ensure => latest,
    }
    package {'libreoffice':
      ensure => latest,
    }
    package {'7zip':
      ensure => latest,
    }
    package {'vim':
      ensure => latest,
    }
    package {'vagrant':
      ensure => latest,
    }
    package {'virtualbox':
      ensure => latest,
    }
    package {'putty':
      ensure => latest,
    }
    package {'git':
      ensure => latest,
    }
    package {'autohotkey':
      ensure => latest,
    }
    package {'dropbox':
      ensure => latest,
    }
    package {'googledrive':
      ensure => latest,
    }
    package {'sumatrapdf':
      ensure => latest,
    }
    package {'pidgin':
      ensure => latest,
    }
    package {'classic-shell':
      ensure => latest,
    }
    package {'nmap':
      ensure => latest,
    }
    package {'vlc':
      ensure => latest,
    }
    package {'sysinternals':
      ensure => latest,
    }
    package {'javaruntime':
      ensure => latest,
    }
    package {'sourcetree':
      ensure => latest,
    }
  }# }}}
}
