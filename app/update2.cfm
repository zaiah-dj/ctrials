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
qu = createObject("component", "components.quella");

//After initial participant selectrion 
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


else if ( form.this eq "endurance" ) 
{
	//check fields
	fields = cc.checkFields( form, 
		"pid", "sess_id","el_ee_equipment",
		"el_ee_timeblock","el_ee_rpm","el_ee_watts_resistance",
		"el_ee_speed","el_ee_grade","el_ee_perceived_exertion" );

	if ( !fields.status )
		sendRequest( status = 0, message = "#fields.message#" );	
	
	//then insert or update if the row is not there...
	upd = qu.exec( 
		string = "SELECT * FROM ac_mtr_exercise_log_ee WHERE el_ee_ex_session_id = :sid AND el_ee_pid = :pid AND el_ee_timeblock = :tb"
	 ,datasource="#data.source#"
   ,bindArgs = { sid="#form.sess_id#", pid="#form.pid#", tb="#form.el_ee_timeblock#" } );

	if ( !upd.status )
		sendRequest( status = 0, message = "#upd.message#" );

	if ( !upd.prefix.recordCount ) {
		upd = qu.exec( 
		  datasource = "#data.source#",
			string = "INSERT INTO ac_mtr_exercise_log_ee VALUES ( :pid,:sid,:eq,:tb,:rpm,:wr,:speed,:grade,:pe,:dt )",
		  bindArgs = {
				sid="#form.sess_id#"
			 ,pid="#form.pid#" 
			 ,"eq"="#form.el_ee_equipment#" 
			 ,tb="#form.el_ee_timeblock#" 
			 ,rpm="#form.el_ee_rpm#" 
			 ,wr="#form.el_ee_watts_resistance#" 
			 ,speed="#form.el_ee_speed#" 
			 ,grade="#form.el_ee_grade#" 
			 ,pe="#form.el_ee_perceived_exertion#" 
			 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			} 
		);
	}
	else {
		upd = qu.exec( 
			string = "UPDATE ac_mtr_exercise_log_ee 
			SET 
				el_ee_equipment = :eq,
				el_ee_timeblock = :tb,
				el_ee_rpm = :rpm,
				el_ee_watts_resistance = :wr,
				el_ee_speed = :speed,
				el_ee_grade = :grade,
				el_ee_perceived_exertion = :pe,
				el_ee_datetime = :dt
			WHERE
				el_ee_ex_session_id = :sid 
			AND
				el_ee_timeblock = :tb
			AND
				el_ee_pid = :pid",
		  datasource = "#data.source#",
		  bindArgs = { 
				sid = "#form.sess_id#",
			  pid = "#form.pid#" ,
			  "eq" = "#form.el_ee_equipment#" ,
			  tb = "#form.el_ee_timeblock#" ,
			  rpm = "#form.el_ee_rpm#" ,
			  wr = "#form.el_ee_watts_resistance#" ,
			  speed = "#form.el_ee_speed#" ,
			  grade = "#form.el_ee_grade#" ,
			  pe = "#form.el_ee_perceived_exertion#" ,
			  dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
			}
		);	
	}

	sendRequest( status = 1, message = "#upd.message#" );	

/*
	w = CreateObject( "component", "components.writeback" );
	w.Server( 
		listen = "form"
		,ds    = "#data.source#"
		,table = "ac_mtr_exercise_log_ee"
		,using = "SQLServer"
	  ,insertOn = '!checkFor( where = "el_ee_ex_session_id = :sid AND el_ee_pid = :pid", predicate = { sid="#form.sess_id#", pid="#form.pid#" } )'
		,where = {
			clause= "el_ee_ex_session_id = :sid",
			predicate= { sid = "#form.sess_id#" }}
		,only  = [ 
			"pid",
			"sess_id",
			"el_ee_equipment",
			"el_ee_timeblock",
			"el_ee_rpm",
			"el_ee_watts_resistance",
			"el_ee_speed",
			"el_ee_grade",
			"el_ee_perceived_exertion",
			"el_ee_datetime"
		]
	);

	writeoutput( "#w#" );
*/
	abort;
	
}



//We got here...
sendRequest( status = 1, message = "Successfully wrote to #data.source#" );
</cfscript>
