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

    Package { provider => chocolatey, }

    $windows_packages = [
      '7zip',
      'autohotkey',
      'classic-shell',
      'dropbox',
      'filezilla',
      'gimp',
      'git',
      'googlechrome',
      'googledrive',
      'inkscape',
      'javaruntime',
      'libreoffice',
      'nmap',
      'pidgin',
      'putty',
      'sumatrapdf',
      'sysinternals',
      'vagrant',
      'vim',
      'virtualbox',
      'vlc',
    ]

    package {$windows_packages:
      ensure => latest,
    }
  }# }}}
}
