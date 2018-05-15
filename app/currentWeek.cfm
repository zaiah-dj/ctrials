<cfscript>
//Always start new weeks on Sunday
if ( isDefined( "url.startDate" ) && StructKeyExists( url, "startDate" ) ) {
	startDate = url.startDate;
}
else {
	startDate = DateTimeFormat( createDate( 2018, 5, 13 ), "YYYY-MM-DD" );
}

//Current date
if ( isDefined( "url.date" ) && StructKeyExists(url, "date") ) {
	try {
		date = DateTimeFormat( url.date, "YYYY-MM-DD HH:nn:ss" );

		if ( DateDiff( "ww", startDate, date ) < 0 ) {
			date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
		}	
	}
	catch (any e) {
		date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
	}
}
else {
	date = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
}

//Current Week should also be carried through the whole app.
currentWeek = DateDiff( "ww", startDate, date ) + 1;

</cfscript>
