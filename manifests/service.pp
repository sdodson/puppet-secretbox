# == Class secretbox::service
#
# This class is meant to be called from secretbox
# It ensure the service is running
#
class secretbox::service {
  include secretbox::params

  service { $secretbox::params::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
