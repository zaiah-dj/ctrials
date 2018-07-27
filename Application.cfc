/*
Application.cfc

@author
	Antonio R. Collins II (ramar.collins@gmail.com)
@end

@copyright
	Copyright 2016-Present, "Deep909, LLC"
	Original Author Date: Tue Jul 26 07:26:29 2016 -0400
@end

@summary
  All Application.cfc rules are specified here.
@end
*/ 
component {
//component extends="motrpac.web.secure.Application"

	setting showdebugoutput="false";
	this.sessionManagement = true;

	switch ( #CGI.HTTP_HOST# ) {
		// LOCAL
		case "127.0.0.1:8500":
			this.applicationTimeout = "#createtimespan(1,0,0,0)#";
			this.sessionTimeout = "#createtimespan(0,0,20,0)#";
			this.setClientCookies = "yes";
			this.clientStorage = "cookie";
			this.clientManagement = "yes";
			request.whichserver = "local";
			application.dsn = "Iv_Tracker_Db";
			break;
		// DEVELOPMENT ---
		case "dev1cf16.phs.wakehealth.edu":
			this.applicationTimeout = "#createtimespan(1,0,0,0)#";
			this.sessionTimeout = "#createtimespan(0,0,20,0)#";
			this.setClientCookies = "yes";
			this.clientStorage = "cookie";
			this.clientManagement = "yes";
			request.whichserver = "dev";
			application.dsn = "motrpac";
			break;
		// PRODUCTION SERVER ---
		default:
			this.applicationTimeout = "#createtimespan(1,0,0,0)#";
			this.sessionTimeout = "#createtimespan(0,0,30,0)#";
			request.whichserver = "prod";
			application.dsn = "motrpac";
			//error type="EXCEPTION" template="/errorException.cfm" mailto="#application.siteadminemail#"
	}
	
	/*Modified to more closely match how things are done at WFCF*/
	function onApplicationStart ( ) {
		appInit();
	}

	function appInit() {
		0;
	}

	function onRequestStart (string Page) {
		//application.data = DeserializeJSON(FileRead(this.jsonManifest, "utf-8"));
		if (structKeyExists(url, "reload")) {
			onApplicationStart();
		}
	}

	function onRequest (string targetPage) {
		try {
			//include arguments.targetPage;
			include "index.cfm";
		} 
		catch (any e) 
		{ //This bypasses onError
			//You can open CMVC and do something here...
			if ( StructKeyExists( e, "TagContext" ) )
			{
				//Short note the tag with the information.
				av = e.TagContext[ 1 ];
/*
writedump( av );
writedump( e );
abort;
*/
				status_code    = 500;

				try {
				status_message = 
					"<ul>" &
					"<li>Could not process page: '#arguments.targetPage#'.<li>" &
					"<li>Error encountered at line #av.line#, column #av.column#</li>" &
					"<li>#iif( StructKeyExists( av, 'codePrintHTML'), DE(av.codePrintHTML),DE(''))#</li>" &
					"<li>##</li>" &
					"</ul>";
				;
				}
				catch (any errMsgMsg) {
					// Just die and let us know something
					writedump( errMsgMsg );
					writedump( av );
					writedump( e );
					abort;
				}

				//error...
				err = {
					statusCode     = 500
					//This would overwrite the original thing...
					,statusMessage = "Page '" & arguments.targetPage & "' does not exist."
					,message       = "Page '" & arguments.targetPage & "' does not exist."
					,statusLine    = av.line
					,statusPre     = av.codePrintHTML
					,exception     = e
				};

				include "std/5xx-view.cfm";
				abort;
			}

			//What is this?	
			abort;
			
			//Better exception handling is needed here....
			status_code    = 500;
			status_message = 
				"Page '" & arguments.targetPage & "' does not exist.";
			include "std/4xx-view.cfm";
		}
	}

	function onError (required any Exception, required string EventName) 
	{
		writedump(Exception);
		e = Exception;

		//These shouldn't be needed
		//abort;

		if ( StructKeyExists( e, "TagContext" ) )
		{
			//Short note the tag with the information.
			av = e.TagContext[ 1 ];
			//writeoutput( e.TagContext.line );

			//Better exception handling is needed here....
			status_code    = 500;
			status_message = 
				"<ul>" &
				"<li>Page '" & arguments.targetPage & "' does not exist.<li>" &
				"<li>At line " & av.line & "</li>" &
				"<li><pre>" & av.codePrintHTML & "</pre></li>" &
				"</ul>";
				av.codePrintHTML &

				"Page '" & arguments.targetPage & "' does not exist.";
			include "std/5xx-view.cfm";
		}
	
		//abort;
		include "failure.cfm";
	}

	function onMissingTemplate (string Page) {
		include "index.cfm";
	}
}
