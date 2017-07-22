class profile::minecraft (
    String $minecraft_uid = '995',
    String $minecraft_gid = '994',
    Array $dirs = [
        '/srv/minecraft',
        '/srv/minecraft/direwolf20',
        '/srv/minecraft/direwolf20/backups/',
        '/srv/minecraft/direwolf20/config.override/',
        '/srv/minecraft/direwolf20/config/',
        '/srv/minecraft/direwolf20/config/JourneyMapServer',
        '/srv/minecraft/direwolf20/crash-reports',
        '/srv/minecraft/direwolf20/logs',
        '/srv/minecraft/direwolf20/mods.override/',
        '/srv/minecraft/direwolf20/world',
        '/srv/minecraft/skyfactory3',
        '/srv/minecraft/skyfactory3/world',
        '/srv/minecraft/skyfactory3/logs',
        '/srv/minecraft/skyfactory3/crash-reports',
        '/srv/minecraft/skyfactory3/config/',
        '/srv/minecraft/skyfactory3/config.override/',
        '/srv/minecraft/skyfactory3/mods.override/',
        '/srv/minecraft/skyfactory3/backups/',
        '/srv/minecraft/skyfactory3/config/JourneyMapServer',
    ],
    Array $files = [
        '/srv/minecraft/direwolf20/banned-ips.json',
        '/srv/minecraft/direwolf20/banned-players.json',
        '/srv/minecraft/direwolf20/ops.json',
        '/srv/minecraft/direwolf20/server.properties',
        '/srv/minecraft/direwolf20/usercache.json',
        '/srv/minecraft/direwolf20/whitelist.json',
        '/srv/minecraft/skyfactory3/banned-ips.json',
        '/srv/minecraft/skyfactory3/usercache.json',
        '/srv/minecraft/skyfactory3/whitelist.json',
        '/srv/minecraft/skyfactory3/server.properties',
        '/srv/minecraft/skyfactory3/banned-players.json',
        '/srv/minecraft/skyfactory3/ops.json',
    ]
)
{
    include 'docker'

    group { 'minecraft':
        ensure => present,
        gid    => $minecraft_gid,
    }

    user { 'minecraft':
        ensure  => present,
        uid     => $minecraft_uid,
        system  => true,
        require => Group['minecraft']
    }

    file { $dirs:
        ensure  => directory,
        owner   => 'minecraft',
        group   => 'minecraft',
        mode    => '0700',
        require => [
            User['minecraft'],
            Group['minecraft'],
        ]

    }

    file { $files:
        ensure  => file,
        force   => true,
        owner   => 'minecraft',
        group   => 'minecraft',
        mode    => '0700',
        require => [
            User['minecraft'],
            Group['minecraft'],
        ]
    }

    $direwolf_vols = [
        '/srv/minecraft/direwolf20/world:/srv/minecraft/world',
        '/srv/minecraft/direwolf20/banned-ips.json:/srv/minecraft/banned-ips.json',
        '/srv/minecraft/direwolf20/banned-players.json:/srv/minecraft/banned-players.json',
        '/srv/minecraft/direwolf20/logs:/srv/minecraft/logs',
        '/srv/minecraft/direwolf20/crash-reports:/srv/minecraft/crash-reports',
        '/srv/minecraft/direwolf20/ops.json:/srv/minecraft/ops.json',
        '/srv/minecraft/direwolf20/usercache.json:/srv/minecraft/usercache.json',
        '/srv/minecraft/direwolf20/whitelist.json:/srv/minecraft/whitelist.json',
        '/srv/minecraft/direwolf20/server.properties:/srv/minecraft/server.properties',
        '/srv/minecraft/direwolf20/config/JourneyMapServer:/srv/minecraft/config/JourneyMapServer',
        '/srv/minecraft/direwolf20/backups:/srv/minecraft/backups',
        '/srv/minecraft/direwolf20/mods.override:/srv/minecraft/mods.override',
        '/srv/minecraft/direwolf20/config.override:/srv/minecraft/config.override',
    ]

    docker::run { 'direwolf20-1.7.10':
        image            => 'demon012/minecraft-direwolf20',
        ports            => [
            '25565:25565',
        ],
        expose           => [
            '25565/tcp',
        ],
        env              => [ 'MCMEM=4000' ],
        volumes          => $direwolf_vols,
        memory_limit     => '4096m', # (format: '<number><unit>', where unit = b, k, m or g)
        dns              => ['8.8.8.8', '8.8.4.4'],
        restart_service  => true,
        pull_on_start    => true,
        extra_parameters => ['--restart=always'],
    }

    $skyfactory3_vols = [
        '/srv/minecraft/skyfactory3/world:/srv/minecraft/world',
        '/srv/minecraft/skyfactory3/banned-ips.json:/srv/minecraft/banned-ips.json',
        '/srv/minecraft/skyfactory3/banned-players.json:/srv/minecraft/banned-players.json',
        '/srv/minecraft/skyfactory3/logs:/srv/minecraft/logs',
        '/srv/minecraft/skyfactory3/crash-reports:/srv/minecraft/crash-reports',
        '/srv/minecraft/skyfactory3/ops.json:/srv/minecraft/ops.json',
        '/srv/minecraft/skyfactory3/usercache.json:/srv/minecraft/usercache.json',
        '/srv/minecraft/skyfactory3/whitelist.json:/srv/minecraft/whitelist.json',
        '/srv/minecraft/skyfactory3/server.properties:/srv/minecraft/server.properties',
        '/srv/minecraft/skyfactory3/config/JourneyMapServer:/srv/minecraft/config/JourneyMapServer',
        '/srv/minecraft/skyfactory3/backups:/srv/minecraft/backups',
        '/srv/minecraft/skyfactory3/mods.override:/srv/minecraft/mods.override',
        '/srv/minecraft/skyfactory3/config.override:/srv/minecraft/config.override',
    ]

    docker::run { 'skyfactory3':
        image            => 'demon012/minecraft-skyfactory3',
        ports            => [
            '25566:25565',
        ],
        expose           => [
            '25565/tcp',
        ],
        env              => [
            "MCUID=${minecraft_uid}",
            "MCGID=${minecraft_gid}",
            'MCMEM=4000',
        ],
        volumes          => $skyfactory3_vols,
        memory_limit     => '4096m', # (format: '<number><unit>', where unit = b, k, m or g)
        dns              => ['8.8.8.8', '8.8.4.4'],
        restart_service  => true,
        pull_on_start    => true,
        extra_parameters => ['--restart=always'],
    }
}
