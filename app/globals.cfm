<!--- 
globals.cfm

Here is another ugly configuration file for when I need to change things.
This is only good for debugging and will allow you to change datasources and more through URL variables.

An example looks something like this:

//Supposing I want to change the startWeek of the study for a particular user:
www.motrpac.com/motrpac/web/secure/dataentry/intervention-tracking/?startweek=2018-09-10
  --->
<cfscript>
//writedump( cgi );abort;

vars = [
//This is here to make life easy
 { key="______", set=0 }

//Set users list if for some reason JS is broken and dragging does not work.
,{ key="userlist", set=0 }
	
//Set a different start date
,{ key="startDate", set=0 }

//Set a different date
,{ key="date", set=0 }

//Set a different refresh time for cookies
,{ key="cookieRefreshTime", set=0 }

//Set a different expire time for cookies 
,{ key="cookieExpireTime", set=0 }

//Set a different exercise type 
,{ key="uextype", set="extype" }

//Set a different user ID (via number) 
,{ key="nid", set="currentId" }

//Set a different user ID (via PID) 
,{ key="pid", set="currentId" }

//Set a different site ID versus what came through the session variables
,{ key="siteid", set="currentId" }

//Set a different datasource for testing
,{ key="datasource", set="data.source" }
];

//Loop through all of the above and set global variable to that
for ( t in vars ) {
	if ( StructKeyExists( url, t.key ) ) {
		variables[ t.set ] = url[ t.key ];
	}
}

//
</cfscript>
