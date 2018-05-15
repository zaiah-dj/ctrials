<cfscript>
if ( isDefined( "url.date" ) && StructKeyExists(url, "date") ) {
	date = url.date;
}
else {
	date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
}


//Start on a Sunday
if ( isDefined( "url.startDate" ) && StructKeyExists( url, "startDate" ) ) {
	startDate = url.startDate;
}
else {
	startDate = DateTimeFormat( createDate( 2018, 5, 13 ), "YYYY-MM-DD" );
}
</cfscript>
