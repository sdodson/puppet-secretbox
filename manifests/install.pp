# == Class secretbox::intall
#
class secretbox::install {
  include secretbox::params

  package { $secretbox::params::package_name:
    ensure => present,
  }
}
