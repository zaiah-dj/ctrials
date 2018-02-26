<cfoutput>
<html>
<head>
	<link rel="stylesheet" href="#link( "assets/zero.css" )#">
	<link rel="stylesheet" href="#link( "assets/default.css" )#">
	
	<!-- Bootstrap: Latest compiled and minified CSS -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

	<!-- C3 css -->
	<link rel="stylesheet" href="#link( "assets/css/c3.min.css" )#">

	<!-- C3.js - Easy charts -->
	<script src="https://d3js.org/d3.v3.js"></script>       <!-- D3.js is a dependency -->
	<script src="#link( "assets/js/c3.min.js" )#"></script>

	<!-- jQuery library -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

	<!-- Latest compiled JavaScript -->
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="#link("assets/index.js")#"></script>
</head>

<body>
</cfoutput>

<style type="text/css">
ul.participant-info-nav li {
	display: inline-block; width: 200px;	
	text-align: center;
	transition: 
		background-color 0.2s,
		color 0.2s;
	;
}

ul.participant-info-nav li:hover {
	background-color: green;	
	color: white;	
}
</style>

<div class="container">
