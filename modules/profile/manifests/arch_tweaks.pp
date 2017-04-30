class profile::arch_tweaks(
) {
  file_line { 'configure parallel package compression':
    path  => '/etc/makepkg.conf',
    line  => 'COMPRESSXZ=(xz -c -z - --threads=0)',
    match => '^COMPRESSXZ=',
  }

  file_line { 'set C compiler flags':
    path  => '/etc/makepkg.conf',
    line  => 'CFLAGS="-march=native -O2 -pipe -fstack-protector-strong"',
    match => '^CFLAGS=',
  }

  file_line { 'set C++ compiler flags':
    path  => '/etc/makepkg.conf',
    line  => 'CXXFLAGS="${CFLAGS}"',
    match => '^CXXFLAGS=',
  }

  file_line { 'set makepkg options':
    path  => '/etc/makepkg.conf',
    line  => 'OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !optipng !upx !debug)',
    match => '^OPTIONS='
  }

  file_line { 'set makepkg buildenv':
    path  => '/etc/makepkg.conf',
    line  => 'BUILDENV=(!distcc color ccache check !sign)',
    match => '^BUILDENV='
  }
}
