<cfscript>
if ( !StructIsEmpty( form ) ) {
	try {
		//Regular variables
		message = "";
		sess_id = session.iv_motrpac_transact_id;
		fieldsToCheck = "ps_pid,ps_day,ps_next_sched,bp_systolic,bp_diastolic";
		bp = ( StructKeyExists( form, "ps_bp" ) ) ? form.ps_bp : 0;
		nt = ( StructKeyExists( form, "ps_notes" ) ) ? form.ps_notes : 0;

		//Check for the form fields that are needed and try to insert.
		fields = cf.checkFields( form, "ps_day", "ps_pid", "ps_next_sched", "bp_systolic", "bp_diastolic" );
		if ( !fields.status ) {
			message = fields.message;
			writeoutput( message );
			abort;
		}
		else {
			//Check for any blank fields
			for ( n in ListToArray( fieldsToCheck ) ) {
				if ( StructFind( form, n ) eq "" ) { 
					message = "Field #n# cannot be blank.";
					writeoutput( message );
					abort;
					//break;
				}
			}

			//Add a row to the blood pressure table.
			ezdb.setDs( "#data.source#" );
			bpi = ezdb.exec(
				string="UPDATE ac_mtr_bloodpressure 
					SET 
						bp_systolic = :systolic
					 ,bp_diastolic = :diastolic
					 ,bp_daterecorded = :recorddate
					WHERE 
						bp_pid = :id"
				,bindArgs={ 
					 id        = form.ps_pid
					,systolic  = form.bp_systolic
					,diastolic = form.bp_diastolic
					,recorddate= { value=DateTimeFormat( Now(), "YYYY-MM-DD" ),type="cfsqldatetime" }
				});

			//Add a row to the check in status table
			qr = ezdb.exec( 
				string="INSERT INTO ac_mtr_checkinstatus VALUES (
					 :ps_pid
					,:ps_session_id
					,:ps_week
					,:ps_day
					,:ps_next_sched
					,:ps_weight
					,:ps_reex_type
					,:datestamp
				)"
			 ,bindArgs = {
				 ps_pid  = form.ps_pid
				,ps_session_id = sess_id	
				,ps_week = currentWeek
				,ps_day = currentDay
				,ps_next_sched = { value=DateTimeFormat( form.ps_next_sched, "YYYY-MM-DD" ),type="cfsqldatetime" }
				,ps_weight = form.ps_weight
				,ps_reex_type = (StructKeyExists( form, "exset" )) ? form.exset : 0
				,datestamp = {value=DateTimeFormat( Now(), "YYYY-MM-DD" ),type="cfsqldatetime"} 
			});

			//Exercise type
		 	extype = ezdb.exec( 
				string = "SELECT randomGroupCode FROM 
					#data.data.participants# WHERE participantGUID = :pid"
		   ,bindArgs = { pid = form.ps_pid }
			).results.randomGroupCode;

			//Update the proper table with weight info
			if ( extype eq ENDURANCE ) {
				qh = ezdb.exec( 
					string = "UPDATE ac_mtr_endurance_new 
						SET weight = :w 
					WHERE
					participantGUID = :pid
					dayofwk = :dwk
					studywk = :swk"

					,bindArgs = {
						w = form.ps_weight
					 ,pid = form.ps_pid
					 ,dwk = currentDay
					 ,swk = currentWeek
					}
				);
			}
			else if ( extype eq RESISTANCE ) {
				qh = ezdb.exec( 
					string = "UPDATE ac_mtr_resistance_new 
						SET weight = :w 
					WHERE
					participantGUID = :pid
					dayofwk = :dwk
					studywk = :swk"

					,bindArgs = {
						w = form.ps_weight
					 ,pid = form.ps_pid
					 ,dwk = currentDay
					 ,swk = currentWeek
					}
				);
			}

			//Check the queries and see if they failed
			message = qr.message;
		}
	}
	catch (any e) {
		writeoutput( "process_checkin_form.cfm" );
		writeoutput( e.message );
		abort;
	}

	//Get the form part id, and redirect to end or res based on that	
	location( url="input.cfm?id=#form.ps_pid#", addtoken="no" ); 
}
</cfscript>
