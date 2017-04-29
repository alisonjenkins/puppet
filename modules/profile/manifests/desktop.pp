class profile::desktop (
    $desktop_aur_packages = [],
    $desktop_packages = [],
    $packager = undef
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
}
