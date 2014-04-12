include apt

Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

class update {
	exec { 'apt-get update':
		command => 'apt-get update'
	}

	exec { "apt-get upgrade":
        command => "apt-get upgrade -y",
        require => Exec['apt-get update']
    }
}

class node-less {
	 include apt::backports

	apt::source { 'debian_backports':
		location => 'http://ftp.lt.debian.org/debian',
		release => 'wheezy-backports',
		repos => 'main',
		include_src => false,
	}
	
	package { 'node-less':
		ensure => present,
		require => apt::source['debian_backports']
	}
}

class system-packages {
	$packages = [ "vim", "curl", "git", "memcached"]

	package { $packages:
		ensure => present,
		require => Exec['apt-get upgrade']
	}
}

class dev-packages {
	
	$apache = ["apache2"]
	$php = ["php5", "libapache2-mod-php5", "php5-mysql", "php5-mcrypt", "php5-gd", "php5-imagick", "php5-curl", "php-apc", "php5-intl", "php5-memcached"]

	package { $apache:
		ensure => present
	}

	package { $php:
		ensure => present,
		require => Package[$apache]
	}

	service { "apache2":
		ensure => running,
		require => Package[$apache]
	}

	file { "/var/www":
	    ensure => link,
		target => "/vagrant/www/web",
		notify => Service["apache2"],
		force  => true,
		require => Service["apache2"]
  	}
}

include update
include system-packages
include dev-packages
include node-less
