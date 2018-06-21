/*
Only process the check-in form data when POST data has been sent by the browser.
*/
<cfscript>
if ( !StructIsEmpty( form ) ) {
	try {
		//A space for error messages, carried throughout this procedure.
		message = "";

		//Regular variables
		sess_id = session.iv_motrpac_transact_id;
		fieldsToCheck = "ps_pid,ps_day,bp_systolic,bp_diastolic";
		bp = ( StructKeyExists( form, "ps_bp" ) ) ? form.ps_bp : 0;
		nt = ( StructKeyExists( form, "ps_notes" ) ) ? form.ps_notes : 0;

		//A lot of this can be cleaned up using the validate() function
		

		//Check for the form fields that are needed and try to insert.
		fields = cf.checkFields( form, "ps_day", "ps_pid", "bp_systolic", "bp_diastolic" );
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
				string="UPDATE #data.data.bloodpressure# 
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
				string="INSERT INTO #data.data.checkin# VALUES (
					 :ps_pid
					,:ps_session_id
					,:ps_week
					,:ps_day
					,:ps_weight
					,:ps_reex_type
					,:datestamp
				)"
			 ,bindArgs = {
				 ps_pid  = form.ps_pid
				,ps_session_id = sess_id	
				,ps_week = sess.current.week
				,ps_day = sess.current.day
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
			if ( ListContains( ENDURANCE, extype ) ) {
				qh = ezdb.exec( 
					string = "UPDATE #data.data.endurance# 
						SET weight = :w 
					WHERE
					participantGUID = :pid
					dayofwk = :dwk
					studywk = :swk"

					,bindArgs = {
						w = form.ps_weight
					 ,pid = form.ps_pid
					 ,dwk = sess.current.day
					 ,swk = sess.current.week
					}
				);
			}
			else if ( ListContains(RESISTANCE, extype) ) {
				qh = ezdb.exec( 
					string = "UPDATE #data.data.resistance# 
						SET weight = :w 
					WHERE
					participantGUID = :pid
					dayofwk = :dwk
					studywk = :swk"

					,bindArgs = {
						w = form.ps_weight
					 ,pid = form.ps_pid
					 ,dwk = sess.current.day
					 ,swk = sess.current.week
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
