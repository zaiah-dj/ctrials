<cfscript>
/* --------------------------------------------------
coldmvc.cfc
-----------
@author
	Antonio R. Collins II (ramar.collins@gmail.com)
@end

@copyright
	Copyright 2016-Present, "Deep909, LLC"
	Original Author Date: Tue Jul 26 07:26:29 2016 -0400
@end

@summary
	An MVC like structure for handling ColdFusion pages.
@end

@usage
	Drop this file into your application's web root and
	call it using index.cfm or Application.cfc.
@end

@todo
	- Add a 'test' directory for tests
		In this folder have tests for functions
		Have another folder for mock views and apps
		When you deploy, these can be deleted or moved (or simply ignored)

	- Add a mock function: 
		mock(..., { abc="string", def="numeric", ... })

	- Look into adding a task to the Makefile to automate adding notes to the CHANGELOG below

	- Add the ability to select different views depending on some condition in the model

	- Add the ability to redirect on failure depending on some condition in the model

	- Complete the ability to log to other outputs (database, web storage, etc)

	- What kind of task system would work best?

	- Create app scopes as the same name of the file that vars are declared in.  
		I'm thinking that this would make it easy to follow variables throughout 
		more complex modules.

	- Add an option for mock/static data (it goes in db and can be queried)

	- how to add a jar to a project?

	- step 1 - must figure out how to use embedded databases...

	- add one of the embedded database to cmvc tooling

	- add logExcept (certain statements, you might want to stop at)

	- log (always built in, should always work regardless of backend)	

	- db (space for static data models)

	- middleware (stubs of functionality that really don't belong in app)

	- routes (stubs that define routes placed by middleware or something else)

	- settings (static data that does not change, also placed by middleware)

	- sql (technically, middleware can drop here too)

	- orm, the built-in works fine, but so does other stuff...

	- parse JSON at application

	- make sure application refresh works...

	- parsing of JSON and creation

	- 404 pages need to be pretty and customizable

	- 500 pages need to be pretty and customizable

	- need a way to take things down for maintenance

	- maybe add a way to enable tags? ( a tags folder )
@end


@changelog
	2017/09/07 v0.2 milestone

	2017/09/06
	- Added this comprehensive changelog ;)

	- Shortened conditional code within 'validate()'

	- Moved all private functions to the top

	- Shortened link_text evaluation within 'link()' 

	- Added additional keys in 'data.settings' to control logging:
		logLocation = location of log file, not written yet, but coming soon
		verboseLog  = verbosity of log report?
		addLogLine  = add the currently executing line to the log

	- Fixed a bug within checkArrayOrString that was causing the function
		to return the wrong type when dealing with strings

	- Tested an .htaccess file that redirects all URLS to index.cfm

	- Removed 'jsonToQuery' function.  Seemed kind of useless since it was 
		kind of difficult to make a mock in JSON format out of random data

	- Made a more sensible logging function to allow me to see where things 
		go wrong within coldmvc.cfc


	2017/08/31
	- Added _insert to make it a bit easier to validate
		and bind values when not using an ORM.

	- Merged in Mimetype hash table (search for this.mimes on this page to see it)

	- Added an updated 500 error page:
		it includes all the possible HTTP statuses, but those will be moved to this file later on

	- Converted all other remaining functions written in CFML to cfscript for consistency

	- All other remaining functions, except 'dynquery' - This isn't finished yet

	- Began implementation of a logging feature that can write to other error streams


	2016/09/13
	-	Added a merge function for structs.
		
	-	Also added a way to support dependency injection for page models:
		The skinny is that the init() function will allow you to insert a data
		model (from some outside app most likely, that also speaks CFML)
		and optionally append to or overwrite data within the app that has
		exposed the init() function.

	- Got rid of C source. It'd be a better idea to stick to Java since ColdFusion & Lucee users probably already have it.
			
	- Also made changes to README to be a little more informative and clear on how to get it rolling.


	2016/09/06
	- Updated coldmvc by adding some new functions.
			
	- Updated default application.cfc by turning it into a property.  The cfscript tags that were present in the document previously were causing Lucee to throw an exception.
			
	-	Also added the "base" key to data.json.   A few other keys should be added as well, but this one took priority. Without this key, index.cfm automatically throws a 404 not found error when looking for app and view files besides default.cfm.

	- Checkpoint commit.  coldmvc has a new function called 'jsonToQuery' which converts JSON to a query :)


	2016/09/01
	- Changes on coldmvc will be marked in CHANGELOG.  Added new views and std/ directory for default templates.   Next step is deserializing JSON and creating the site in less steps.
@end

 * -------------------------------------------------- */



