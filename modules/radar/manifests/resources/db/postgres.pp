class radar::resources::db::postgres (
) inherits radar::params {

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => '9.2',
  } -> class { 'postgresql::server':
    ip_mask_deny_postgres_user  => '0.0.0.0/0',
    ip_mask_allow_all_users     => '192.168.0.0/16',
    listen_addresses            => '*',
    ipv4acls                    => ['host all all 192.168.0.0/16 md5'],
    postgres_password           => 'password',
  }

  include postgresql::server::postgis

}
