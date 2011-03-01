import "classes/db_server.pp"
import "classes/api_server.pp"
import "classes/fe_server.pp"
import "classes/cache_server.pp"


class fe2 inherits fe_server
{

}


node "sq-fe2.quickerala.com"
{
	include fe_server
}

node "sq-api2.quickerala.com"
{
	include api_server
}

node "sq-cache2.quickerala.com"
{
	include cache_server
}

node "puppet-client-testing.quickerala.com" 
{ 
	#include api_server
	#include db_server
	include fe_server
	#include cache_server
}


