import "apache_commands.pp"


define pecl ( $ensure = 'present')

{
        case $ensure

        {
                'present' : {
                        exec { "/bin/echo -e \"no \\n\" |/usr/bin/pecl install $name":
                                unless => "/bin/sh -c '[ $(/usr/bin/pecl list | /bin/grep -i $name | /usr/bin/wc -l) -eq 1 ]'",
                                notify => Exec["reload-apache2"];
                              }
                            }


                'absent':  {
                        exec { "/usr/bin/pecl uninstall $name":
                                onlyif => "/bin/sh -c '[ $(/usr/bin/pecl list | /bin/grep -i $name | /usr/bin/wc -l) -eq 1 ]'",
                                notify => Exec["reload-apache2"];
                             }
                           }

                default: { err ( "Unknown ensure value: '$ensure'" ) }

        }
}











