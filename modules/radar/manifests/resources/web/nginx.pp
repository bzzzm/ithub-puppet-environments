class radar::resources::web::nginx (
) inherits radar::params {

  class { 'nginx': }

  $vhosts = [ 
    'radar.ithub.gov.ro',
    'origin.radar.ithub.gov.ro',
    'cdn.radar.ithub.gov.ro',
  ]

  file { '/var/www':
    ensure => directory,
    owner  => 'nginx',
    group  => 'nginx',
    mode   => '0755',
  }

  $vhosts.each |String $vhost| {
    file { "/var/www/${vhost}":
      ensure  => directory,
      owner   => 'nginx',
      group   => 'nginx',
      mode    => '0755',
      require => File['/var/www'],
    }

    nginx::resource::vhost { "${vhost}":
      www_root => "/var/www/${vhost}",
    }
  }

}
