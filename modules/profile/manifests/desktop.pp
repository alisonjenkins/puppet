class profile::desktop (
    $desktop_aur_packages = [],
    $desktop_packages = [],
    $packager = undef,
    $magic_keys = 'present',
)
{
    package { $desktop_packages: ensure => latest }

    # aur_key_trust { '487EACC08557AD082088DABA1EB2638FF56C0C53':
    #     user => $packager
    # } ->
    # aurpkg { $desktop_aur_packages:
    #     user => $packager
    # }

    service { 'lightdm':
        enable  => true,
        require => Package['lightdm']
    }

    file_line{'magic keys':
        ensure => $magic_keys,
        path   => '/etc/sysctl.d/magic_keys.conf',
        line   => 'kernel.sysrq=1',
        match  => '^kernel.sysrq=',
    }
}
