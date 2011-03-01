import "classes/db_server.pp"
import "classes/api_server.pp"
import "classes/fe_server.pp"
import "classes/cache_server.pp"



node "fe.example.local"
{
	include fe_server
}



