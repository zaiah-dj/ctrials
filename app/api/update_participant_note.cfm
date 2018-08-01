<!--- update a participant note --->
<cfscript>
try {
	stat = val.validate( form, { 
		note = { req = true }
	 ,pid  = { req = true }
	 ,sid  = { req = true }
	});

	if ( !stat.status ) {
		req.sendAsJson( status = 0, message = "#errstr# #stat.message#" );
	}

	fv = stat.results;
	dstmp = LSParseDateTime( 
		"#session.currentYear#-#session.currentMonth#-#session.currentDayOfMonth# "
		& DateTimeFormat( Now(), "HH:nn:ss" )
	);

	stat = dbExec( 
		string = "
		INSERT INTO 
			#data.data.notes#	
		( 
		  noteGUID
		 ,participantGUID
		 ,noteText
		 ,noteCategory
		 ,noteDate
		 ,d_inserted
		 ,insertedBy
		 ,deleted
		 ,deletedby
		 ,d_deleted
		)
		VALUES ( 
		 	newid() 
		 ,:participantGUID
		 ,:noteText
		 ,:noteCategory
		 ,:noteDate
		 ,:d_inserted
		 ,:insertedBy
		 ,:deleted
		 ,NULL
		 ,:d_deleted
		)
		"
	 ,bindArgs = {
		  noteGUID=0
		 ,participantGUID=fv.pid
		 ,noteText=fv.note
		 ,noteCategory=3
		 ,noteDate={ value = dstmp, type="cf_sql_date" }
		 ,d_inserted={ value = dstmp, type="cf_sql_date" }
		 ,insertedBy=fv.sid
		 ,deleted=0
		 ,d_deleted=0
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
