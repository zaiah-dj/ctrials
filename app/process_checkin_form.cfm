<cfscript>
if ( IsDefined( "form" ) && !StructIsEmpty( form ) )
{
	try {
		//Regular variables
		message = "";
		ns = "2008-09-09";
		sess_id = session.iv_motrpac_transact_id;
		fieldsToCheck = "ps_pid,ps_day,ps_next_sched,bp_systolic,bp_diastolic";
		bp = ( StructKeyExists( form, "ps_bp" ) ) ? form.ps_bp : 0;
		nt = ( StructKeyExists( form, "ps_notes" ) ) ? form.ps_notes : 0;

		//Check for the form fields that are needed and try to insert.
		fields = cf.checkFields( form, "ps_pid", "ps_day", "ps_next_sched", "bp_systolic", "bp_diastolic" );
		if ( !fields.status ) 
			message = fields.message;
		else {
			for ( n in ListToArray( fieldsToCheck ) ) {
				if ( StructFind( form, n ) eq "" ) { 
					message = "Field #n# cannot be blank.";
					break;
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
					 ,bp_notes = :notes
					WHERE 
						bp_pid = :id"
				,bindArgs={ 
					 id        = form.ps_pid
					,systolic  = form.bp_systolic
					,diastolic = form.bp_diastolic
					,notes=""
					,recorddate= { value=DateTimeFormat( Now(), "YYYY-MM-DD" ),type="cfsqldatetime" }
				});

			//Add a row 
			qr = ezdb.exec( 
				string="INSERT INTO ac_mtr_checkinstatus VALUES (:id,:sid,1,:day,:ns,:ds,:nt)"
			 ,bindArgs = {
				 id = form.ps_pid
				,sid = sess_id	
				,day = form.ps_day 
				,ns={value=DateTimeFormat( Now()+2, "YYYY-MM-DD" ),type="cfsqldatetime"}
				,ds={value=DateTimeFormat( Now(), "YYYY-MM-DD" ),type="cfsqldatetime"}
				,nt = nt
			});

			//Check the queries and see if they failed
			message = qr.message;
		}
	}
	catch (any e) {
		writeoutput( e.message );
	}

	//Get the form part id, and redirect to end or res based on that	
	location( url="input.cfm?id=#form.ps_pid#", addtoken="no" ); 
}
</cfscript>
