#Create ganglia installation and configuration.

	class ganglia::common {
		package { 'ganglia-gmond':
			ensure => installed,
		}

	}

	define ganglia::config (
			$rackloc = "Unspecified",
			$send_hosts = [ "1.1.1.1" , "1.1.1.2" ]
			) {
		file {
			"/etc/ganglia/gmond.conf":
				content => template("ganglia/gmond.conf.erb"),
			ensure  => present,
			owner   => "root",
			group   => "root",
			mode    => "0644";
		}
 File[ '/etc/ganglia/gmond.conf'] <- Package[ 'ganglia-gmond']
	}

	class ganglia::client inherits ganglia::common {
		service { 'gmond':
			subscribe => File["/etc/ganglia/gmond.conf"],
			ensure => running,
			enable => true,
			hasstatus => true,
			hasrestart => true,
			#require => File["/etc/init.d/gmond"];
		}

	}

	class ganglia::server inherits ganglia::common {
		file {
			"/etc/init.d/gmetad":
				source => "puppet:///modules/ganglia/gmetad",
				       ensure => present,
				       owner  => "root",
				       group  => "root",
				       mode   => "0755";
			"/etc/gmetad.conf":
				source => "puppet:///modules/ganglia/gmetad.conf",
				       ensure => present,
				       owner  => "root",
				       group  => "root",
				       mode   => "0644";
		}
		service {
			"gmetad":
				pattern => "/usr/local/sbin/gmetad",
					ensure  => running,
					require => File["/etc/init.d/gmetad"];
		}
	}
