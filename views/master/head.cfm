<cfoutput>
<html>
<head>
	<!-- Seems like other metas ought to be needed -->
	<title>#data.title#</title>

	<!-- All CSS and whatnot -->
	<link rel="stylesheet" href="#link( "assets/zero.css" )#">
	
	<!-- custom fonts -->	
	<link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet">

	<!-- Bootstrap: Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

	<!-- C3 css -->
	<link rel="stylesheet" href="#link( "assets/css/c3.min.css" )#">

	<!-- My chart styles --> 
	<link rel="stylesheet" href="#link( "assets/chart.css" )#">

	<!-- My styles -->
	<link rel="stylesheet" href="#link( "assets/default.css" )#">

<!--[if gte IE 9]>
	<link rel="stylesheet" href="#link( "assets/default-ie.css" )#">
<![endif]-->

	<!-- D3.js - Needed by c3 below -->
	<script src="https://d3js.org/d3.v3.js"></script>       <!-- D3.js is a dependency -->
	<!-- C3.js - Easy charts -->
	<script src="#link( "assets/js/c3.min.js" )#"></script>

	<!-- jQuery library -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

	<!-- Latest compiled JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

	<!-- iPad JS -->
	<script type="text/javascript" src="#link("assets/js/swipesensejs.js")#"></script>
	
	<!-- Drag and Drop JS -->
	<script type="text/javascript" src="#link("assets/js/droppable.js")#"></script>

	<!-- Our JS -->
	<script type="text/javascript" src="#link("assets/index.js")#"></script>

	<cfif data.debug eq 1>
	<!-- CSS Debug stylesheet -->
	<link rel="stylesheet" href="#link( "assets/debug.css" )#">
	<script type="text/javascript" src="#link("assets/debug.js")#"></script>
	</cfif>

	<!-- iPad Stuff -->
	<meta http-equiv="content-type" content="text/html; charset=utf-8">

	<!-- iPad Setup -->
	<meta name="viewport" content="minimum-scale=1.0, maximum-scale=1.0, width=device-width, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

	<!-- Reset iPad touch event data -->	
	<script type="text/javascript">
		// TOUCH-EVENTS SINGLE-FINGER SWIPE-SENSING JAVASCRIPT
		// Courtesy of PADILICIOUS.COM and MACOSXAUTOMATION.COM
		var fingerCount = 0;
		var startX = 0;
	</script>

</head>

<body>

	<cfif data.debug eq 1>
	<div class="debug" id="mega-debug">
		<button class="op">open</button>
		<button class="cl">close</button>
		<cfinclude template="../dumply.cfm">
	</div><!--- class="debug" id="mega-debug" --->
	</cfif>	

	<div class="persistent-nav">
		<a href="/motrpac/web/secure/dataentry">Back to Motrpac</a>
		<a href="#link( "logout.cfm" )#">Logout</a>
		<a href="#link( "save.cfm" )#">Save Session</a>
	</div>

	<div class="container">
</cfoutput>
