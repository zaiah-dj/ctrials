<cfscript>
errstr = "/api/updateTime.cfm - ";
try {
	stat = cmValidate( form, { 
		pid = { req = true }
	/* ,exindex = { req = true } */
	});

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}

	fv = stat.results;

	//Get the participant
	stat = dbExec(
		string = "SELECT * FROM v_ADUSessionTickler WHERE participantGUID = :pid" 
	 ,bindArgs = { pid = fv.pid }
	);

	if ( !stat.status ) 
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );

	if ( stat.prefix.recordCount eq 0 )
		req.sendAsJson( status = 0, message = "#errstr# No matching participants found." );

	tb = ( ListContains( const.ENDURANCE, stat.results.randomGroupCode ) ) ? "frm_eetl" : "frm_retl";

	//This is in case I find myself modifying dates from other times
	dstmp = LSParseDateTime( 
		"#session.currentYear#-#session.currentMonth#-#session.currentDayOfMonth# "
		& DateTimeFormat( Now(), "HH:nn:ss" )
	);

	simpleDstmp = LSParseDateTime( 
		"#session.currentYear#-#session.currentMonth#-#session.currentDayOfMonth# "
	);

	stat = dbExec(
		string = "
			UPDATE #tb# 
			SET 
				wrmup_starttime = :time 
			WHERE 
				d_visit = :dvisit
			AND
				participantGUID = :pid" 
	 ,bindArgs = { 
			pid = fv.pid, 
			dvisit = { value = simpleDstmp, type="cf_sql_date" },
			time = { value = dstmp, type="cf_sql_date" }
		}
	);

	if ( !stat.status )	{
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}
}
catch (any e) {
	req.sendAsJson( 
		status = 500,
		message = '#e.message# - #e.detail#' 
	);
}

writeoutput( SerializeJSON( stat ) );
abort;
req.sendAsJson( 
	status = 200,
	message = "#SerializeJSON( stat.results )#" 
);
</cfscript>
