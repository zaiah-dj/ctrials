<cfoutput>
<html>
<head>
	<!-- Seems like other metas ought to be needed -->
	<title>#data.title#</title>

	<!--- All the CSS files --->
<cfloop array=#data.css# index="cssFile">
	<cfif (Left(cssFile,4) eq "http") or (Left(cssFile,5) eq "https")>
	<link rel="stylesheet" href="#cssFile#"> 
	<cfelseif not data.debug and (cssFile eq "debug.css")>
	<cfelse>
	<link rel="stylesheet" href="#link( "assets/css/" & cssFile )#"> 
	</cfif>
</cfloop>

	<!--- All the Javascript files --->
<cfloop array=#data.js# index="jsFile">
	<cfif (Left(jsFile,4) eq "http") or (Left(jsFile,5) eq "https")>
	<script src="#jsFile#" type="text/javascript"></script>
	<cfelseif not data.debug and (jsFile eq "proc/debug.js")>
	<cfelse>
	<script src="#link( "assets/js/" & jsFile )#" type="text/javascript"></script>
	</cfif>
</cfloop>


	<!--- iPad Stuff --->
	<meta http-equiv="content-type" content="text/html; charset=utf-8">

	<!--- iPad Setup --->
	<meta name="viewport" content="minimum-scale=1.0, maximum-scale=1.0, width=device-width, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

	<!--- Reset iPad touch event data --->	
	<script type="text/javascript">
		// TOUCH-EVENTS SINGLE-FINGER SWIPE-SENSING JAVASCRIPT
		// Courtesy of PADILICIOUS.COM and MACOSXAUTOMATION.COM
		var fingerCount = 0;
		var startX = 0;
	</script>
</head>

<body>

	<div class="persistent-nav">
		<a href="/motrpac/web/secure/dataentry">Back to MoTrPAC</a>
		<a href="#link( "default.cfm" )#">Select</a>
		<!---<a href="#link( "save.cfm" )#">Save Session</a>--->
	<cfif isDefined( "staffId" )>
		<a href="#link( "logout.cfm?staffid=" & staffId )#">Logout</a>
	<cfelse>
		<a href="#link( "logout.cfm" )#">Logout</a>
	</cfif>
		<a href="#link( "input.cfm" )#">Input</a>
		<a href="#link( "staff.cfm" )#">Staff</a>
	<cfif data.debug eq 1>
		<div style="float: right;">
			<a href="#link( "logout.cfm?staffid=" & staffId )#">Super Logout</a>
		</div>
	</cfif>
	</div>

	<div class="container">
</cfoutput>
