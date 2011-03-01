
define mysqldb( $user, $password ) {
    exec { "create-${name}-db":
            unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
            command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create database ${name}; grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
            require => Service["mysql"],
         }
  }


define set-mysql-password ( $mysql_password ) {
    
    exec { "${name}":
    unless => "mysqladmin -uroot -p$mysql_password status",
    path => ["/bin", "/usr/bin"],
    command => "mysqladmin -uroot password $mysql_password",
    require => Service["mysql"]
    }
  }


