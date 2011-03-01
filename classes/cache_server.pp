class cache_server 

{
	
package { varnish: ensure => installed, }


exec { "restart-varnish":
		command => "/etc/init.d/varnish restart",
		refreshonly => true,
		before => Service["varnish"],
     }

file {"/etc/default/varnish": 
       ensure => present,
       require => Package [varnish],
       source => "puppet:///files/cache/default/varnish",
       notify => Exec["restart-varnish"];
     }
	

file {"/etc/varnish/default.vcl": 
       ensure => present,
       require => Package [varnish],
       source => "puppet:///files/cache/default.vcl",
       notify => Exec["restart-varnish"];
     }

	
service { varnish:
                ensure => running,
                enable => true,
                require => [ [Package[varnish]], File["/etc/varnish/default.vcl"], File["/etc/default/varnish"]]
	}

}