/*Define our component here*/
component name = "ColdMVC" {
	/*C-style array to index error messages.  Cleans up a lot*/
	ERR_KEY_NOT_FOUND = 1;

	this.errors = [

	];

	/*VARIABLES - None of these get a docblock. You really don't need to worry with these*/
	this.logString = "";

	this.dumpload = 1;

	this.root_dir = getDirectoryFromPath(getCurrentTemplatePath());

	this.current  = getCurrentTemplatePath();

	//Structs that might be loaded from elsewhere go here (and should really be done at startup)
	this.objects  = { };

	//List of app folder names that should always be disallowed by an HTTP client
	this.arrayconstantmap = [ "app", "assets", "bindata", "db", "files", "sql", "std", "views" ];

	//Path seperator per OS type
	this.pathsep = iif(server.os.name eq "UNIX", de("/"), de("\")); 

	//Defines a list of resources that we can reference without naming static resources
	this.action  = { };

	/*Struct for pre and post functions when generating webpages*/
	this.functions  = StructNew();

	/*A list of self-contained mappings since Application.cfc seems to have myriad issues with this*/
	this.constantmap = {
		"/"           = this.root_dir & "/",
		"/app"        = this.root_dir & "app/",
		"/assets"     = this.root_dir & "assets/",
		"/bindata"    = this.root_dir & "bindata/",
		"/files"      = this.root_dir & "files/",
		"/sql"        = this.root_dir & "sql/",
		"/std"        = this.root_dir & "std/",
		"/templates"  = this.root_dir & "templates/",
		"/views"      = this.root_dir & "views/"
	};


	//<<DOC
	//List of mimetypes for file processing
	//DOC
	this.mimes = {
		 "text/html" = "html", "html" = "text/html"
		,"text/html" = "htm", "htm" = "text/html"
		,"audio/l24" = "l24", "l24" = "audio/l24"
		,"audio/mp3" = "mp3", "mp3" = "audio/mp3"
		,"audio/mp4" = "mp4", "mp4" = "audio/mp4"
		,"audio/opus" = "opus", "opus" = "audio/opus"
		,"audio/vnd.rn-realaudio" = "ra", "ra" = "audio/vnd.rn-realaudio"
		,"audio/vorbis" = "vorbis", "vorbis" = "audio/vorbis"
		,"audio/vnd.wave" = "wav", "wav" = "audio/vnd.wave"
		,"audio/webm" = "webm", "webm" = "audio/webm"
		,"audio/basic" = "ulaw", "ulaw" = "audio/basic"
		,"audio/ogg" = "ogg", "ogg" = "audio/ogg"
		,"audio/flac" = "flac", "flac" = "audio/flac"
		,"application/x-aac" = "aac", "aac" = "application/x-aac"
		,"image/gif" = "gif", "gif" = "image/gif"
		,"image/jpeg" = "jpg", "jpg" = "image/jpeg"
		,"image/jpeg" = "jpg", "jpg" = "image/jpeg"
		,"image/png" = "png", "png" = "image/png"
		,"image/tiff" = "tiff", "tiff" = "image/tiff"
		,"image/svg+xml" = "svg", "svg" = "image/svg+xml"
		,"image/tiff" = "tif", "tif" = "image/tiff"
		,"image/vnd.djvu" = "djvu", "djvu" = "image/vnd.djvu"
		,"image/vnd.microsoft.icon" = "ico", "ico" = "image/vnd.microsoft.icon"
		,"video/avi" = "avi", "avi" = "video/avi"
		,"video/ogg" = "ogt", "ogt" = "video/ogg"
		,"video/quicktime" = "quicktime", "quicktime" = "video/quicktime"
		,"video/x-ms-wmv" = "wmv", "wmv" = "video/x-ms-wmv"
		,"video/x-matroska" = "mk3d", "mk3d" = "video/x-matroska"
		,"video/x-matroska" = "mka", "mka" = "video/x-matroska"
		,"video/x-matroska" = "mks", "mks" = "video/x-matroska"
		,"video/x-matroska" = "mkv", "mkv" = "video/x-matroska"
		,"video/mp4" = "mp4", "mp4" = "video/mp4"
		,"video/x-flv" = "flv", "flv" = "video/x-flv"
		,"application/octet-stream" = "unknown", "unknown" = "application/octet-stream"
		,"application/x-7z-compressed" = "7z", "7z" = "application/x-7z-compressed"
		,"text/vnd.abc" = "abc", "abc" = "text/vnd.abc"
		,"application/vnd.android.package-archive.xul+xml" = "apk", "apk" = "application/vnd.android.package-archive.xul+xml"
		,"text/vnd.a" = "a", "a" = "text/vnd.a"
		,"application/atom+xml" = "atom", "atom" = "application/atom+xml"
		,"application/x-caf" = "caf", "caf" = "application/x-caf"
		,"text/cmd" = "cmd", "cmd" = "text/cmd"
		,"text/css" = "css", "css" = "text/css"
		,"text/csv" = "csv", "csv" = "text/csv"
		,"application/vnd.dart" = "dart", "dart" = "application/vnd.dart"
		,"application/vnd.debian.binary-package" = "deb", "deb" = "application/vnd.debian.binary-package"
		,"application/vnd.ms-word" = "doc", "doc" = "application/vnd.ms-word"
		,"application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "docx", "docx" = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
		,"application/xml-dtd" = "dtd", "dtd" = "application/xml-dtd"
		,"application/x-dvi" = "dvi", "dvi" = "application/x-dvi"
		,"application/ecmascript" = "ecma", "ecma" = "application/ecmascript"
		,"message/partial" = "eml", "eml" = "message/partial"
		,"message/rfc822" = "eml", "eml" = "message/rfc822"
		,"application/gzip" = "gz", "gz" = "application/gzip"
		,"message/http" = "http", "http" = "message/http"
		,"model/iges" = "iges", "iges" = "model/iges"
		,"message/imdn+xml" = "imdn", "imdn" = "message/imdn+xml"
		,"text/javascript" = "javascript", "javascript" = "text/javascript"
		,"application/javascript" = "js", "js" = "application/javascript"
		,"application/json" = "json", "json" = "application/json"
		,"text/javascript" = "js", "js" = "text/javascript"
		,"application/vnd.google-earth.kml+xml" = "kml", "kml" = "application/vnd.google-earth.kml+xml"
		,"application/vnd.google-earth.kmz+xml" = "kmz", "kmz" = "application/vnd.google-earth.kmz+xml"
		,"model/mesh" = "mesh", "mesh" = "model/mesh"
		,"message/rfc822" = "mht", "mht" = "message/rfc822"
		,"message/rfc822" = "mhtml", "mhtml" = "message/rfc822"
		,"message/rfc822" = "mime", "mime" = "message/rfc822"
		,"model/mesh" = "msh", "msh" = "model/mesh"
		,"text/rtf" = "rtf", "rtf" = "text/rtf"
		,"text/plain" = "txt", "txt" = "text/plain"
		,"text/vcard" = "vcard", "vcard" = "text/vcard"
		,"text/xml" = "xml", "xml" = "text/xml"
		,"model/vrml" = "vrml", "vrml" = "model/vrml"
		,"model/vrml" = "wrl", "wrl" = "model/vrml"
		,"application/pdf" = "pdf", "pdf" = "application/pdf"
		,"application/x-pkcs12" = "pkcs", "pkcs" = "application/x-pkcs12"
		,"application/x-pnacl" = "pnacl", "pnacl" = "application/x-pnacl"
		,"application/vnd.ms-powerpoint" = "ppt", "ppt" = "application/vnd.ms-powerpoint"
		,"application/vnd.openxmlformats-officedocument.presentationml.presentation" = "pptx", "pptx" = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
		,"application/postscript" = "ps", "ps" = "application/postscript"
		,"application/x-nacl" = "nacl", "nacl" = "application/x-nacl"
		,"application/vnd.oasis.opendocument.graphics" = "odg", "odg" = "application/vnd.oasis.opendocument.graphics"
		,"application/vnd.oasis.opendocument.presentation" = "odp", "odp" = "application/vnd.oasis.opendocument.presentation"
		,"application/vnd.oasis.opendocument.spreadsheet" = "ods", "ods" = "application/vnd.oasis.opendocument.spreadsheet"
		,"application/vnd.oasis.opendocument.text" = "odt", "odt" = "application/vnd.oasis.opendocument.text"
		,"application/x-rar-compressed" = "rar", "rar" = "application/x-rar-compressed"
		,"application/rdf+xml" = "rdf", "rdf" = "application/rdf+xml"
		,"application/rss+xml" = "rss", "rss" = "application/rss+xml"
		,"application/x-stuffit" = "sit", "sit" = "application/x-stuffit"
		,"application/smil+xml" = "smil", "smil" = "application/smil+xml"
		,"application/soap+xml" = "soap", "soap" = "application/soap+xml"
		,"application/x-shockwave-flash" = "swf", "swf" = "application/x-shockwave-flash"
		,"application/x-tar" = "tar", "tar" = "application/x-tar"
		,"application/x-latex" = "tex", "tex" = "application/x-latex"
		,"application/x-font-ttf" = "ttf", "ttf" = "application/x-font-ttf"
		,"application/font-woff" = "woff", "woff" = "application/font-woff"
		,"application/x-font-woff" = "woff", "woff" = "application/x-font-woff"
		,"application/EDIFACT" = "x", "x" = "application/EDIFACT"
		,"application/EDI-X12" = "x", "x" = "application/EDI-X12"
		,"application/x-xcf" = "xcf", "xcf" = "application/x-xcf"
		,"application/xhtml+xml" = "xhtml", "xhtml" = "application/xhtml+xml"
		,"application/vnd.ms-excel" = "xls", "xls" = "application/vnd.ms-excel"
		,"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "xlsx", "xlsx" = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
		,"application/xml" = "xml", "xml" = "application/xml"
		,"application/xop+xml" = "xop", "xop" = "application/xop+xml"
		,"application/vnd.ms-xpsdocument" = "xps", "xps" = "application/vnd.ms-xpsdocument"
		,"application/vnd.mozilla.xul+xml" = "xul", "xul" = "application/vnd.mozilla.xul+xml"
		,"application/zip" = "zip", "zip" = "application/zip"
	};


	/*VARIABLES - None of these get a docblock. You really don't need to worry with these*/
	//<<DOC
	//Log messages and return true*
	//DOC
	private Boolean function plog (
		String message,      //Message to log
		String loc  //Where to write the message
	 )
	{
		//Open the log file (or database if there is one)
	if ( 0 ) {
		if ( !StructKeyExists( data, "logTo" ) )
			data.logstream = 2; // 2 = stderr, but will realistically write elsewhere...
		else if ( StructKeyExists( data, "logTo" ) ) { 
			//If logTo exists and is a string, then it's a file
			//If logTo exists and is a struct, then check the members and roll from there
			//type can be either "db" or "file", maybe "web" in the future...
			//path is the next parameter, 
			//and datasource should also be there, since cf can't do much without them...
			data.logstream = 3;
		}
		abort;
	}
		
		writeoutput( message ); 
		return true;	
	}


	//Create parameters
	private string function crparam( )
	{
		//string
		urll = "";

		//All of these should be key value structs
		for ( k in arguments )
		{
			for ( kk in arguments[ k ] )
			{
				urll = urll & "v" & hash( kk, "SHA-384", "UTF-8"/*, 1000*/ ) & "=";
				urll = urll & arguments[ k ][ kk ];
			}
		}

		urll = Left( urll, Len(urll) - 1 );
		return urll;
	}


	//@title: hashp
	//@args :
	//@end
	//@body :
	//	Hash function for text strings
	//@end   
	private Struct function hashp( p )
	{
		//Hash pass.username
		puser = hash( p.user, "SHA-384", "UTF-8"/*, 1000*/ );
		//writeoutput( "<br />" & puser );

		//key
		key = generateSecretKey( "AES", 256 );
		//writeoutput( "<br />" & key );

		//Hash password
		ppwd = "";
		ppwd = hash( p.password, "SHA-384", "UTF-8"/*, 1000*/ );

		return {
			user = puser,
			password = ppwd
		};	
	}



	//@title: render_page
	//@args :
	//@end
	//@body :
	//	Hash function for text strings
	//@end   
	private function render_page ( 
		Required String   errorMsg  ,  //Error message
		/*Optional*/ String   errorAddl ,  //Additional error message
		/*Optional*/ Numeric  status    ,  //Status
		/*Optional*/ Boolean  iabort    ,  //Abort after rendered page
		/*Optional*/ String   content   ,  //Add content
		/*Optional*/ stackTrace   //Include a stacktrace
	 )
	{
		err = {};
		a = arguments;
		b = 0;
		if ( !isDefined( "appdata" ) )
			b = false;
		else {
			b = check_deep_key( appdata, "routes", rname, "content-type" );
		}
		v = "std/" & ((b) ? "mime" : "html") & "-view.cfm";

		//Include pages like normal if status is there...
		if ( !StructKeyExists( a, "status" ) )
			include v; 
		else {
			if ( status eq 404 ) {
				status_code = a.status; 
				status_message = "Page Not Found";
				include "std/4xx-view.cfm";
			}
			else {
				status_code = a.status;
				status_message = "Internal Server Error";
				errorLong = ( StructKeyExists( a, "errorAddl" ) ) ? a.errorAddl : "";
				exception = ( StructKeyExists( a, "stackTrace" ) ) ? a.stackTrace : "";
				include "std/5xx-view.cfm";
			}
		}
	}


	
	//@title: logReport 
	//@args :
	//@end
	//@body :
	//	Will silently log as ColdMVC executes
	//@end   
	private function logReport (Required String message) 
	{
		/*
		//Throw an error to get access to the exception 
		line=0; file="";
		try { 
			callFin();
		}
		catch (any e) { 
			template = e.TagContext[ 2 ].template; 
			line = e.TagContext[ 2 ].line; 
		}

		//Append the line number to whatever text is being written
		this.logstring = ( StructKeyExists( this, "addLogLine") && this.addLogLine ) ? "<li>At line " & line & " in template '" & template & "': " & message & "</li>" : "<li>" & message & "</li>";
		(StructKeyExists(this, "verboseLog") && this.verboseLog) ? writeoutput( this.logString ) : 0;
		*/
	}



	//@title: checkArrayOrString
	//@args :
	//@end
	//@body :
	//	Check if a value is an array or string
	//@end   
	private Struct function checkArrayOrString ( 
		Required Struct sarg,  //The struct to check
		Required String key    //The key within the struct to check against
	 )
	{
		//Check if the key exists or not
		if ( !StructKeyExists( sarg, key ) )
			return { status = false, type = false, value = {} };

		//Get the type name
		typename = getMetadata( sarg[key] ).getName(); 

		//Check if the view is a string, an array or an object (except if it's neither) 
		if ( Find( "String", typename ) ) 
			return { status=true, type="string", value=sarg[key] }; 
		else if ( Find( "Struct", typename ) ) 
			return { status=true, type="struct", value=sarg[key] }; 
		else if ( Find( "Array", typename ) ) {
			return { status=true, type="array", value=sarg[key] }; 
		}
	}

	//@title: link 
	//@args :
	//@end
	//@body :
	//	Create links
	//@end   
	public string function link ( /*How do I specify var args???*/ )
	{
		//Define spot for link text
		link_text = "";

		//Base and stuff
		if ( Len(data.base) > 1 || data.base neq "/" )
			link_text = ( Right(data.base, 1) == "/" ) ? Left( data.base, Len( data.base ) - 1 ) : data.base;

		//Concatenate all arguments into some kind of hypertext ref
		for ( x in arguments ) 
			link_text = link_text & "/" & ToString( arguments[ x ] );

		return link_text;
	}



	//@title: crumbs 
	//@args :
	//@end
	//@body :
	//	Create "breadcrumb" link for really deep pages within a webapp. 
	//@end   
	public function crumbs () 
	{
		a = ListToArray(cgi.path_info, "/");
		writedump (a);
		/*Retrieve, list and something else needs breadcrumbs*/
		for (i = ArrayLen(a); i>1; i--) 
		{
			/*If it's a retrieve page, have it jump back to the category*/
			writedump(a[i]);
		}
	}



	//@title: upload_file 
	//@args :
	//@end
	//@body :
	//	Handles file uploads
	//@end   
	public Struct function upload_file (String formField, String mimetype) 
	{
		//Create a file name on the fly.
		fp = this.constantmap["/files"]; 
		fp = ToString(Left(fp, Len(fp) - 1)); 
		
		//Upload it.
		try 
		{	
			a = FileUpload(
				fp,           /*destination*/
				formField,    /*Element from form to write*/
				mimetype,     /*No mimetype limit*/
				"MakeUnique"  /*file name overwrite function*/
			);

			a.fullpath = a.serverdirectory & this.pathsep & a.serverfile;

			return {
				status = true,
				results = a
			};
		}
		//Perhaps this only throws an error on certain file types...
		catch ( coldfusion.tagext.io.FileUtils$InvalidUploadTypeException e )
		{
			return {
				status = false,
				results = e 
			};
		}
		catch ( any e )
		{
			return {
				status = false,
				results = e.message
			};
		}
		
		//Return a big struct full of all file data.
		return a;
	}



	//@title: _include 
	//@args :
	//@end
	//@body :
	//	A better includer
	//@end   
	public function _include (
		Required String where,  Required String name ) 
	{
		//Search through each type to make sure that it's really a valid application endpoint
		match = false;	
		for (x in this.arrayconstantmap)
			if (x == where) match = true;

		//Die with a 500 error if nothing was found.	
		if (!match) 
		{
			render_page(
				status_line = 0,
				status   = 500, 
				abort    = true, 
				errorMsg = ToString("A function requested the page " & name & " in the folder " & 
					this.root_dir & where & ", but that folder does not exist or is not readable by the server user.")
			);
			abort;
		}

		//Include the page and make it work
		include ToString(where & this.pathsep & name & ".cfm");
	}



	//@title: assimilate 
	//@args :
	//@end
	//@body :
	//	Add query content into model
	//@end   
	public Struct function assimilate (
		Required Struct model, Required Query query) 
	{
		_columnNames=ListToArray(query.columnList);
		if (query.recordCount eq 1) {
			for (mi=1; mi lte ArrayLen(_columnNames); mi++) {
				StructInsert(model, LCase(_columnNames[mi]), query[_columnNames[mi]][1], "false");
			}
		}
		return model;
	}


	//@title: isSetNull 
	//@args :
	//@end
	//@body :
	//	Check if a result set is composed of all nulls
	//@end   
	public Boolean function isSetNull (Query q) 
	{
		columnNames=ListToArray(q.columnList);
		if (q.recordCount eq 1) {
			//Check that the first (and only) row is not blank.
			for (ci=1; ci lte ArrayLen(columnNames); ci++)
				if (q[columnNames[ci]][1] neq "") return false;	
		}
		else {
			return false;
		}
		return true;
	}


	//@title: dump_routes 
	//@args :
	//@end
	//@body :
	//	Dump all routes
	//@end   
	public String function dump_routes ( )
	{
		savecontent variable="cms.routeInfo" 
		{ _include ( "std", "dump-view" ); }
		return cms.routeInfo;
	}




	//@title: check_file 
	//@args :
	//@end
	//@body :
	//	Check that a file exists?
	//@end   
	private Boolean function check_file (
		Required String mapping, Required String file) 
	{
		return (FileExists(this.constantmap[ToString("/" & mapping)] & file & ".cfm")) ? 1 : 0;
	}


	//@title: render_page
	//@args :
	//@end
	//@body :
	//	Get database column names
	//@end   
	//@note: 
	//	This breaks in ColdFusion 9
	//@end   
	public String function get_column_names ( Required String table, /*Optional*/ String dbname )
	{
	/*
		fake_name = randStr( 5 );
		noop = "";

		//Save column names to a variable titled 'cn'
		dbinfo datasource=data.source	type="columns" name="cn" table=table;
		writedump( cn );	

		//This should be just one of the many ways to control column name output
		for ( name in cn )
			noop &= cn.column_name;

		return noop;
	*/
	}


	//@title: setQueryField 
	//@args :
	//@end
	//@body :
	//	Add fields to a query very easily
	//@end   
	public function setQueryField (
		Required Query query, Required String columnName, Required Any fillValue, String columnType )
	{
		type=(!StructKeyExists(Arguments, "columnType")) ? "varchar" : Arguments.columnType;
		QueryAddColumn(query, columnName, type, ArrayNew(1));

		/*Add callback support in fillValue...*/
		for (i=1; i <= query.recordCount; i++)
			QuerySetCell(query, columnName, fillValue, i);
	}



	//@title: randstr 
	//@args :
	//@end
	//@body :
	//	A function to generate random letters.
	//@end   
	public String function randstr ( /*Optional*/ Numeric n )
	{
		// make an array instead, and join it...
		str="abcdefghijklmnoqrstuvwxyzABCDEFGHIJKLMNOQRSTUVWXYZ0123456789";
		tr="";
		for (x=1;x<n+1;x++)
			tr = tr & Mid(str, RandRange(1, len(str) - 1), 1);
		return tr;
	}


	//@title: randnum
	//@args :
	//@end
	//@body :
	//	Generate random numbers
	//@end   
	public String function randnum ( /*Optional*/ Numeric n ) 
	{
		// make an array instead, and join it...
		str="0123456789";
		tr="";
		for (x=1;x<n+1;x++)
			tr = tr & Mid(str, RandRange(1, len(str) - 1), 1);
		return tr;
	}



	//@title: make_index 
	//@args :
	//@end
	//@body :
	//	Generate an index
	//@end   
	public function make_index (ColdMVC ColdMVCInstance) 
	{
		//Use global scope for now.  This will be fixed later on.
		variables.coldmvc = ColdMVCInstance;
		variables.model   = StructNew();
		variables.data    = ColdMVCInstance.app;
		variables.db      = ColdMVCInstance.app.data;


		//Find the right resource.
		try 
		{
			//Add more to logging
			logReport("Evaluating URL route");

			//Negotiate search engine safety
			//ses_path = (check_deep_key( appdata, "settings", "ses" )) ? cgi.path_info : cgi.script_name;

			//Set some short names in case we need to access the page name for routing purposes
			variables.data.loaded = 
				variables.data.page = 
											rname = resourceIndex(name=cgi.script_name, ResourceList=appdata);
											//rname = resourceIndex(name=ses_path, ResourceList=appdata);

			//Send a 404 page and be done if this resource was not found.
			if (rname eq "0") 
			{
				render_page(status=404, errorMsg=ToString("Page not found."));
				writedump( variables );
				abort;
			}

			//Load CSS, Javascript and maybe some other stuff once at the beginning
			assets = DeserializeJSON('{
				"js": "\t<script type=text/javascript src=MAGIC></script>\n",
				"css": "\t<link rel=stylesheet type=text/css href=MAGIC />\n"
			}'); 

			//Loop through the data structure above and make things pretty 
			for (key in assets) 
			{
				if (StructKeyExists(appdata, key) && ArrayLen(appdata[key]) > 0) 
				{
					appdata[ToString("rendered_" & key)] = "";
					for (i=1; i<=ArrayLen(appdata[key]); i++) 
					{
						ren = (Left(appdata[key][i], 1) == '/') ? appdata.base & appdata[key][i] : appdata[key][i];
						appdata[ToString("rendered_" & key)] &= Replace(assets[key], "MAGIC", ren);
					}
				}
			}

			logReport( "Success" );
		}
		catch (any e) 
		{
			render_page(
				status  =500, 
				abort   =true, 
				errorMsg=ToString("Locating resource mapping failed"), 
				stackTrace=e
			);
			abort;
		}

		
		//Evaluate the resource in the 'models/' directory or die trying.
		try 
		{
			logReport( "Evaluating URL resource");
			addlError = "";

			//Find an alternate route model first.
			if (check_deep_key(appdata, "routes", rname, "model")) 
			{
				logReport("Evaluate alternative mapped to route name.");

				//Get the type name
				ev = checkArrayOrString( appdata.routes[rname], "model" );

				//Set additional error and serve the page depending on type
				if ( ev.type == "string" )
				{
					addlError = "The file titled '" & ev.value & ".cfm' does not exist in app/";
					_include ( where = "app", name = ev.value );
				}
				else if ( ev.type == "array" )
				{
					for ( x in ev.value ) 
					{
						addlError = "The file titled '" & x & ".cfm' does not exist in app/";
						_include( where ="app", name = x );
					}
				}
				else if ( ev.type == "struct" )
				{
					render_page( 
						status = 500,
						abort  = true,
						errorMsg = "<br />" & 
							"Views as structs are not yet supported.  " &  
							"Please fix your data.json file." 
					);
					abort;
				}
			}
			//Match routes following the convention { "x": {} }
			else if (check_deep_key(appdata, "routes", rname) && StructIsEmpty(appdata.routes[rname]))
			{
				plog( "Evaluate route name." );
				addlError = "The file titled '" & rname & ".cfm' does not exist in app/.";
				_include (where = "app", name = rname); 
			}
		
			//Match the default route	
			else 
			{
				//Check that coldmvc.default() has been defined
				if ( plog( "Evaluating this.default()" ) && structKeyExists(this, "default") )
					this.default();
				else if ( plog( "Evaluating app/default.cfm" ) && check_file("app", "default") )
					_include (where = "app", name = "default"); 
				else 
				{
					render_page(status=500, errorMsg="<p>One of two situations have happened.  " & 
						"Either a:</p><li>default.cfm file was not found in <dir>/app</li><li>" & 
						"or the function 'application.default' is not defined.</li>" );
					abort;
				}
			}
			logReport( "Success");
		}
		catch (any e) 
		{
			//Manually wrap the error template here.
			render_page(
				status     =500, 
				errorAddl  =addlError, 
				errorMsg   =ToString("Error at controller page."), 
				stackTrace =e
			);
			abort;
		}


		//Then parse the template
		try 
		{
			//Try to reorganize all of this so that the conditions stack in a more sensible way
			logReport( "Evaluating view for resource");
			
			//Save content to make it easier to serve alternate mimetypes.
			savecontent variable="cms.content" 
			{
				//Check if something called view exists first	 
				if (check_deep_key(appdata, "routes", rname, "view")) 
				{
					//Get the type name
					ev = checkArrayOrString( appdata.routes[rname], "view" );
					if ( ev.type == "string" )
						_include ( where = "views", name = ev.value );
					else if ( ev.type == "array" )
						for ( x in ev.value ) _include( where ="views", name = x );
					else if ( ev.type == "struct" )
					{
						//This is an exception for now...
						logReport( "<br />Views as structs are not yet supported.  Please fix your data.json file." );
						render_page( 
							status = 500,
							errorMsg = "Views as structs are not yet supported.  Please fix your data.json file."
						);
						abort;
					}
				}
				else if (check_deep_key(appdata, "routes", rname) && StructIsEmpty(appdata.routes[rname]))
				{
					logReport( "Load view with same name as route." );
					_include (where = "views" , name = rname); //& ".cfm"); 
				}
				//Then check if it's blank, and load itself
				else {
					logReport( "Load default route." );
					_include (where = "views", name = "default");
				}
			}
			logReport("Success");
			//render_page(content=cms.content, errorMsg="none");
		}
		catch (any e) {
			render_page(status=500, errorMsg=ToString("Error in parsing view."), stackTrace=e);
			abort;
		}

		// Evaluate any post functions (not sure what these would be yet)
		if (check_deep_key(appdata, "master-post")) 
		{
			if (appdata["master-post"] && !check_deep_key(appdata, "routes", rname, "content-type")) {
				try {
					logReport("Evaluating route for post hook");
					
					//Save content to make it easier to serve alternate mimetypes.
					savecontent variable = "post_content" {
						this.post(cms.content, this.objects);
					}
				
					logReport("Success");
					render_page(content=post_content, errorMsg="none");
				}
				catch (any e) {
					render_page(status=500, errorMsg=ToString("Error in parsing view."), stackTrace=e);
				}
			}
			else {
				render_page(content=cms.content, errorMsg="none");
			}
		}

		else {
			render_page(content=cms.content, errorMsg="none");
		}
	}


	//@title: dynquery 
	//@args :
	//@end
	//@body :
	//	Run a query using file path or text, returning the query via a variable
	//@end   
	public Struct function dynquery ( 
		Optional queryPath,                     //Path to file containing SQL code
		Optional queryText,                     //Send a query via text
		Optional queryDatasource = data.source, //Define a datasource for the new query, default is #data.source#
		Optional debuggable = false,            //Output dumps
		Optional timeout = 100,                 //Stop trying if the query takes longer than this many milliseconds
		Optional timeoutInSeconds = 10,         //Stop trying if the query takes longer than this many seconds
		Optional params                         //Struct or collection of parameters to use when processing query
	 )
	{
		//TODO: This ought to be some kind of template...
		if ( debuggable )
		{
			writedump( queryPath       );
			writedump( queryDatasource );
		}

		//Define the new query
		qd = new Query();
		qd.name = "__results";
		qd.result = "__object";
		qd.datasource = queryDatasource;	

		//...
		try
		{ 
			//Include file
			include queryPath; 

			//Then try a text query...
		}
		catch ( any e )
		{
			//Save the contents of the error message and send that back
			savecontent variable="errMessage" {
				err = cfcatch.TagContext[ 1 ];
				logReport( 
					"SQL execution error at file " & 
					err.template & ", line " & err.Line & "." &
					cfcatch.message
				); 
			}

			return {
				status = 0,
				error  = errMessage,
				object = QueryNew( "nothing" ),
				results= QueryNew( "nothing" )
			};
		}
		
		return {
			status = 1,
			error  = "",
			object = __object,
			results= __results
		};
	}


	//@title: check_deep_key 
	//@args :
	//	Struct Item
	//	String list 
	//@end
	//@body :
	//	Check in structs for elements
	//@end   
	public Boolean function check_deep_key (Struct Item, String list) {
		thisMember=Item;
		nextMember=Item;

		//Loop through each string in the argument list. 
		for (i=2; i <=	ArrayLen(Arguments); i++) {
			//Check if the struct is a struct and if it contains a matching key.
			if (!isStruct(thisMember) || !StructKeyExists(thisMember, Arguments[i]))
				return 0;
			thisMember = thisMember[Arguments[i]];	
		}

		return 1;
	}


	//@title: wrapError 
	//@args :
	//@end
	//@body :
	//	Wrap error messages
	//@end   
	private query function wrapError(e) {
		err = e.TagContext[1];
		structInsert(myRes, 0, "status");
		structInsert(myRes, "Error occurred in file " & e.template & ", line " & e.line & ".", "error");
		structInsert(myRes, e.stackTrace, "StackTrace");
		return myRes;
	}


	//@title: resourceIndex 
	//@args :
	//@end
	//@body :
	//	Find the index of a resource if it exists.  Return 0 if it does not.*/
	//@end   
	private String function resourceIndex (String name, Struct ResourceList) 
	{
		//Define a base here
		base = "";

		//Create an array of the current routes.
		if ( !structKeyExists(ResourceList, "routes") )
			return "default";

		//Handle no routes
		if ( StructIsEmpty(ResourceList.routes) )
			return "default";

		//If there is a base -- ...
		if ( StructKeyExists( ResourceList, "base" ) )
		{
			if ( Len( ResourceList.base ) > 1 )
				base = ResourceList.base;	
			else if ( Len(ResourceList.base) == 1 && ResourceList.base == "/" )
				base = "/";
			else {
				base = ResourceList.base;	
			}
		}

		//Check for resources in GET or the CGI.stringpath 
		if ( StructKeyExists(ResourceList, "handler") && CompareNoCase(ResourceList.handler, "get") == 0 )
		{
			if (isDefined("url") and isDefined("url.action"))
				name = url.action;
			else {
				if (StructKeyExists(ResourceList, "base"))
					name = Replace(name, base, "");
			}
		}
		else {
			//Cut out only routes that are relevant to the current application.
			if (StructKeyExists(ResourceList, "base"))
				name = Replace(name, base, "");
		}

		//Handle the default route if ResourceList is not based off of URL
		if (!StructKeyExists(ResourceList, "handler") && name == "index.cfm")
			return "default";

		//If you made it this far, search for the requested endpoint
		for (x in ResourceList.routes) 
		{
			if (name == x) 
				return x;
			if (Replace(name, ".cfm", "") == x)
				return x;
			//Replace the base
		}

		//You probably found nothing, so either do 404 or some other stuff.
		return ToString(0);
	}

	//@title: login 
	//@args :
	//@end
	//@body :
	//	Handle basic login
	//@end   
	public function login ( )
	{
		//Zero cookies...
		getPageContext().getResponse().addHeader( 
			"Set-Cookie", "#data.cookie#=0; path=/; " &
			"domain=#listFirst(CGI.HTTP_HOST, ':' )#;HTTPOnly"); 

		//Lock and clear the sessionObject
		lock scope='session' timeout=10 {	
			;//session.sessionObj = createObject( "component", "model.beans	
		}
	}


	//@title: execQuery 
	//@args :
	//	String qf = 
	//	Boolean qf = 
	//@end
	//@body :
	//	Hash function for text strings.  Function returns a query.  NULL if nothing...
	//@end   
	public function execQuery (String qf, Boolean dump) 
	{
		/*Check for the existence of the file we're asking for*/
		var template = qf & ".cfm";

		/*Debugging info*/
		//writeoutput("<br />" & template);
		//writeoutput("<br />" & expandPath(template));

		/*
		// Check that the file exists.
		if (!FileExists(expandPath(template))) {
			var a = QueryNew("File_does_not_exist");
			return a;
			// use struct and return it ...
		}
		*/

		/*A function can move through each of the Arguments and tell you what was passed*/
		if (dump == true) {
			for (x in Arguments) 
				writeoutput("<li>" & x & " => " & Arguments[x] & "</li>");
		}
		
		/*Run the query and cache any failures*/
		var sql = dynquery(template, Arguments);
		//Include template; writeDump(#__query#);writeDump(#__results#);

		/*Most of the errors have been handled.  You just need to let the user know it failed*/
		if (sql.status == False) { ; }
		if (dump == True)
			writedump(sql);
		
		return sql;
	}


	//Return formatted error strings
	//TODO: More clearly specified that this function takes variables arguments
	private Struct function strerror ( code ) {
		argArr = [];
		errors = {
			 errKeyNotFound = "Required key '%s' does not exist."
			,errValueLessThan = "Value of key '%s' fails -lt (less than) test."
			,errValueGtrThan = "Value of key '%s' fails -gt (greater than) test."
			,errValueLtEqual= "Value of key '%s' fails -lt (less than or equal to) test."
			,errValueGtEqual = "Value of key '%s' fails -gte (greater than or equal to) test."
			,errValueEqual = "Value of key '%s' fails -eq (equal to) test."
			,errValueNotEqual = "Value of key '%s' fails -neq (not equal to) test."
			,errFileExtMismatch = "The extension of the submitted file '%s' does notmatch the expected mimetype for this field."
			,errFileSizeTooLarge = "Size of field '%s' (%d bytes) is larger than expected size %d bytes."
			,errFileSizeTooSmall = "Size of field '%s' (%d bytes) is smaller than expected size %d bytes."
		};

		for ( arg in arguments ) {
			if ( arg != 'code' ) {
				//Do an explicit cast here if need be... 
				//(get type...)
				//ArrayAppend( argArr, javacast( arguments[arg], type ) );
				ArrayAppend( argArr, arguments[arg] );
			}
		}
	
		str = createObject("java","java.lang.String").format( errors[code], argArr );

		return {
			status = false,
			message = str 
		};
	}	


	//A quick set of tests...
	public function validateTests( ) {
		// These should all throw an exception and stop
		// req
		// req + lt	
		// req + gt	
		// req + lte
		// req + gte
		// req + eq	
		// req + neq 
		
		// These should simply discard the value from the set
		// An error string can be set to log what happened.
		// lt	
		// gt	
		// lte
		// gte
		// eq	
		// neq 

	}

	//Check a struct for certain values by comparison against another struct
	public function cmValidate ( cStruct, vStruct ) {
		s = StructNew();
		s.status = true;
		s.message = "";

		//Results are where things should go...
		s.results = StructNew();

		//Loop through each value in v
		for ( key in vStruct ) {
			//Short names
			vk = vStruct[ key ];

			//If key is required, and not there, stop
			if ( structKeyExists( vk, "req" ) ) {
				if ( (!structKeyExists( cStruct, key )) && (vk[ "req" ] eq true) ) {
					return strerror( 'errKeyNotFound', key );
				}
			}

			//No use moving forward if the key does not exist...
			if ( !structKeyExists( cStruct, key ) ) {
				//Use the 'none' key to set defaults on values that aren't required
				if ( StructKeyExists( vk, "ifNone" ) ) {
					s.results[ key ] = vk[ "ifNone" ];	
				} 
				continue;
			}
 
			//Set this key
			ck = cStruct[ key ];

			//Less than	
			if ( structKeyExists( vk, "lt" ) ) {
				//Check types
				if ( !( ck lt vk["lt"] ) ) {
					return strerror( 'errValueLessThan', key );
				}	
			} 

			//Greater than	
			if ( structKeyExists( vk, "gt" ) ) {
				if ( !( ck gt vk["gt"] ) ) {
					return strerror( 'errValueGtrThan', key );
				}	
			}

			//Less than or equal 
			if ( structKeyExists( vk, "lte" ) ) {
				if ( !( ck lte vk["lte"] ) ) {
					// return { status = false, message = "what failed and where at?" }
					return strerror( 'errValueLtEqual', key );
				}	
			} 

			//Greater than or equal
			if ( structKeyExists( vk, "gte" ) ) {
				if ( !( ck gte vk["gte"] ) ) {
					return strerror( 'errValueGtEqual', key );
				}	
			}
	 
			//Equal
			if ( structKeyExists( vk, "eq" ) ) {
				if ( !( ck eq vk["eq"] ) ) {
					return strerror( 'errValueEqual', key );
				}	
			}
	 
			//Not equal
			if ( structKeyExists( vk, "neq" ) ) {
				if ( !( ck neq vk["neq"] ) ) {
					return strerror( 'errValueNotEqual', key );
				}	
			} 

			//This is the lazy way to do this...
			s.results[ key ] = ck;

			//Check file fields
			if ( structKeyExists( vk, "file" ) ) {
				//For ease, I've added some "meta" types (image, audio, video, document)
				meta_mime  = {
					image    = "image/jpg,image/jpeg,image/pjpeg,image/png,image/bmp,image/gif",
					audio    = "audio/mp3,audio/wav,audio/ogg",
					video    = "",
					document = "application/pdf,application/word,application/docx"
				};

				meta_ext   = {
					image    = "jpg,jpeg,png,gif,bmp",
					audio    = "mp3,wav,ogg",
					video    = "webm,flv,mp4,",
					document = "pdf,doc,docx"
				};	

				acceptedMimes = 0;
				acceptedExt = 0;

				//Most exclusive, just support certain mime types
				//(Array math could allow one to build an extension filter)
				if ( structKeyExists( vk, "mimes" ) )
					acceptedMimes = vk.mimes;
				//No mimes, ext or type were specified, so fallback
				else if ( !structKeyExists( vk, "type" ) )
					acceptedMimes = "*";
				else if ( structKeyExists( vk, "ext" ) ) {
					acceptedMimes = "*";
					acceptedExt = vk.ext;
				}	
				//Assume that type was specified
				else {
					acceptedMimes = structKeyExists( meta_mime, vk.type ) ? meta_mime[ vk.type ] : "*";
					acceptedExt = structKeyExists( meta_ext, vk.type ) ? meta_ext[ vk.type ] : 0;
				}
			
				//Upload the file
				file = _upload_file( ck, acceptedMimes );

				if ( file.status ) {
					//Check extensions if acceptedMimes is not a wildcard
					if ( acceptedExt neq 0 ) {
						if ( !listFindNoCase( acceptedExt, file.results.serverFileExt ) ) {
							//Remove the file
							FileDelete( file.results.fullpath );
							return strerror( 'errFileExtMismatch', file.results.serverFileExt );
						}
					} 

					//Check expected limits ( you can even block stuff from a value in data.json )
					if ( structKeyExists( vk, "sizeLt" ) && !( file.results.oldfilesize lt vk.sizeLt ) ) {
						FileDelete( file.results.fullpath );
						return strerror( 'errFileSizeTooLarge', key, file.results.oldfilesize, vk.sizeLt );
					} 

					if ( structKeyExists( vk, "sizeGt" ) && !( file.results.oldfilesize gt vk.sizeGt ) ) {
						FileDelete( file.results.fullpath );
						return strerror( 'errFileSizeTooSmall', key, file.results.oldfilesize, vk.sizeLt );
					} 
				}
				s.results[ key ] = file.results; 
			}
		}
		return s;
	}


	//@title: render_page
	//@args :
	//	v = ...
	//@end
	//@body :
	//	Add to database without anything complex
	//@end   
	function _insert ( v )
	{
		//Define stuff
		datasource = "";
		qstring    = "";
		stmtName   = "";

		//Always pull the query first, failing if there is nothing
		if ( StructKeyExists( v, "query" ) && v[ "query" ] eq "" )
			qstring = v.query;
		else {
			return { 
				status = false, 
				message = "no query string specified." 
			};
		}

		//Data source
		if ( !structKeyExists( v, "datasource" ) )
			datasource = data.source;
		else {
			datasource = v.datasource;
			StructDelete( v, "datasource" );
		}

		if ( datasource eq "" )
		{
			return { 
				status = false, 
				message = "no data source specified." 
			};
		}

		//Name
		if ( !structKeyExists( v, "stmtname" ) )
			stmtName = "myQuery";
		else {
			stmtName = v.stmtname;
			StructDelete( v, "stmtname" );
		}

		//Create a new query and add each value (in the proper order OR use an "alphabetical" bind)
		structDelete( v, "query" );

		try 
		{
			qs = new Query();
			qs.setSQL( qstring );

			//The BEST way to do this is check the string for ':null', ':random', and ':date'
			/*
			for ( vv in v ) 
			{
				writeoutput( vv );	
				if ( structKeyExists( v[vv], "null" ) )
					qs.addParam( name = vv, null = true );
				else if ( structKeyExists( v[vv], "null" ) )
					qs.addParam( name = vv, null = true );
			}
			*/

			//The other way to do this is to check keys within the struct  (this is long and sucks...)
			for ( vv in v ) 
			{
				if ( structKeyExists( v[vv], "null" ) )
					qs.addParam( name = vv, null = true );
				else if ( structKeyExists( v[vv], "random" ) )
					qs.addParam( name = vv, value = randstr(32), cfsqltype = "varchar" );
				else if ( structKeyExists( v[vv], "date" ) )
					qs.addParam( name = vv, value = Now(), cfsqltype = "timestamp" );
				else if ( structKeyExists( v[vv], "value" ) )
					qs.addParam( name = vv, value = v[vv].value, cfsqltype = v[vv].cfsqltype );
			}

			//
			qs.setName( stmtName );
			qs.setDatasource( data.source ); 
			rs = qs.execute( );

			return {
				status = true,
				results = rs
			};
		}
		catch (any e)
		{
			writedump( e );
			return {
				status = false,
				results = e.message
			};
		}
	}

	/*checkBindType = Checks how arguments are bound to one another.*/
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


	public function dbExec ( String datasource = "#data.source#", String filename, String string, bindArgs ) 
	{
		//Set some basic things
		Name = "query";
		SQLContents = "";

		//Check for either string or filename
		if ( !StructKeyExists( arguments, "filename" ) && !StructKeyExists( arguments, "string" ) ) {
			return { 
				status= false, 
				message= "Either 'filename' or 'string' must be present as an argument to this function."
			};
		}

		//Make sure data source is a string
		if ( !IsSimpleValue( arguments.datasource ) )
			return { status= false, message= "The datasource argument is not a string." };

		if ( arguments.datasource eq "" )
			return { status= false, message= "The datasource argument is blank."};

		//Then check and process the SQL statement
		if ( StructKeyExists( arguments, "string" ) ) {
			if ( !IsSimpleValue( arguments.string ) )
				return { status= false, message= "The 'string' argument is neither a string or number." };

			Name = "_anonymous";
			SQLContents = arguments.string;
		}
		else {
			//Make sure filename is a string (or something similar)
			if ( !IsSimpleValue( arguments.filename ) )
				return { status= false, message= "The 'filename' argument is neither a string or number." };

			//Get the file path.	
			fp = this.constantmap[ "/sql" ] & "/" & arguments.filename;
			//return { status= false, message= "#current# and #root_dir#" };

			//Check for the filename
			if ( !FileExists( fp ) )
				return { status= false, message= "File " & fp & " does not exist." };

			//Get the basename of the file
			Base = find( "/", arguments.filename );
			if ( Base ) {
				0;	
			}

			//Then get the name of the file sans extension
			Period = Find( ".", arguments.filename );
			Name = ( Period ) ? Left(arguments.filename, Period - 1 ) : "query";

			//Read the contents
			SQLContents = FileRead( fp );
/*
			//Finally, CFML code could be in there.  Evaluate it.
			try {
			SQLContents = Evaluate( SQLContents );
			}
			catch (any ee) {
				return { 
					status = false
				 ,message = "#ee#"
				 ,results = {}
				};
			}
			writedump( SQLContents ); abort;
*/
		}

		//Set up a new Query
		q = new Query( datasource="#arguments.datasource#" );	
		q.setname = "#Name#";
		//q.setdatasource = arguments.datasource;

		//If binds exist, do the binding dance 
		if ( StructKeyExists( arguments, "bindArgs" ) ) {
			if ( !IsStruct( arguments.bindArgs ) ) 
				return { status= false, message= "Argument 'bindArgs' is not a struct." };

			for ( n in arguments.bindArgs ) {
				value = arguments.bindArgs[n];
				type = "varchar";
				if ( IsSimpleValue( value ) ) {
					try {__ = value + 1; type = "integer";}
					catch (any e) { type="varchar";}
				}
				else if ( IsStruct( value ) ) {
					v = value;
					if ( !StructKeyExists( v, "type" ) || !IsSimpleValue( v["type"] ) )
						return { status = false, message = "Key 'type' does not exist in 'bindArgs' struct key '#n#'" };	
					if ( !StructKeyExists( v, "value" ) || !IsSimpleValue( v["value"] ) ) 
						return { status = false, message = "Key 'value' does not exist in 'bindArgs' struct key '#n#'" };	
					type  = v.type;
					value = v.value;
				}
				else {
					return { 
						status = false, 
						message = "Each key-value pair in bindArgs must be composed of structs."
					};
				}
				q.addParam( name=LCase(n), value=value, cfsqltype=type );
			}
		}

		//Execute the query
		try { rr = q.execute( sql = SQLContents ); }
		catch (any e) {
			return { 
				status  = false,
			  message = "Query failed. #e.message# - #e.detail#."
			};
		}

		//Put results somewhere.
		resultSet = rr.getResult();

		//Return a status
		return {
			status  = true
		 ,message = "SUCCESS"
		 ,results = ( !IsDefined("resultSet") ) ? {} : resultSet
		 ,prefix  = rr.getPrefix()
		};
	}


	//@title: init
	//@args :
	//	Struct Appscope = ...
	//@end
	//@body :
	//	Initialize ColdMVC
	//@end   
	public ColdMVC function init (Struct appscope) 
	{
		//Add pre and post
		if (StructKeyExists(appscope, "post"))
			this.post = appscope.post;
		if (StructKeyExists(appscope, "pre"))
			this.pre = appscope.pre;
		if (StructKeyExists(appscope, "objects")) {
			for (x in appscope.objects) {
				StructInsert(this.objects, x, appscope.objects[x]);
			}
		}

		//Now I can just run regular stuff
		try {
			logReport( "Loading data.cfm..." );
			include "data.cfm";
			appdata = manifest;
			//appdata = CreateObject( "component", "data" );
			logReport( "Success" );
		}
		catch (any e) {
			render_page(status=500, errorMsg="Deserializing data.cfm failed", stackTrace=e);
			abort;
		}


		//Check that JSON manifest contains everything necessary.
		keys = { 
			_required = [
				 "base" 
				,"routes"    ],
			_optional = [
				 "addLogLine"
				,"verboseLog"
				,"logLocation" 
			]
		};

		for ( key in keys._required )
		{
			rname = "";
			if ( !StructKeyExists( appdata, key  ) )
			{
				render_page( status = 500, abort = true, errorMsg =
					"<h2>Struct key '"& key &"' not found in data.json!</h2>" );
				abort;
			}
		}

		if ( StructKeyExists( appdata, "settings" ) ) 
			for ( key in keys._optional )
				this[key] = (StructKeyExists(appdata.settings, key)) ? appdata.settings[ key ] : false;

		this.app = appdata;	
		return this;
	}

} /*end component declaration*/
</cfscript>
