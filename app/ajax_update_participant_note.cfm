<!--- update a participant note --->
<cfscript>
try {
ezdb.exec( 
	string = "INSERT INTO 
		ac_mtr_participant_notes
	VALUES ( :pid, :dt, :text )"
 ,bindArgs = {
		pid = currentId
	 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
	 ,text= "#form.note#"
	}
);
}
catch (any e) {
	req.sendAsJson( 
		status = 500,
		message = '#e.message# - #e.detail#' 
	);
}	
		
req.sendAsJson( 
	status = 200,
	message = 'SUCCESS' 
);
</cfscript>
