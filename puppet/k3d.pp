class { 'k3d':
  version => '5.4.0',
}

k3d_cluster { 'mycluster':
  servers   => 1,
  agents    => 1,
  wait_for_servers => true,
}

k3d_registry { 'my-registry':
  cluster => 'mycluster',
}

k3d_image { 'prom/prometheus':
  cluster => 'mycluster',
  registry => 'my-registry',
  pull => true,
}

k3d_service { 'prometheus-server':
  cluster => 'mycluster',
  image => 'my-registry:prom/prometheus',
  ports => [
    '443:443',
    '9090:9090',
  ],
  env => [
    'prometheus.yml=/etc/prometheus/prometheus.yml',
  ],
  volumes => [
    'prometheus-config:/etc/prometheus',
    'prometheus-data:/data',
  ],
  wait_for_condition => 'ready',
}

file { ['/etc/prometheus/prometheus.yml', '/etc/prometheus/rules/']:
  ensure => directory,
  owner => 'root',
  group => 'root',
  mode => '0755',
}

file { '/etc/prometheus/prometheus.yml':
  content => template('prometheus/prometheus.yml'),
  notify => Service['prometheus-server'],
}

file { '/etc/prometheus/rules/example.rules':
  content => template('prometheus/example.rules'),
  notify => Service['prometheus-server'],
}

template { 'prometheus/prometheus.yml':
  source => 'puppet:///modules/prometheus/prometheus.yml',
  owner => 'root',
  group => 'root',
  mode => '0644',
}

template { 'prometheus/example.rules':
  source => 'puppet:///modules/prometheus/example.rules',
  owner => 'root',
  group => 'root',
  mode => '0644',
}