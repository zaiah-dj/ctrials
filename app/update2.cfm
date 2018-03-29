<cffunction name="sendRequest">
	<cfargument name="status">
	<cfargument name="message">
	<cfcontent type="application/json">
	<cfoutput>{ "status": #arguments.status#, "message": "#arguments.message#" }</cfoutput>  
	</cfcontent>
	<cfabort>
</cffunction>

<cfscript>
/* ----------------------- *
update.cfm
----------

Will try keeping all the update code here.  
It's much easier to do that with the write back module.

Deserialize JSON and store values in the proper places...

Values received here will be saved to one of the following tables.

*ac_mtr_dlog          - Log of exercises done.
*ac_mtr_exercise_log  - Log of current participants exercise progress.
*ac_mtr_patientstatus - Log of patient's current health (track per day?).

 ------------------------- */

//Block any requests that are not POST
if ( !isDefined( "form" ) || StructIsEmpty( form ) )
	sendRequest( status = 0, message = "This resource does not currently answer to request types other than POST." );


//This is (right now) how I'm going about using the same page for all AJAX updates.
if ( !StructKeyExists( form, "this" ) )
	sendRequest( status = 0, message = "Bad request (missing key 'this')" );

//...
cc = createObject("component", "components.checkFields");

//
if ( form.this eq "startSession" ) {
	exist = cc.checkFields( form, "transact_id", 	"staffer_id", "list" );
	if ( !exist.status ) {
		sendRequest( status = 0, message = "#exist.message# - Either 'transact_id', 'staffer_id' or 'list' fields are missing from request)" );
	}

	try {
		//TODO: there surely must be an easier way
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
	}
	catch (any e) {
		sendRequest( status=0, message="#e.message# - #data.source# - #e.detail#" );
	}
}


//We got here...
sendRequest( status = 1, message = "Successfully wrote to #data.source#" );
</cfscript>
