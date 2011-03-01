     
define apache_module ( $ensure = 'present') {
  	case $ensure {
  		'present' : {
  			exec { "/usr/sbin/a2enmod $name":
  				unless => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ] && [ /etc/apache2/mods-enabled/${name}.load -ef /etc/apache2/mods-available/${name}.load ]'", 
  				notify => Exec["force-reload-apache2"],
  			}
  		}
  		'absent': {
  			exec { "/usr/sbin/a2dismod $name":
  				onlyif => "/bin/sh -c '[ -L /etc/apache2/mods-enabled/${name}.load ] && [ /etc/apache2/mods-enabled/${name}.load -ef /etc/apache2/mods-available/${name}.load ]'",
  				notify => Exec["force-reload-apache2"],
  			}
  		}
  		default: { err ( "Unknown ensure value: '$ensure'" ) }
  	}
  }
