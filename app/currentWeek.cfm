<cfscript>
if ( isDefined( "url.date" ) && StructKeyExists(url, "date") ) {
	date = url.date;
}
else {
	date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
}
</cfscript>
