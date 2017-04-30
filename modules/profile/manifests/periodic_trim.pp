class profile::periodic_trim (
) {
  service {'fstrim.timer':
    enable => true,
  }
}
