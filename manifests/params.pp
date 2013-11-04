# == Class secretbox::params
#
# This class is meant to be called from secretbox
# It sets variables according to platform
#
class secretbox::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'secretbox'
      $service_name = 'secretbox'
    }
    'RedHat', 'Amazon': {
      $package_name = 'secretbox'
      $service_name = 'secretbox'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
