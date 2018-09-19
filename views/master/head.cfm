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
		<div class="persistent-nav-left">
			<a href="#data.redirectHome#"><li>Back to MoTrPAC</li></a>
			<!---<a>#DateTimeFormat(cdate,"mm/dd/YYYY")# #DateTimeFormat(cdate,"hh:nn:ss")#</a>--->
		</div>

		<div class="persistent-nav-center">
			<a href="#link( "input.cfm" )#"><li>Home</li></a>
			<a href="#link( "default.cfm" )#"><li>Participants</li></a>
			<a href="#link( "staff.cfm" )#"><li>Assignments</li></a>
		</div>

		<div class="persistent-nav-right">
			<a href="#link( "" )#"><li>Notifications</li></a>
			<a href="#link( "" )#"><li>Username001</li></a>
		</div>
	</div>

	<div class="container">
</cfoutput>
