class prometheus (
   = '2.34.1',
) {
  class { 'apt': }

  package { 'curl': }

  file { '/etc/apt/sources.list.d/prometheus.list':
    ensure  => file,
    content => "deb https://packagecloud.io/prometheus-team/stable/ubuntu/ focal main",
    require => Package['curl'],
  }

  apt::source { 'prometheus':
    location => 'https://packagecloud.io/prometheus-team/stable/ubuntu/',
    release  => 'focal',
    repos    => 'main',
    key      => {
      'id'     => '52E16F86F50A41AB',
      'server' => 'keyserver.ubuntu.com',
    },
    require  => File['/etc/apt/sources.list.d/prometheus.list'],
  }

  package { 'prometheus':
    ensure => ,
  }

  service { 'prometheus':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }
}