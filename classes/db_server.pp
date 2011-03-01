

class db_server 

{
    
package { "mysql-server": ensure => installed }



service { "mysql":
    enable => true,
    ensure => running,
    require => Package["mysql-server"]
  }

	$mysql_password="sEcuRe_pa55w0rd"
	
	import "mysql_commands.pp"

    set-mysql-password { "set_root_password":
              mysql_password => $mysql_password,
              
    }

   
  mysqldb { "sample":
              user => "sample_user",
              password => "secure_password",
    }
   
  
}




