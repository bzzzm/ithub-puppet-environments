class radar::resources::web::nginx (
) inherits radar::params {

  class { 'nginx': }

  $vhosts = [ 
    'radar.ithub.gov.ro',
    'origin.radar.ithub.gov.ro',
    'cdn.radar.ithub.gov.ro',
  ]

  $vhosts.each |String $vhost| {
    nginx::resource::vhost { "${vhost}":
      www_root => "/var/www/${vhost}",
    }
  }

}
