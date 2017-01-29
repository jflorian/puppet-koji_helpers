# modules/koji_helpers/manifests/buildroot_dependency.pp
#
# == Define: koji_helpers::buildroot_dependency
#
# Manages a buildroot's dependencies on external package repositories.
#
# If a Koji buildroot has dependencies on external package repositories,
# builds within that buildroot will fail if those external package
# repositories mutate unless Koji's internal repository meta-data is
# regenerated.  This definition allows you to declare such dependencies so
# that such regeneration will be performed automatically, as needed.
#
# === Parameters
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the buildroot dependency instance unless the
#   "buildroot_name" parameter is not set in which case this must provide the
#   value normally set with the "buildroot_name" parameter.
#
# [*ext_repo_urls*]
#   A list of URLs referencing external package repositories upon which this
#   buildroot is dependent.  These entries need not match your package
#   manager's configuration for repositories on a one-to-one basis.  If
#   anything changes in one of these package repositories, the regeneration
#   will be triggered.
#
#   For a hint of what belongs here, consult the output of:
#
#       koji list-external-repos
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*buildroot_name*]
#   This may be used in place of "namevar" if it's beneficial to give namevar
#   an arbitrary value.  If set, this must provide the Koji tag representing
#   the buildroot having external dependencies.
#
# === See Also
#
#   Class[koji_helpers::regen_repos]
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016-2017 John Florian


define koji_helpers::buildroot_dependency (
        Array[String[1]] $arches,
        Array[String[1]] $ext_repo_urls,
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        String[1] $buildroot_name=$title,
    ) {

    include '::koji_helpers::params'

    if $ensure == 'present' {
        concat::fragment { "koji-helper buildroot_dependency ${buildroot_name}":
            target  => $::koji_helpers::params::config,
            content => template('koji_helpers/config-buildroot-dep.erb'),
            order   => '03',
        }
    }

}