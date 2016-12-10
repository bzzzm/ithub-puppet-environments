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

  file { '/etc/nginx/conf.d/realip.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('radar/resources/nginx/realip.conf.erb'),
    notify  => Service['nginx'],
    require => Package['nginx'],
  }
}
