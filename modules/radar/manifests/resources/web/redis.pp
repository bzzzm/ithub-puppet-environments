class radar::resources::web::redis (
) inherits radar::params {

  class { 'redis':
    bind        => $::ipaddress,
    #masterauth =>  'secret',
  }

  class { 'redis::sentinel':
    master_name => 'radar-web01',
    redis_host  => $::ipaddress,
    failover_timeout => 30000,
  } 

}
