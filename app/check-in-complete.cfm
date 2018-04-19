<cfscript>
//Get "dependencies"
qu = createObject( "component", "components.quella" );
cc = createObject( "component", "components.checkFields" );
ex = createObject( "component", "components.exceptRequest" );

//Check
if ( !IsDefined( "form" ) || !IsDefined( "session" ) || !IsStruct( form ) ) {

}


//Regular variables
sess_id = session.iv_motrpac_transact_id;
message = "";
ns = "2008-09-09";
bp = ( StructKeyExists( form, "ps_bp" ) ) ? form.ps_bp : 0;
nt = ( StructKeyExists( form, "ps_notes" ) ) ? form.ps_notes : 0;
fieldsToCheck = "ps_pid,ps_day,ps_next_sched,bp_systolic,bp_diastolic";

//Check for the form fields that are needed and try to insert.
fields = cc.checkFields( form, "ps_pid", "ps_day", "ps_next_sched", "bp_systolic", "bp_diastolic" );
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
	qu.setDs( "#data.source#" );
	bpi = qu.exec(
		string="UPDATE ac_mtr_bloodpressure 
			SET bp_systolic = :s, bp_diastolic = :d, bp_daterecorded = :r, bp_notes = :n WHERE bp_pid = :id"
	,bindArgs={ 
	 id=form.ps_pid
	,s=form.bp_systolic
	,d=form.bp_diastolic
	,r={value=DateTimeFormat( Now(), "YYYY-MM-DD" ),type="cfsqldatetime"}
	,n=""
	});

	//Add a row 
	qr = qu.exec( 
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
</cfscript>
