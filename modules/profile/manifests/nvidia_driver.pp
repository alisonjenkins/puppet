class profile::nvidia_driver(
  Array $packages = [
    'nvidia-dkms',
    'nvidia-settings',
    'nvidia-utils',
  ]
) {

  ensure_packages($packages, {'ensure' => 'present'})

}
