<cfscript>
//Display a message upon redirection
function errAndRedirect( msg ) {
	//clearly, this is not a good way to handle this...
	writeoutput( msg );
	abort;
}

if ( !StructIsEmpty( form ) ) {
	try {
		//A lot of this can be cleaned up using the validate() function
		stat = val.validate( form, {
			ps_day = { req = true }
		 ,ps_pid = { req = true }
		 ,ps_weight = { req = true }
		 ,param = { req = true }
		 ,ps_next_sched = { req = false , ifNone = 0 }
		 ,bp_systolic = { req = false, ifNone = 0 }
		 ,bp_diastolic = { req = false, ifNone = 0 }
		} );

		if ( !stat.status ) {
			errAndRedirect( "form values were expected and not there: #SerializeJSON(stat)#" );
		}

		fv = stat.results;
		
		//Add a row to the blood pressure table. (if required)
		if ( 0 ) {
			bpi = ezdb.exec(
				string="UPDATE #data.data.bloodpressure# 
					SET 
						bp_systolic = :systolic
					 ,bp_diastolic = :diastolic
					 ,bp_daterecorded = :recorddate
					WHERE 
						bp_pid = :id"
				,bindArgs={ 
					 id        = fv.ps_pid
					,systolic  = fv.bp_systolic
					,diastolic = fv.bp_diastolic
					,recorddate= { value=DateTimeFormat( Now(), "YYYY-MM-DD" ),type="cfsqldatetime" }
				});

			if ( !bpi.status ) {
				errAndRedirect( "Error at process_checkin_form.cfm: #SerializeJSON(bpi)#" );	
			}
		}

		//Add a row to the check in status table
		qr = ezdb.exec( 
			string="INSERT INTO #data.data.checkin# VALUES (
				 :ps_pid
				,:ps_session_id
				,:ps_week
				,:ps_day
				,:ps_nextSched
				,:ps_weight
				,:extype
				,:datestamp
			)"
		 ,bindArgs = {
			 ps_pid  = fv.ps_pid
			,ps_session_id = sess.current.sessId
			,ps_week = sess.current.week
			,ps_day = sess.current.day
			,ps_nextSched = fv.ps_next_sched
			,ps_weight = fv.ps_weight
			,extype = fv.param
			,datestamp = {value=DateTimeFormat( Now(), "YYYY-MM-DD" ),type="cfsqldatetime"} 
		});

		if ( !qr.status ) { 
			errAndRedirect( "Error at process_checkin_form.cfm (102): #SerializeJSON(qr)#" );
		}

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
					SET weight = :wt 
				WHERE
					participantGUID = :pid
				AND
					dayofwk = :dwk
				AND
					stdywk = :swk"

				,bindArgs = {
					wt  = fv.ps_weight
				 ,pid = fv.ps_pid
				 ,dwk = sess.current.day
				 ,swk = sess.current.week
				}
			);
			if ( !qh.status ) { 
				errAndRedirect( "Error at process_checkin_form.cfm (132): #SerializeJSON(bpi)#" );
			}
		}
		else if ( ListContains(RESISTANCE, extype) ) {
			qh = ezdb.exec( 
				string = "UPDATE #data.data.resistance# 
					SET weight = :wt 
				WHERE
				participantGUID = :pid
				dayofwk = :dwk
				studywk = :swk"

				,bindArgs = {
					wt  = fv.ps_weight
				 ,pid = fv.ps_pid
				 ,dwk = sess.current.day
				 ,swk = sess.current.week
				}
			);
			if ( !qh.status ) { 
				errAndRedirect( "Error at process_checkin_form.cfm (152): #SerializeJSON(bpi)#" );
			}
		}
	}
	catch (any ff) {
		errAndRedirect( "Error at process_checkin_form.cfm: #ff#" );
	}

	//Get the form part id, and redirect to end or res based on that	
	location( url="input.cfm?id=#form.ps_pid#", addtoken="no" ); 
}
</cfscript>
