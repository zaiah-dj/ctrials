<cffunction name="sendRequest">
	<cfargument name="status">
	<cfargument name="message">

	<cfset aa = CreateObject("component", "components.requestLogger" )
		.init(table = "ac_mtr_serverlog", ds="#data.source#")
		.append(message = "#arguments.message#")>

	<cfcontent type="application/json">
		<cfoutput>{ "status": #arguments.status#, "message": "#arguments.message#" }</cfoutput>  
	</cfcontent>
	<cfabort>

</cffunction>

<!---
<cfset aa = CreateObject("component", "components.requestLogger" )
	.init(table = "ac_mtr_serverlog", ds="#data.source#").append()>
	--->

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

* ------------------------- */

//Block any requests that are not POST
if ( !isDefined( "form" ) || StructIsEmpty( form ) )
	sendRequest( status = 0, message = "This resource does not currently answer to request types other than POST." );

//This is (right now) how I'm going about using the same page for all AJAX updates.
if ( !StructKeyExists( form, "this" ) )
	sendRequest( status = 0, message = "Bad request (missing key 'this')" );

//...
cc = createObject("component", "components.checkFields");
qu = createObject("component", "components.quella");
ck = createObject("component", "components.quella");

try {
	if ( StructKeyExists( form, "sess_id" ) ) 
	{
		//Check the thing
		ckr = ck.exec( 
			bindArgs = { sid=form.sess_id },
			datasource="#data.source#",
			string = "SELECT TOP 1 * FROM 
			ac_mtr_logging_progress_tracker WHERE session_id = :sid" );

		//If no records exist...
		if ( !ckr.prefix.recordCount ) 
		{
			//I insert a dummy record here because I'm going to update to change my tracker...
			insertStmt = "
			INSERT INTO
				ac_mtr_logging_progress_tracker 
			VALUES ( 
				 :aid
  			,:sid
				,:ee_rpm
				,:ee_watts_resistance, :ee_speed
				,:ee_grade, :ee_perceived_exertion
				,:ee_equipment, :ee_timeblock
				,:re_reps1
				,:re_weight1
				,:re_reps2
				,:re_weight2
				,:re_reps3
				,:re_weight3
				,:re_extype
				,:dt
			)"
			;

			ck.exec( 
			 datasource="#data.source#"
			,string = insertStmt
			,bindArgs = {
				 aid=0
				,sid=0
				,ee_rpm=0
				,ee_watts_resistance=0
				,ee_speed=0
				,ee_grade=0
				,ee_perceived_exertion=0
				,ee_equipment=0
				,ee_timeblock=0
				,re_reps1=0
				,re_weight1=0
				,re_reps2=0
				,re_weight2=0
				,re_reps3=0
				,re_weight3=0
				,re_extype=0
				,dt={value=DateTimeFormat(Now(),"YYYY-MM-DD HH:nn:ss"),type="cf_sql_datetime"}
				}
			);
		}
	}
}
catch (any e) {
	sendRequest( status = 0, message = "#e.message# - #e.detail#" );	
	abort;
}

//After initial participant selectrion 
if ( form.this eq "startSession" ) {
	exist = cc.checkFields( form, "transact_id", 	"staffer_id", "list" );
	if ( !exist.status ) {
		sendRequest( status = 0, message = "START SESSION AFTER PARTICIPANT DROP - #exist.message# - Either 'transact_id', 'staffer_id' or 'list' fields are missing from request)" );
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
		sendRequest( 
			status=0, 
			message="FAILED TO ADD TRANSACTION MEMBERS - " & 
				"#e.message# - #data.source# - #e.detail#" 
		);
	}
}
else if ( form.this eq "resistance" ) 
{
	try {
		//Define a progress statement
		progressStmt =
		"UPDATE 
			ac_mtr_logging_progress_tracker 
		SET 
			re_reps1 = :re_reps1,
			re_weight1 = :re_weight1,
			re_reps2 = :re_reps2,
			re_weight2 = :re_weight2,
			re_reps3 = :re_reps3,
			re_weight3 = :re_weight3,
			re_extype = :re_extype 
		WHERE 
			active_pid = :aid AND session_id = :sid"
		;

		//check fields
		fields = cc.checkFields( form, 
			"pid", "sess_id",
			"el_re_reps1", "el_re_weight1",
			"el_re_reps2", "el_re_weight2",
			"el_re_reps3", "el_re_weight3",
			"el_re_extype" );

		if ( !fields.status )
			sendRequest( status = 0, message = "#fields.message#" );	
		
		//then insert or update if the row is not there...
		upd = qu.exec( 
			string = "SELECT * FROM ac_mtr_exercise_log_re WHERE el_re_ex_session_id = :sid AND el_re_pid = :pid AND el_re_extype = :extype",
		  datasource="#data.source#",
		  bindArgs = { sid="#form.sess_id#", pid="#form.pid#", extype="#form.el_re_extype#" } 
		);

		if ( !upd.status )
			sendRequest( status = 0, message = "#upd.message#" );

		if ( !upd.prefix.recordCount ) {
			upd = qu.exec( 
				datasource = "#data.source#",
				string = "INSERT INTO ac_mtr_exercise_log_re VALUES
					( :pid,:sid,:r1,:w1,:r2,:w2,:r3,:w3,:extype, :dt, :mdt );",
				bindArgs = {
					pid="#form.pid#" 
				 ,sid="#form.sess_id#"

				 ,r1="#form.el_re_reps1#" 
				 ,w1="#form.el_re_weight1#" 
				 ,r2="#form.el_re_reps2#" 
				 ,w2="#form.el_re_weight2#" 
				 ,r3="#form.el_re_reps3#" 
				 ,w3="#form.el_re_weight3#" 

				 ,extype="#form.el_re_extype#" 
				 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
				 ,mdt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
				} 
			);
		}
		else {
			upd = qu.exec( 
				string = "UPDATE ac_mtr_exercise_log_re 
				SET 
					el_re_reps1 = :r1,
					el_re_weight1 = :w1,
					el_re_reps2 = :r2,
					el_re_weight2 = :w2,
					el_re_reps3 = :r3,
					el_re_weight3 = :w3,
					el_re_extype = :extype,
					el_re_datetime_modified = :dt
				WHERE
					el_re_ex_session_id = :sid 
				AND
					el_re_extype = :extype
				AND
					el_re_pid = :pid",

				datasource = "#data.source#",

				bindArgs = {
					pid="#form.pid#" 
				 ,sid="#form.sess_id#"

				 ,r1="#form.el_re_reps1#" 
				 ,w1="#form.el_re_weight1#" 
				 ,r2="#form.el_re_reps2#" 
				 ,w2="#form.el_re_weight2#" 
				 ,r3="#form.el_re_reps3#" 
				 ,w3="#form.el_re_weight3#" 

				 ,extype="#form.el_re_extype#" 
				 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
				}
			);	
		}

		//Progress tracking
		qu.exec( 
			string = progressStmt
		 ,datasource = "#data.source#"
		 ,bindArgs = {
				aid = form.pid
			 ,sid = form.sess_id
			 ,re_reps1 = form.el_re_reps1
			 ,re_weight1 = form.el_re_weight1
			 ,re_reps2 = form.el_re_reps2
			 ,re_weight2 = form.el_re_weight2
			 ,re_reps3 = form.el_re_reps3
			 ,re_weight3 = form.el_re_weight3
			}
		);
	}
	catch (any e) {
		sendRequest( status = 0, message = "#e.message# - #e.detail#" );
	}

	sendRequest( status = 1, message = "#upd.message#" );	
	abort;
}
else if ( form.this eq "endurance" ) 
{
	try {
		//Define a progress statement
		progressStmt =
		"UPDATE 
			ac_mtr_logging_progress_tracker 
		SET 
			 ee_rpm = :ee_rpm 
			,ee_speed = :ee_speed 
			,ee_grade = :ee_grade 
			,ee_perceived_exertion = :ee_perceived_exertion 
			,ee_equipment = :ee_equipment
			,ee_watts_resistance = :ee_watts_resistance
		WHERE 
			active_pid = :aid AND session_id = :sid"
		;
	
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
				string = "INSERT INTO ac_mtr_exercise_log_ee VALUES 
					( :pid,:sid,:eq,:tb,:rpm,:wr,:speed,:grade,:pe,:dt,:mdt )",
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
				 ,mdt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
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
					el_ee_datetime_modified = :dt
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

		//Also save progress (but the thing needs to be checked)
		qu.exec(
			string = progressStmt
		 ,datasource = "#data.source#"
		 ,bindArgs = {
				aid = form.pid
			 ,sid = form.sess_id
			 ,ee_rpm = form.el_ee_rpm
			 ,ee_watts_resistance = form.el_ee_watts_resistance
			 ,ee_speed = form.el_ee_speed
			 ,ee_grade = form.el_ee_grade
			 ,ee_perceived_exertion = form.el_ee_perceived_exertion
			 ,ee_equipment = form.el_ee_equipment
		 }
		);
		
	}
	catch (any e) {
		sendRequest( status = 0, message = "#e.message# - #e.detail#" );	
	}
	sendRequest( status = 1, message = "#upd.message#" );	
	abort;
}

//We got here...
sendRequest( status = 1, message = "Successfully began new participant session with datasource: #data.source#." );
</cfscript>
