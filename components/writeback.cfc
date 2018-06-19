/*

cfwriteback.cfc
===============

This is a test page for cfwriteback, a CFC used to make creating AJAX
super-easy and simple.
	

Example server-side usage 
-------------------------
w = CreateObject( "component", "cfwriteback" )(
server = {
	listen= "form",           //Which scope to listen for?
	table = "Basic_Entries", 
	using = "SQLServer",
	ds    = "Iv_Tracker_Db",
	where = "sess_id = <cfqueryparam value=##status## cfsqltype=CF_SQL_VARCHAR>"
	map   = {
			...  //column names that may not match what's coming...
	}
});


Example client-side usage
-------------------------
1) CF
w = CreateObject( "component, "cfwriteback" )({
	client = {
		with   = "192.168.56.101",
	 ,at     = "/index.cfm"
	 ,method = "POST"
	}
});

This is NOT the preferred solution by any means, mostly because of the nearly
infinite ways that Javascript events can be programmed for.  Not to mention all
of the different framework choices.  

However, for the sake of simplicity, a lot can be handled with just some (rather
ugly) Javascript metaprogramming.


2) Just use JS. :)


Test Cases
----------
Copy and paste these into your .cfm things...
<!---
Bind param and table with both 'value' and 'type' specified 
<cfset bla = checkFor( where = "sess_id = :sess_id", predicate = { sess_id = { value = "##form.truana##", type="varchar" }} )>
	--->
<!---
Bind param and table with just the parameter specified
<cfset bla = checkFor( where = "sess_id = :sess_id", predicate = { sess_id = "##form.truana##"} )>
	--->
<!---
Bind param and simple predicate (let CF figure it out)
<cfset bla = checkFor( where = "sess_id = :sess_id", predicate = "##form.truana##" )>
	--->
<!---
Bind param and simple predicate (let CF figure it out)
<cfset bla = checkFor( where = "my_id = :myd", predicate = "3" )>
	--->
<!---
Bind param and simple predicate (let CF figure it out).  Supposed to fail.
<cfset bla = checkFor( where = "my_id = :myd", predicate = "Fail" )>
	--->
<!---
Compound statements
<cfset bla = checkFor( where = "sess_id = :sess_id AND my_id = :myd", predicate = { sess_id = "##form.truana##", myd = {value=2,type="integer" }} )>
	--->


TODO
----
- Client: give a way to query the results of XHR calls (has to interact with stuff)

*/
component {

	//datasource and table should be part of the component
	this.datasource = "";

	//also should be private
	this.table = "";

	//should be a private var...
	this.DebugMe = 0;


	//Returns an object with 'value' and 'type'
	//
	//Checks that the value can be Evaluated()
	//Should handle binding
	//
	// ap  - A place to search for values that could [ string, array or struct ]
	// obj - 
	// parameter - A potential key that could exist
	private function checkBindType ( 
	   ap
	  ,String parameter
 	)
	{
		//Pre-initialize 'value' and 'type'
		v = {};
		v.value = "";
		v.name  = parameter;
		v.type  = "varchar";

		//If the dev only has one value and can assume it's a varchar, then use it (likewise I can probably figure out if this is a number or not)
		if ( !IsStruct( ap ) ) 
		{
			v.value = ( Left(ap,1) eq '##' && Right(ap,1) eq '##' ) ? Evaluate( ap ) : ap;
			try {
				//coercion has failed if I can't do this...
				__ = value + 1;
				v.type = "integer";
			}
			catch (any e) {
				//writeoutput( "conversion fail: " & e.message & "<br />" & e.detail & "<br />" );
				v.type = "varchar";
			}
		}
		else
		if ( StructKeyExists( ap, parameter ) ) {
			//Is ap.parameter a struct?	
			//If not, then it's just a value
			if ( !IsStruct( ap[ parameter ] ) )
				v.value = ( Left(ap[parameter],1) eq '##' && Right(ap[parameter],1) eq '##' ) ? Evaluate( ap[parameter] ) : ap[parameter];
				//value = Evaluate( ap[ parameter ] );
			else 
			{
				if ( StructKeyExists( ap[ parameter ], "value" ) )
					v.value = ( Left(ap[parameter]["value"],1) eq '##' && Right(ap[parameter]["value"],1) eq '##' ) ? Evaluate( ap[parameter]["value"] ) : ap[parameter]["value"];
					//value = Evaluate( ap[ parameter ][ "value" ] );
				if ( StructKeyExists( ap[ parameter ], "type" ) )
					v.type = ap[ parameter ][ "type" ];
			}
		}

		//See test results	
		//writeoutput( "Interpreted value is: " & value & "<br /> & "Assumed type is: " & type & "<br />" ); 
		//nq.addParam( name = parameter, value = value, cfsqltype = type );
		return v; 
	}


	//checkfor - Checks for values in the database.  
	//It's such a common operation that it is one of the included situations to check 
	//against when deciding to INSERT or UPDATE records
	private Boolean function checkFor(
			Required String where
		 ,Required predicate 
		 ,String database = "#this.datasource#"
		 ,String table = "#this.table#"
		) 
	{
		messageOfDoom = "";
		recordCount = 0;
		a_char = "";
		count = 0;
		mp = [];
		mpCount = 0;

		//Extract all parameters for binding
		do {
			a_char = GetToken( arguments.where, ++count, " " );

			//This is a "parameter"	
			if ( Left( a_char, 1 ) eq ":" ) {
				mp[ ++mpCount ] = Mid( a_char, 2, Len( a_char ) );
			}
		
		} while ( a_char neq "" );


		//Execute the query	
		try {
			nq = new Query();
			nq.setDatasource( "#arguments.database#" );
			ap = arguments.predicate;

			//Bind all parameters in the 'predicate' object
			for ( parameter in mp ) {
				n = checkBindType( ap, parameter );
				nq.addParam( name = n.name, value = n.value, cfsqltype = n.type );
			} //end for

			nr = nq.execute( sql = "SELECT * FROM #arguments.table# WHERE #arguments.where#" );
			nm = nr.getPrefix();
		}
		catch (any e) {
			messageOfDoom = "#e.message# & #e.detail#";
			//writeoutput( messageOfDoom );
			return 0;
		}

		recordCount = nm.recordCount;
		return ( recordCount > 0 ) ? 1 : 0;

		/*
		-1 = An error occurred.  Check why.
		 0 = Whatever I asked for just wasn't there.
		 1 = What I asked for was there
		*/
	}


	//Generate a random number.
	public String function _randnum ( Numeric n ) 
	{
		// make an array instead, and join it...
		str="0123456789";
		tr="";
		for (x=1;x<n+1;x++)
			tr = tr & Mid(str, RandRange(1, len(str) - 1), 1);
		return tr;
	}


	//TestInsertOn
	public Boolean function TestInsertOn ( )
	{
		//Test the results of InsertOn...
		return 0;
	}


	//Some client debugging code to see stuff...
	public String function ClientDebug() 
	{
		this.DebugMe = 1;
		writeoutput( '
			<script type=text/javascript>
			function _LOG( text ) {
				//if ( !(a = document.getElementById( "_debugger" )) )
				if ( !(a = document.querySelectorAll( "##_debugger .inner" )[0]) )
					console.log( text );
				else {
					div = document.createElement( "div" );
					div.innerHTML = text;
					a.appendChild( div );
				}
			}

			//Initialize a debugger window here...
			if ( !document.getElementById( "_debugger" ) ) 
			{
				// _debugger
				aa = document.createElement( "div" );
				aa.id = "_debugger";
				aa.style.position = "absolute";
				aa.style.top = "10px";
				aa.style.overflow = "scroll";
				aa.style.right = "20px";
				aa.style.width = "30%";
				aa.style.height = "50%";
				aa.style.backgroundColor = "red";
			
				//button to wipe things	
				button = document.createElement( "button" );
				button.innerHTML = "Wipe!";
				button.style.width = "100px";
				button.style.color = "black";
				button.style.fontSize = "0.8em";
				button.style.height = "20px";
				aa.appendChild( button );

				//???
				div = document.createElement( "div" );
				div.className = "inner";
				aa.appendChild( div );

				//make the button wipe things
				button.addEventListener( "click", function (ev) {
					//Get rid of all children...
					document.querySelectorAll( "##_debugger .inner" )[0].innerHTML = "";
				} );

				//add to the dom
				document.body.appendChild( aa );
		}</script>' );
	}

	//Client
	public String function Client (
		 Required String location 
		,querySelector 
		,qs
		,String traverse 
		,String method 
		,String event
		,Boolean enctype 
		,Boolean useBinary 
		,Boolean showDebug 

		,debug
	)
	{
		//The entire point is to output already finished XHR code

		//Trying some weird stuff with strings, b/c the language is getting in the way.
		JS_ERRORS = {
			ERR_MISSING_ARG = "Required args 'to' is not present. Stopping..."
		 ,ERR_UNFINISHED_REQUEST = "Coulndn't finish request."
		 ,ERR_VALUE_SAVE_FAILED = "Coulndn't save values."
		};

		//Where is everything that the user is asking for?
		QUERY_SELECTION = "#arguments.querySelector#";
		QUERY_SELECTIONS = [];
		DOM_EVENT = "";
	
		//Move through all the things here
		if ( StructKeyExists( arguments, "querySelector" ) ) {
			//if it's not a struct, reject it
			if ( !IsArray(arguments.querySelector) && !IsStruct( arguments.querySelector ) )
				throw( "querySelector argument must be a struct or array." );
			else {
				//Turn this into a single member array if there are no other members
				if ( IsStruct( arguments.querySelector ) )
					ArrayAppend( QUERY_SELECTIONS, arguments.querySelector );	
				else {	
					QUERY_SELECTIONS = arguments.querySelector;
				}

				//Loop and check for 'dom' and 'event'
				for ( st in QUERY_SELECTIONS ) {
					if ( !StructKeyExists( st, "dom" ) && !StructKeyExists( st, "event" ) ) {
						throw( "Missing required keys 'dom' and 'event' for querySelector parameter." );
					}
				}
			}

			//expects keys: "dom", "event", "send" is an optional parameter so no crazy callbacks are needed
 			//,querySelector = { querySelector = "#sendThatWaffle", event = "click", send = "input[ name=waffle ]" }
		}

		//Output debugging code from the server if need be.
		JS_DEBUG 	= ( StructKeyExists(arguments,"showDebug") ) ? 1 : 0;
		TRAVERSE = ( StructKeyExists( arguments, 'traverse' ) ) ? 1 : 0;
		TRAVERSAL_FUNCTION = "function (evt) { return evt.target.parentElement.children[0]; }";
		JS_DEBUG_DUMP_EL 	= 1;
		FAIL 			= 0;
		METHOD 		= "POST";
		LOCATION 	= "#arguments.location#";
		ASYNC 		= true;
		HEADER_TYPE = "application/x-www-form-urlencoded" /*multipart/form-data*/;
		if ( !this.DebugMe )
			READY_STATE_CHANGE_FUNCTION = "function () { if ( this.readyState == 4 ) { if ( this.status == 200 ) { console.log(this.responseText);}  } else { #FAIL#; } }";
		else {
			READY_STATE_CHANGE_FUNCTION = "function () { if ( this.readyState == 4 ) if ( this.status == 200 ) { _LOG( this.responseText );console.log(this.responseText);} else { #FAIL#; } }";
		}
	
		//Save all the additional values that ought to be sent too
		ADDITIONAL_VALUES = "";
		if ( !StructKeyExists( arguments, "additional" ) ) 
			ADDITIONAL_VALUES = "[]";
		else {
			c = 0;
			if ( IsArray( arguments.additional ) ) {
				for ( aa in arguments.additional ) {
					ADDITIONAL_VALUES &= '{ name: "#StructFind( aa, 'name' )#", value: "#StructFind( aa, 'value' )#" },';
				}
			}	
			else if ( IsStruct( arguments.additional ) ) {
				ADDITIONAL_VALUES &= '{ name: "#StructFind( arguments.additional, 'name' )#", value: "#StructFind( arguments.additional, 'value' )#" },';
			}
			ADDITIONAL_VALUES = "[" & RemoveChars( ADDITIONAL_VALUES, Len(ADDITIONAL_VALUES), 1 ) & "]";
		}

		//This won't work in EVERY situation, but it should
		//* Be able to work with a DOM element and the common list of DOM events
		//* Be able to be used as a callback to a timer like requestAnimationFrame
 
		//Generate a function and do this...	
		savecontent variable="AllThatJS" {
			writeoutput( "<script>
				document.addEventListener('DOMContentLoaded',function(ev) {
					console.log( navigator.userAgent );
			" );

			//Loop through and figure out each place on the dom...
			for ( qss in #QUERY_SELECTIONS# ) {
				varname = 'a' & _randnum( 9 );

				writeoutput( "
					#varname# = [].slice.call( document.querySelectorAll( '#qss.dom#' ) );
					( #JS_DEBUG# && #JS_DEBUG_DUMP_EL# ) ? console.log( #varname# ) : 0;
					for ( i=0; i < #varname#.length; i++ ) {
						#varname#[i].addEventListener( '#qss.event#', function (ev) {
							( #(StructKeyExists(qss,'noPreventDefault'))?0:1# ) ? ev.preventDefault() : 0; 
							arrVal = []; 
							( #JS_DEBUG# ) ? console.log( 'Event ' + ev + ' was registered.' ) : 0;
					");

				//Negotiate how to get DOM elements 
				if ( StructKeyExists( qss, "send" ) )
					writeoutput( "		mv = document.querySelectorAll( '#qss.send#' );" ); 
				else if ( StructKeyExists( qss, "callback" ) )
					writeoutput( "		mv = (#qss.callback#)( ev );" ); 
				else { 
					writeoutput( "		mv = [{ name: ev.target.name, value: ev.target.value }];" );
				}

				writeoutput( "
							( #JS_DEBUG# ) ? console.log( mv ) : 0;
							for (i=0;i<mv.length;i++) { arrVal.push( mv[i].name + '=' + mv[i].value ); };
							av = (#iif(StructKeyExists(arguments,"additional"),1,0)#) ? #ADDITIONAL_VALUES# : [];
							for (i=0;i<av.length;i++) { arrVal.push( av[i].name + '=' + av[i].value ); };
							( #JS_DEBUG# ) ? console.log( av ) : 0;
							Vals = arrVal.join( '&' );
							( #JS_DEBUG# ) ? console.log( Vals ) : 0;
							( #JS_DEBUG# ) ? console.log( 'Sending values ' + arrVal.join(' & ') + ' to #LOCATION#' ) : 0;
							x = new XMLHttpRequest();
							//x.onreadystatechange = #READY_STATE_CHANGE_FUNCTION#;
							//x.open( '#METHOD#', '#LOCATION#', #ASYNC# );
							x.open( '#METHOD#', '#LOCATION#', false );
							x.setRequestHeader( 'Content-Type', '#HEADER_TYPE#' );
							x.send(Vals);
							( #JS_DEBUG# ) ? console.log( x.responseText ) : 0;
							return false;
						}	);
					} " );
			}

			writeoutput( "}	);</script>" );
		};

		//Return the JS to the client
		return "#AllThatJS#";
	}


	//Server
	public String function Server (
		 Required String table
		,Required String listen 	
		,Required String ds
		,String using = "SQLServer"
		,only 
		,insertWhere
		,where
		,all
		,String insertOn 
		,String insertStmt 
		,String updateStmt 
		,Boolean noFilter 
		,Boolean noConstraint = 0
	)
	{
		//Set datasource and table name.  Also set markers for flow control
		this.table = arguments.table;
		this.datasource = arguments.ds;
		flow = "0";
		next = 1;

		//A spot for a user friendly failure message.	
		err = {	
		 ufMessage = ""
		 ,status = 1
		};

		//Start by trying to get the schema.
		try {
			flow = "getSchema"; 
			cv = {};

			//Define which syntax to use to go about getting the schema
			if ( arguments.using eq "SQLServer" )
				schemaQuery = "SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = :tname";
			else {
				//Throw an exception, cuz I haven't gotten around to other engines yet
				err.ufMessage = "Only MSSQL server is supported right now.";
				next = 0;
				throw "Only MSSQL Server is supported by cfwriteback right now.";
			}
			
			//Check the schema for the fields in question	
			nq = new Query();
			nq.setDatasource( "#arguments.ds#" );
			nq.setName( "allColumns" );
			nq.addParam( name = "tname", value = arguments.table, cfsqltype = "varchar" );
			schemaObj = nq.execute( sql = schemaQuery );
			schemaResults = schemaObj.getResult();

//
include "components/sendRequest.cfm";
writeoutput( schemaObj );
lsendRequest( "jakes" );
abort;


			//check the status of query
			//results should be there...	
			if ( schemaResults.recordCount eq 0 ) {
				next = 0;
				err.ufMessage = "Schemeas didn't load.";
			}

			//Check that values are there and that data types match
			if ( next ) {
				flow  = "filter";
		
				//Default to using 'form' as the scope to check for keys within
				from  = form;
				scope = "form";
				
				//Extract each term from either URL, form or arguments.only ( default to POST )
				if ( structKeyExists( arguments, "listen" ) )
				{
					methArg = UCase( arguments.listen );
					if ( methArg eq "post" || methArg eq "put" )
						from = form;	
					else if ( methArg eq "get" ) {
						from = url;	
						scope = "url";
					}
					else {
						if ( methArg neq "form" && methArg neq "url" ) {
							next = 0;
							err.ufMessage = "'#methArg#' not an acceptable argument for parameter 'listen'" &
								"(Your valid choices are 'GET', 'POST', 'PUT', 'FORM', 'URL' )";
						}
					}
				}

				//writeoutput( arguments.listen );
				//writedump( from );
			
				//Choose where to pick field names from
				if ( !StructKeyExists( arguments, "only" ) && !StructKeyExists( arguments, "all" ) ) 	
					t = from;
				else if ( StructKeyExists( arguments, "only" ) )
					t = ( IsArray( arguments.only ) ) ? arguments.only : ListToArray( arguments.only, "," );
				else if (	StructKeyExists( arguments, "all" ) ) {
					t = ( IsArray( arguments.all ) ) ? arguments.all : ListToArray( arguments.all, "," );

					//Check if the field has a value it's supposed to be (useless for non-only checks)
					for ( n in t ) {
						if ( !StructKeyExists( from, n ) ) {
							next = 0; 
							err.ufMessage = "This field does not exist in the requested scope ( #scope# ).";
							break;
						}
					}
				}

				/*
				//This would be so much more efficient.
				nr = nq.execute( sql = "SELECT COLUMN_NAME, DATA_TYPE FROM sourceQuery WHERE COLUMN_NAME IN :col" );
				 */
				for ( n in t ) 
				{
					//Then check that's it's in the query returned	
					nq = new Query();
					nq.setName( "myJuniorQuery" );
					nq.setDbType( "query" );
					nq.setAttributes( sourceQuery = schemaResults );
					nq.addParam( name = "col", value = n, cfsqltype = "varchar" );
					//Using IN would be much more efficient, but also a bit difficult with these binding rules
					nr = nq.execute( sql = "SELECT COLUMN_NAME, DATA_TYPE FROM sourceQuery WHERE COLUMN_NAME = :col" );
					fieldResults = nr.getResult();
	
					if ( fieldResults.recordCount eq 0 ) {
						next = 0;
						err.ufMessage = "Field '#n#' not found in table '#arguments.table#'.";
						break;
					}

					//This should NEVER happen, but you never know... throw up if it does
					if ( fieldResults.recordCount gt 1 ) {
						next = 0;
						err.ufMessage = "Field '#n#' somehow names multiple columns within '#arguments.table#'.";
						break;
					}

					//Go ahead and check the actual value against it's expected data type
					if ( StructKeyExists( from, n ) ) {
						testValue = 
						cv[ n ][ "value" ] = StructFind( from, n );
						cv[ n ][ "type" ]  = fieldResults.DATA_TYPE; 

						switch ( LCase( fieldResults.DATA_TYPE ) ) {
							case "integer":
							case "float":
								if ( !IsValid( "integer", testValue ) ) {
									next = 0;
									err.ufMessage = "Datatype of field '#n#' does not match expected data type in '#arguments.table#' (#fieldResults.DATA_TYPE#).";
								}
								break;
							case "string":
							case "varchar":
								if ( !IsValid( "string", testValue ) ) {
									next = 0;
									err.ufMessage = "Datatype of field '#n#' does not match expected data type in '#arguments.table#' (#fieldResults.DATA_TYPE#).";
								}
								break;
							case "bit":
								if ( !IsBoolean( testValue ) ) {
									next = 0;
									err.ufMessage = "Datatype of field '#n#' does not match expected data type in '#arguments.table#' (#fieldResults.DATA_TYPE#).";
								}
								break;
							case "datetime":
								break;
						}
		
						//Exit this loop if the case statement failed...
						if ( !next ) {
							break;
						}
					}
				}
			}


			//insert whatever the thing is you're trying to insert.... yah
			if ( next && Evaluate( insertOn ) ) {
				flow = "insert";

				//This next step will need a query regardless
				nq = new Query();
				nq.setDatasource( "#arguments.ds#" );
				nq.setName( "modify" );
				sql_stmt = "";
				COLUMNS = "";
				VALUES  = "";

				//Attempt an insert
				if ( StructKeyExists( arguments, "insertStmt" ) ) 
					sql_stmt = arguments.insertStmt;
				else {
					//Have the engine figure it out...
					sql_stmt = "INSERT INTO #table# ( #COLUMNS# ) VALUES ( #VALUES# )"; 
				}

lsendRequest( message=sql_stmt );
abort;

				//Go through things and bind
				if ( StructKeyExists( arguments, "insPredicate" ) ) {
					for ( k in arguments.insPredicate ) {
						a = checkBindType( arguments.insPredicate, k );  
						nq.addParam( name = a.name, value = a.value, cfsqltype = a.type );
					}
				}

				//After the initial write, I really need to attempt to update again, since that is the real value.
				nrr = nq.execute( sql = sql_stmt ); 
//writedump( nrr );
//abort;
				//If this fails, it will just throw an exception.
				next = 1;
			}


			//...
			if ( next ) {
				flow = "update";
				//This next step will need a query regardless
				nq = new Query();
				nq.setDatasource( "#arguments.ds#" );
				nq.setName( "modify" );

				//A custom UPDATE can be specified here... it's going to need similar logic...	
				//

				//Loop through the scope and bind each field (this is where it'd be helpful to have something a bit different for names)
				SQL_STRING = "UPDATE #table# SET";

				//Start with some basic update mess the following assumes I've created a struct during the field checking step
				for ( n in cv ) {
					nq.addParam( name = n, value = cv[ n ][ "value" ] , cfsqltype = cv[ n ][ "type" ] );
					SQL_STRING &= " #n# = :#n#,";
				}

				//Need some way to bind from here too
				SQL_STRING = RemoveChars( SQL_STRING, Len(SQL_STRING), 1 );
	
				//If arguments.where is a string, do something
				//If not, then do the structKeyExists dance
				if ( StructKeyExists( arguments, "where" ) ) {
					if ( !IsStruct( arguments.where ) )
						SQL_STRING &= " WHERE " & arguments.where;
					else {
						if ( !StructKeyExists( arguments.where, "clause" ) ) {
							next = 0;
							err.ufMessage = "No clause specified for UPDATE statement.";			
						}	
						else {
							SQL_STRING &= " WHERE " & arguments.where.clause;

							if ( !StructKeyExists( arguments.where, "predicate" ) )
								0;
							else {
								ap = arguments.where.predicate;
								app = {};
								if ( IsStruct( ap ) )
									for ( n in ap ) { app = checkBindType( ap, n ); nq.addParam( name = app.name, value = app.value, cfsqltype = app.type ); }
								else {
									app.value = ( Left(ap,1) eq '##' && Right(ap,1) eq '##' ) ? Evaluate( ap ) : ap;
									try {	__ = app.value + 1;app.type = "integer";}catch (any e) {app.type = "varchar";}//Super ugly type conversion catch code
									throw( message = 'Predicates composed of one simple value have not been fully implemented yet.  Please specify { predicate = { ##field_name## = ##field_value## } } until this changes' );
									nq.addParam( name = app.name, value = app.value, cfsqltype = app.type );
								}
							}	
						}
					}
				}
	
				//Finally, do the query and return the number of results modified using the prefix
				nr = nq.execute( sql = SQL_STRING );
				nrResults = nr.getPrefix();
				//this also gets tricky, b/c there may be no rows modified, but this doesn't necessarily mean its an error...
				if ( nrResults.recordCount gt 0 ) {
					err.ufMessage = "#nrResults.recordCount# rows in table #table# were successfully updated.";
				}	
			}
		}
		catch ( any e ) {
			//Wrap the exception details and send a message and status
			writeoutput( 
				'{ "status": 0,'&Chr(10)
				&' "message": "#e.message#", '&Chr(10)
				&' "detail": "#e.detail#", '&Chr(10)
				&' "userFriendly": "#err.ufMessage#", ' 
				&' "whereStopped": "#flow#" }' 
			);
			abort;
		}
	
		//Send a message and status
		if ( next )
			writeoutput( 
				'{ "status": 1,'&Chr(10)
				&' "message": "SUCCESS", '&Chr(10)
				&' "detail": "MORE SUCCESS", '&Chr(10)
				&' "userFriendly": "#err.ufMessage#" }' 
			);
		else {
			writeoutput( 
				'{ "status": 0,'&Chr(10)
				&' "message": "FAILED", '&Chr(10)
				&' "detail": "MORE FAIL", '&Chr(10)
				&' "userFriendly": "#err.ufMessage#", ' 
				&' "whereStopped": "#flow#" }' 
			);
		}
		return 0;
	}
}
