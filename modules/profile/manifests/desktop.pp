class profile::desktop (
    $desktop_aur_packages = [],
    $desktop_packages,
    $packager = 'nobody',
    $magic_keys = 'present',
    $keyboard_options = 'ctrl:nocaps'
)
{

    ensure_packages($desktop_packages, { 'ensure' => 'latest' })

    # aur_key_trust { '487EACC08557AD082088DABA1EB2638FF56C0C53':
    #     user => $packager
    # } ->
    #aurpkg { 'install aur packages':
    #    user     => $packager,
    #    packages => $desktop_aur_packages
    #}

    service { 'sddm':
        enable  => true,
        require => Package['sddm']
    }

    file {'magic keys':
        ensure  => $magic_keys,
        path    => '/etc/sysctl.d/magic_keys.conf',
        content => 'kernel.sysrq=1',
        notify  => Exec['sysctl refresh']
    }

    exec {'sysctl refresh':
        refreshonly => true,
        command     => '/usr/bin/sysctl --system'
    }

}
