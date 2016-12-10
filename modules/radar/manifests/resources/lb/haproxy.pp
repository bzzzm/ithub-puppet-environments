class radar::resources::lb::haproxy (
) inherits radar::params {

  class { 'haproxy':
    global_options   => {
      'log'     => "${::ipaddress} local0",
      'chroot'  => '/var/lib/haproxy',
      'pidfile' => '/var/run/haproxy.pid',
      'maxconn' => '4000',
      'user'    => 'haproxy',
      'group'   => 'haproxy',
      'daemon'  => '',
      'stats'   => 'socket /var/lib/haproxy/stats',
    },
    defaults_options => {
      'log'     => 'global',
      'stats'   => 'enable',
      'option'  => [
        'redispatch',
      ],
      'retries' => '3',
      'timeout' => [
        'http-request 10s',
        'queue 1m',
        'connect 10s',
        'client 1m',
        'server 1m',
        'check 10s',
      ],
      'maxconn' => '8000',
    },
  }

  haproxy::listen { 'radarweb':
    ipaddress => $::ipaddress,
    ports     => '80',
    mode      => 'http',
    options   => {
      'option'  => [
        'tcplog',
      ],
      'http-request' => [
        'set-header X-Client-IP %[src]',
      ],
      'balance' => 'roundrobin',
    },
  }

  haproxy::balancermember { 'haproxy':
    listening_service => 'radarweb',
    ports             => '80',
    server_names      => [
      'radar-web01',
      'radar-web02'
    ],
    ipaddresses       => [
      '192.168.11.14',
      '192.168.11.15'
    ],
    options           => 'check',
  }
}
