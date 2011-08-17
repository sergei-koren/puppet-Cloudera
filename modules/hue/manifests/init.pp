class hue::plugins {
	package{"hue-plugins":
	name => "hue-plugins",
	ensure => installed,

}

}
class hue::server {

$mysql_driver_version="5.1.14"
	package{"hue":
	name =>"hue",
	ensure=>installed,
}
        file {"hue.ini":
	        mode=>755,
        	path=>"/etc/hue/hue.ini",
        	content=>template("hue/hue.ini.erb"),
        	require =>Package["hue"],
        }
        file {"hue-beeswax.ini":
                mode=>755,
                path=>"/etc/hue/hue-beeswax.ini",
                content=>template("hue/hue-beeswax.ini.erb"),
                require =>Package["hue"],
        }




}
