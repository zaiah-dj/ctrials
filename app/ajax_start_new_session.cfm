<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "startSession" ) 
{
	errmsg = "";
	try {
		exist = cf.checkFields( form, "transact_id", 	"staffer_id", "list" );
		if ( !exist.status ) {
			req.sendAsJson( 
				status = 0, 
				message = "START SESSION AFTER PARTICIPANT DROP - #exist.message# - "
								& "Either 'transact_id', 'staffer_id' or 'list' fields are missing from request)" 
			);
		}

		//TODO: there surely must be an easier way
		errmsg = "FAILED TO ADD TRANSACTION MEMBERS - ";
		todayDom = DateTimeFormat( Now(), "d" );
		todayDay = LCase( DateTimeFormat( Now(), "EEE" ) );
		switch ( todayDay ) {
			case "mon":
				todayDay = 1; break;
			case "tue":
				todayDay = 2; break;
			case "wed":
				todayDay = 3; break;
			case "thu":
				todayDay = 4; break;
			case "fri":
				todayDay = 5; break;
			case "sat":
				todayDay = 6; break;
			case "sun":
				todayDay = 7; break;
		}	
		
		for ( listing in ListToArray( form.list )) {	
			stmt = "INSERT INTO ac_mtr_participant_transaction_members VALUES ( :mid, :dom, :day, :listing )";
			nq = new Query( );
			nq.setDatasource( "#data.source#" );
			nq.addParam( name = "mid", value=form.transact_id, cfsqltype="cf_sql_nvarchar" );
			nq.addParam( name = "dom", value=todayDom, cfsqltype="cf_sql_int" );
			nq.addParam( name = "day", value=todayDay, cfsqltype="cf_sql_int" );
			nq.addParam( name = "listing", value=listing, cfsqltype="cf_sql_int" );
			r = nq.execute( sql = stmt );
		}

		if ( form.this eq "macDebugStartSession" ) {
			location( url=link( "chosen.cfm" ), addtoken="no" );
		}
	}
	catch (any e) {
		req.sendAsJson( 
			status = 0, 
			message= errmsg & "#e.message# - #data.source# - #e.detail#"
		);
	}

	req.sendAsJson( 
		status = 1, 
		message = "Successfully began new participant session "
					  & "with datasource: #data.source#." 
	);
	abort;
}
//req.sendAsJson( status = 1, message = "You shouldn't have gotten here." );	abort;
</cfscript>
