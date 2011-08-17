# /etc/puppet/modules/zookeeper/manifests/init.pp

class zookeeper::common {

    package { "hadoop-zookeeper": 
	ensure => installed,
}

    file { "zoo.cfg":
	path	=> "/etc/zookeeper/zoo.cfg",
        owner   => root,
        group   => root,
        content  => template("zookeeper/zoo.cfg.erb"),
        require => Package["hadoop-zookeeper"],
    }

   file { "zookeeper_configuration.xsl":
        path    => "/etc/zookeeper/configuration.xsl",
        owner   => root,
        group   => root,
        source  => "puppet:///zookeeper/configuration.xsl",
        require => Package["hadoop-zookeeper"],
    }

   file { "zookeeper_log4j.properties":
        path    => "/etc/zookeeper/log4j.properties",
        owner   => root,
        group   => root,
        source  => "puppet:///zookeeper/log4j.properties",
        require => Package["hadoop-zookeeper"],
    }




}
class zookeeper::server inherits zookeeper::common{
	package {"hadoop-zookeeper-server":
	ensure => installed,
	}

	service {"hadoop-zookeeper":
		name => "hadoop-zookeeper",
	        ensure => running,
	        hasstatus => true,
		hasrestart => true,
		subscribe => File["zoo.cfg"],

	
	}
	file {"zookeeper_server_id":
	path=> "/var/zookeeper/myid",
	content => template("zookeeper/myid.erb"), 
	}
}

