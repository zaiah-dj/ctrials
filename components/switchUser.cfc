/* -------------------------------------------------- * 
	switchUser.cfc

 	Switch out the current user for debugging purposes.	

	Some test users ship with the application:
	userGUID	                            firstname	lastname	userID	siteID
	CDDAC161-2B5E-44CF-ABC8-D15623942239	Antonio	  Collins	  1049	  999
	27CF2248-CDF7-498F-BDCB-479B810414B0	Joseph	  Robertson	1081	  999
	09D141B0-5637-4850-9C14-85229A9B1E19	Kristy	  Gordon	  1087	  999
	BA992C56-8587-47C1-A584-7280E55F3B57	Alba	    McIntyre	8181	  999
	0EED37BA-5992-4A77-B65A-0ABC0E5C54C4	Aldous	  Huxley	  9909	  777
	6D77BB0A-2858-41C5-9F3C-4D70525FDB3E	Cameron	  Fontana	  7141	  777
	001F75F6-EB86-42B6-AF06-A3459A454248	Majel	    Barrett	  4411	  777
	31576630-8B54-4F51-86E5-9B913ABFEAF9	Aldous	  Huxley	  2233	  888
	50958F03-DDEB-4325-8999-A769F453B8B4	Cameron	  Fontana	  331	    888
	72A16F16-EE23-401A-A7A0-25CD8941FCCE	Majel	    Barrett	  8010	  888

	The user data is stored in session, so most of the time
	that will work.

	If for some reason the session.userguid and userguid values
	don't match, then this will query the database for another user.
	
 * -------------------------------------------------- */
component {
	this.object = {};

  /* -------------------------------------------------- * 
	function init ( userguid, userNumericId )

	userguid or userNumericId can be supplied and sent to query	
   * -------------------------------------------------- */
	function init ( Required dsn, Required tn, Required id ) {
		//Because this is a component and dependency injection makes this 
		//much harder than it should be, I'm just going to use the standard 
		//cfscript query function
		try {
			q = new Query( datasource="#arguments.dsn#" );
			stat = 0;

			//If 'id' is numeric, it's more than likely a numeric user id, if not, let's assume its a guid
			if ( IsNumeric( arguments.id ) ) {
				sqlQuery = "SELECT * FROM #arguments.tn# WHERE userID = :uid";
				q.addParam( name="uid", value=arguments.id, cfsqltype="cf_sql_numeric" );
				stat = ( session.userid == arguments.id );
			}
			else { 
				sqlQuery = "SELECT * FROM #arguments.tn# WHERE userGUID = :uid";
				q.addParam( name="uid", value=arguments.id, cfsqltype="cf_sql_varchar" );
				stat = ( session.userguid == arguments.id );
			}

			//Execute the query
			r = q.execute( sql = sqlQuery );
			rp = r.getPrefix();
			rz = r.getResult();

			//If there are no users in the Interventionist table, redirect letting the user know
			if ( rp.recordCount eq 0 ) {
				return {
					status = false
				, message = "User identifier '#arguments.id#' not found in motrpac table #arguments.tn#"	
				};
			}
		}
		catch ( any fe ) {
			//If there are any query errors, let the current user know that and stop execution
			//(or redirect to motrpac home page)
			return {
				status = false
			, message = fe.message
			};
		}

		//Return an object with everything initialized
		return {
			status = true
		 ,firstname = rz.firstname	
		 ,lastname  = rz.lastname	
		 ,siteid    = rz.siteid	
		 ,userguid  = rz.userguid	
		 ,userid    = rz.userid	
		 //The following keys are not in a database, so if the session
		 //is used to generate user information (and most of the time
		 //it will be), add those keys to this resultant object here.
		 //Otherwise, use some placeholder values 
		 ,email     = ( stat ) ? session.email : "mopoUser1@motrpac.org"
		 ,logindts  = ( stat ) ? session.logindts : Now()
		 ,username  = ( stat ) ? session.username : "#Left(rz.firstname,2)##rz.lastname#"
		};
	}
}
