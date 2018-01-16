class profile::minecraft_sprout (
    String $aws_id,
    String $aws_key,
    String $backup_bucket_path,
    String $backup_retention,
    String $minecraft_uid = '500',
    String $minecraft_gid = '500',
    Array $dirs = [
        '/home/minecraft',
        '/home/minecraft/sprout',
        '/home/minecraft/sprout/backups/',
        '/home/minecraft/sprout/config.override/',
        '/home/minecraft/sprout/config/',
        '/home/minecraft/sprout/config/JourneyMapServer',
        '/home/minecraft/sprout/crash-reports',
        '/home/minecraft/sprout/logs',
        '/home/minecraft/sprout/mods.override/',
        '/home/minecraft/sprout/world',
    ],
    Array $files = [
        '/home/minecraft/sprout/banned-ips.json',
        '/home/minecraft/sprout/banned-players.json',
        '/home/minecraft/sprout/ops.json',
        '/home/minecraft/sprout/server.properties',
        '/home/minecraft/sprout/usercache.json',
        '/home/minecraft/sprout/whitelist.json',
    ],
    Array $vols = [
        '/home/minecraft/sprout/world:/srv/minecraft/world',
        '/home/minecraft/sprout/banned-ips.json:/srv/minecraft/banned-ips.json',
        '/home/minecraft/sprout/banned-players.json:/srv/minecraft/banned-players.json',
        '/home/minecraft/sprout/logs:/srv/minecraft/logs',
        '/home/minecraft/sprout/crash-reports:/srv/minecraft/crash-reports',
        '/home/minecraft/sprout/ops.json:/srv/minecraft/ops.json',
        '/home/minecraft/sprout/usercache.json:/srv/minecraft/usercache.json',
        '/home/minecraft/sprout/usernamecache.json:/srv/minecraft/usernamecache.json',
        '/home/minecraft/sprout/whitelist.json:/srv/minecraft/whitelist.json',
        '/home/minecraft/sprout/server.properties:/srv/minecraft/server.properties',
        '/home/minecraft/sprout/journeymap:/srv/minecraft/journeymap',
        '/home/minecraft/sprout/TooManyGravesData:/srv/minecraft/TooManyGravesData',
        '/home/minecraft/sprout/backups:/srv/minecraft/backups',
        '/home/minecraft/sprout/mods.override:/srv/minecraft/mods.override',
        '/home/minecraft/sprout/config.override:/srv/minecraft/config.override',
    ],
    String $world_path = '/home/minecraft/sprout/world',
    String $container_name = 'sprout-minecraft',
    String $image_name = 'demon012/minecraft-sprout',
    String $max_ram = '8192',
    String $minecraft_user_home = '/home/minecraft',
    String $cron_service_package = 'cronie',
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
        home    => $minecraft_user_home,
        require => Group['minecraft']
    }

    ensure_packages($cron_service_package, {'ensure'   => 'present'})
    ensure_resources('service', {$cron_service_package => {'ensure' => 'running', 'enable' => 'true'}})

    file { $dirs:
        ensure  => directory,
        owner   => 'minecraft',
        group   => 'minecraft',
        mode    => '0700',
        recurse => true,
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

    docker::run { $container_name:
        image            => $image_name,
        ports            => [
            '25565:25565',
        ],
        expose           => [
            '25565/tcp',
        ],
        env              => [
          "MCMEM=${max_ram}",
          "MCUID=${minecraft_uid}",
          "MCGID=${minecraft_gid}",
        ],
        volumes          => $vols,
        memory_limit     => "${max_ram}m", # (format: '<number><unit>', where unit = b, k, m or g)
        dns              => ['8.8.8.8', '8.8.4.4'],
        restart_service  => true,
        pull_on_start    => true,
        extra_parameters => ['--restart=always'],
    }



    duplicity { 'sprout_backup':
        directory         => $world_path,
        dest_id           => $aws_id,
        dest_key          => $aws_key,
        target            => $backup_bucket_path,
        remove_older_than => $backup_retention,
        require           => Package[$cron_service_package],
    }
}
