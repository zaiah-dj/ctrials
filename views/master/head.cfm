<cfoutput>
<html>
<head>
	<!-- Seems like other metas ought to be needed -->
	<title>#data.title#</title>

	<!--- All the CSS files --->
<cfloop array=#data.css# index="cssFile">
	<cfif (Left(cssFile,4) eq "http") or (Left(cssFile,5) eq "https")>
	<link rel="stylesheet" href="#cssFile#"> 
	<cfelse>
	<link rel="stylesheet" href="#link( "assets/css/" & cssFile )#"> 
	</cfif>
</cfloop>

	<!--- All the Javascript files --->
<cfloop array=#data.js# index="jsFile">
	<cfif (Left(jsFile,4) eq "http") or (Left(jsFile,5) eq "https")>
	<script src="#jsFile#" type="text/javascript"></script>
	<cfelse>
	<script src="#link( "assets/js/" & jsFile )#" type="text/javascript"></script>
	</cfif>
</cfloop>

	<cfif data.debug eq 1>
	<!-- CSS Debug stylesheet -->
	<link rel="stylesheet" href="#link( "assets/debug.css" )#">
	<script type="text/javascript" src="#link("assets/debug.js")#"></script>
	</cfif>

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
	<cfif data.debug eq 1>
<!---
	<div class="debug" id="mega-debug">
		<button class="op">open</button>
		<button class="cl">close</button>
		<cfinclude template="../tests/dumply.cfm">
	</div><!--- class="debug" id="mega-debug" --->
--->
	</cfif>	

	<cfif data.debug eq 1>
		<div class="debug2">#sess.key# - #sess.status#</div>
	</cfif>

	<div class="persistent-nav">
		<a href="/motrpac/web/secure/dataentry">Back to MoTrPAC</a>
		<a href="#link( "default.cfm" )#">Select</a>
		<!---<a href="#link( "save.cfm" )#">Save Session</a>--->
		<a href="#link( "logout.cfm" )#">Logout</a>
		<a href="#link( "input.cfm" )#">Input</a>
	</div>

	<div class="container">
</cfoutput>
