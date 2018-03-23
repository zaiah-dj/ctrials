<!--- dumply.cfm - Dumps everything. --->
<cfscript>
scopes = { 
	"url" = url, 
	"form" = form, 
	"cgi" = cgi, 
	"session" = session, 
	"variables" = variables 
};

writeoutput( "<div class='inner'>" );
for ( scope in scopes ) {
	writeoutput( "<h2>" & scope & "</h2>" );
	writeoutput( "<table class='debug-table'>" );
	writeoutput( "<thead><th>Key</th><th>Value</th></thead>" );
	for ( x in scopes[ scope ] ) {
		writeoutput( "<tr>" );
		writeoutput( "<td>" & x & "</td>" );
		if ( IsSimpleValue( scopes[ scope ][ x ] ) ) 
			writeoutput( "<td>" & scopes[ scope ][ x ] & "</td>" );
		writeoutput( "</tr>" );
	}
	writeoutput( "</table>" );
}
writeoutput( "</div>" );
</cfscript>

