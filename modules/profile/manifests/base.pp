class profile::base (
  $ntp_servers = [],
  $fallback_ntp_servers = [],
  $base_packages = [
      'augeas',
      'aws-cli',
      'bash-completion',
      'docker',
      'git',
      'htop',
      'moreutils',
      'ncdu',
      'pkgfile',
      'ranger',
      'rsync',
      'tmux',
      'vim'
  ],
  $user_accounts = {},
  $passwordless_sudo = false,
)
{
  if $facts['os']['family'] =~ /linux$/ {
    # {{{ Define refresh packages command
    exec {'pacman-Sy':
        command     => '/usr/bin/pacman -Sy',
        refreshonly => true,
    } # }}}
    # {{{ Add my custom Arch repository
    file { 'add custom arch repo':
        ensure  => file,
        path    => '/etc/pacman.d/arch.repo.alan-jenkins.com.conf',
        content => epp('data/arch/arch.repo.alan-jenkins.com.epp'),
        notify  => Exec['pacman-Sy'],
    } # }}}
    # {{{ Install packages that should be on all machines.
    ensure_packages($base_packages, { 'ensure' => 'present' })
    # }}}
    # {{{ Initialise pkgfile
    exec {'initialise pkgfile':
      command => '/usr/bin/pkgfile -u',
      unless  => '/usr/bin/test -f /var/cache/pkgfile/core.files',
      require => Package['pkgfile']
    }
    # }}}
    # {{{ Sort out timesync and timezones
    class { 'timezone': }

    file_line { 'NTP config':
      ensure => present,
      path   => '/etc/systemd/timesyncd.conf',
      line   => 'NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org',
      match  => '^NTP=',
      notify => Exec['systemd-timesyncd']
    }

    file_line { 'NTP config fallback':
      ensure => present,
      path   => '/etc/systemd/timesyncd.conf',
      line   => 'FallbackNTP=0.pool.ntp.org 1.pool.ntp.org 0.fr.pool.ntp.org',
      match  => '^FallbackNTP=',
      notify => Exec['systemd-timesyncd']
    }

    exec { 'systemd-timesyncd':
      command => '/usr/bin/timedatectl set-ntp true',
      unless  => '/usr/bin/timedatectl status | /usr/bin/grep \'NTP synchronized: yes\''
    }# }}}
    # {{{ sudo configuration
    if $passwordless_sudo {
      file { 'Add passwordless sudo for members of wheel group':
        ensure  => file,
        path    => '/etc/sudoers.d/wheel',
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        content => '%wheel ALL = (ALL) NOPASSWD: ALL'
      }
    } else {
      file { 'Add sudo access for members of wheel group':
        ensure  => file,
        path    => '/etc/sudoers.d/wheel',
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        content => '%wheel ALL = (ALL) ALL'
      }
    }

    file { 'keep ssh_auth_sock':
      ensure  => file,
      path    => '/etc/sudoers.d/keep_auth_sock',
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      content => "Defaults env_keep += SSH_AUTH_SOCK\n"
    }
    # }}}
    # {{{ User creation
    account {'users':
      users => $user_accounts
    }
    # }}}
  # {{{ systemd timers
  systemd_cron {'pkgfile_update':
    on_calendar         => '*:15',
    service_description => 'Update pkgfile',
    timer_description   => 'Update pkgfile daily at 1500',
    command             => '/usr/bin/pkgfile -u',
    require             => Package['pkgfile'],
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
