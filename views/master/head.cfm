<cfoutput>
<html>
<head>
	<!-- Seems like other metas ought to be needed -->
	<title>#data.title#</title>

	<!--- All the CSS files --->
	<link rel="stylesheet" href="#link( 'assets/css/zero.css' )#">
	<!--- 
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> 
	<link rel="stylesheet" href="#link( 'assets/css/modals.css' )#">
	--->
	<link href="https://fonts.googleapis.com/css?family=Open+Sans+Condensed:300|Montserrat|Poppins|Ropa+Sans" rel="stylesheet">

	<!---
	<link rel="stylesheet" href="#link( 'assets/css/c3.min.css' )#">
	<link rel="stylesheet" href="#link( 'assets/css/chart.css' )#">
	--->
	<link rel="stylesheet" href="#link( 'assets/css/bootstrap.min.css' )#">
	<link rel="stylesheet" href="#link( 'assets/css/sliders.css' )#">
	<link rel="stylesheet" href="#link( 'assets/css/toggler.css' )#">
	<link rel="stylesheet" href="#link( 'assets/css/checkbox-radio.css' )#">
	<link rel="stylesheet" href="#link( 'assets/css/mobileselect.css' )#">
	<link rel="stylesheet" href="#link( 'assets/css/default.css' )#">

	<!--- All the Javascript files --->
	<!---
	<script src="https://d3js.org/d3.v3.js" type="text/javascript"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js" type="text/javascript"></script>
	<script src="#link( 'assets/js/libs/c3.min.js'  )#" type="text/javascript"></script>
	<script src="#link( 'assets/js/libs/handlebars-v4.0.11.js'  )#" type="text/javascript"></script>
	<script src="#link( 'assets/js/libs/swipesensejs.js'  )#" type="text/javascript"></script>
	<script src="#link( 'assets/js/libs/bootstrap.min.js'  )#" type="text/javascript"></script>
	--->

	<script src="#link( 'assets/js/libs/mobileselect.js'  )#" type="text/javascript"></script>
	<script src="#link( 'assets/js/libs/sliders.js'  )#" type="text/javascript"></script>
	<!--- 
	<script src="#link( 'assets/js/libs/modal.js'  )#" type="text/javascript"></script>
	<script src="#link( 'assets/js/libs/touch.js'  )#" type="text/javascript"></script> 
	<script src="#link( 'assets/js/libs/routex.js'  )#" type="text/javascript"></script>
	--->
	<script src="#link( 'assets/js/proc/debug.js'  )#" type="text/javascript"></script>
	<!--- <script src="#link( 'assets/js/proc/indy.js'  )#" type="text/javascript"></script> --->
	<script src="#link( 'assets/index.js'  )#" type="text/javascript"></script>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js" type="text/javascript"></script>
	<script src="#link( 'assets/bootstrap.js' )#" type="text/javascript"></script>


	<!--- iPad Stuff --->
	<meta http-equiv="content-type" content="text/html; charset=utf-8">

	<!--- iPad Setup --->
	<meta name="viewport" content="minimum-scale=1.0, maximum-scale=1.0, width=device-width, user-scalable=no">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">

	<!--- Reset iPad touch event data --->	
	<script type="text/javascript">
		// TOUCH-EVENTS SINGLE-FINGER SWIPE-SENSING JAVASCRIPT - Courtesy of PADILICIOUS.COM and MACOSXAUTOMATION.COM
		var fingerCount = 0;
		var startX = 0;
	</script>
</head>

<body>

	<div class="persistent-nav">
		<a href="#data.redirectHome#">Back to MoTrPAC</a>
		<a href="#link( "input.cfm" )#">Home</a>
		<a href="#link( "default.cfm" )#">Participant List</a>
	<!---
		<a href="#link( "save.cfm" )#">Save Session</a>
		<a href="#link( "logout.cfm" )##iif( isDefined( 'staffId' ), DE('?staffid=#staffId#'), "" )#">Logout</a>
	--->
		<a href="#link( "staff.cfm" )#">Assigned Participant List</a>
	<cfif data.debug eq 1>
		<a style="color:red" href="#link( "logout-all.cfm?siteid=" & siteId )#">Logout All</a>
		<style type="text/css">
		.persistent-nav-hideme {
			display: inline-block;
			position: absolute;
			z-index: 99;
			right: 30px;
			top: -10px;
			padding: 10px;
			transition: display 0.2s;
			background: ##eee;
		}
		.persistent-nav-hideme li {
			display:none;
		}
		.persistent-nav-hideme li:nth-child(0) {
			display:block;
		}
		.persistent-nav-hideme:hover li {
			display:block;
		}
		</style>
		<!--- This should be debuggable too --->
		<!--- The links here... --->
		<cfquery name="ittybitty" datasource="#data.source#">
			SELECT * FROM #data.data.staff# WHERE ts_siteid = <cfqueryparam value=#cs.siteid# cfsqltype="CF_SQL_NUMERIC"> 
		</cfquery>
		<ul class="persistent-nav-hideme">
			#DateTimeFormat( cdate, "yyyy/mm/dd" )#
		<!---	
			Login As Another Member
			<cfif isDefined("url.date")><cfset mdss="&date=#url.date#"><cfelse><cfset mdss=""></cfif>
		<cfloop query="ittybitty">
			<li><a href="#link( 'default.cfm?staffid=' & ts_staffguid & mdss )#">Login as #ts_staffguid#</a></li>
		</cfloop>
			--->
		</ul>
	</cfif>
	</div>

	<div class="container">
</cfoutput>
