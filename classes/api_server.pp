import "pecl.pp"


class api_server 

{
	
import "apache_commands.pp"

# apache2-mpm-prefork will be installed when php5 is installed

$Required_PHP_Packages=["php5","php-apc","php5-mysql","php5-curl","php5-gd"]
$Pecl_Dependency_Packages=["make","apache2-threaded-dev","php5-dev","php-pear"]

package {$Required_PHP_Packages: ensure => installed, }
package {$Pecl_Dependency_Packages: ensure => installed, }

   
 file { "/etc/apache2/sites-enabled":
        
  ensure => directory,   
  recurse => true,
  purge => true,  
  force => true,  
  owner => "root",
  group => "root",
  mode => 0644,
  source => "puppet:///files/api/apache2/sites-enabled",
  require => Package [$Required_PHP_Packages],
  notify => Exec["force-reload-apache2"];
}

file {"/etc/apache2/ports.conf": 
       ensure => present,
       require => Package [$Required_PHP_Packages],
       source => "puppet:///files/api/apache2/ports.conf",
       notify => Exec["reload-apache2"];
     }

 file { "/var/www/":
        
  ensure => directory,   
  recurse => true,
  purge => true,  
  force => true,  
  owner => "root",
  group => "root",
  mode => 0644,
  source => "puppet:///files/api/www",
  
}

 file { "/etc/php5/conf.d/":
        
  ensure => directory,   
  recurse => true,
  # purge => true,  
  force => true,  
  owner => "root",
  group => "root",
  mode => 0644,
  source => "puppet:///files/api/php/conf.d",
  require => Package [$Required_PHP_Packages],
  notify => Exec["reload-apache2"];
}

exec { "restart-apache2":
                command => "/etc/init.d/apache2 restart",
                refreshonly => true,
                before => Service["apache2"],
      }

     
exec { "reload-apache2":
		command => "/etc/init.d/apache2 reload",
		refreshonly => true,
		before => [ Service["apache2"], Exec["force-reload-apache2"] ]
      }

exec { "force-reload-apache2":
		command => "/etc/init.d/apache2 force-reload",
		refreshonly => true,
		before => Service["apache2"],
     }
     
service { apache2:
                ensure => running,
                enable => true,
                require => [File["/etc/php5/conf.d/"],File["/etc/apache2/ports.conf"],File["/etc/apache2/sites-enabled"],File["/var/www/"],Pecl[apc],Package[$Required_PHP_Packages],Package[$Pecl_Dependency_Packages],Apache_module[rewrite]]
        }
        
    
apache_module 
    {rewrite:
	 ensure => present,
	 require => Package [$Required_PHP_Packages],
	}

pecl{apc:
     ensure => present,
     require => Package[$Pecl_Dependency_Packages]
    }
      

}



