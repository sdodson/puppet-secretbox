# == Class: secretbox
#
# Full description of class secretbox here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class secretbox (
) inherits secretbox::params {

  # validate parameters here

  class { 'secretbox::install': } ->
  class { 'secretbox::config': } ~>
  class { 'secretbox::service': } ->
  Class['secretbox']
}
