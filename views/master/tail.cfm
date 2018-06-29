</body>
<cfif data.debug eq 1>
<cfoutput>
<style type="text/css">
.cfdebug {
	width: 50%;
	max-height: 50%;
	min-width: 200px;
	height: auto;
	color: white;
	display: block;
	min-height: 30px;
	background-color: blue;
	opacity: 0.7;
	position: fixed;
	z-index: 99;
	right: 30px;
	bottom: 0%;
	padding: 10px;
	overflow: auto;
}
.cfdebug table { color: white; }
.cfdebug table.td {	padding-right: 10px; }
.cfdebug table th {	background-color: white; color: black; }
</style>
<script>
	document.addEventListener("DOMContentLoaded",function(ev) {
		b={};
		b.dn = document.getElementById("cfdebug");
		b.ex = document.createElement( "button" );
		b.ex.innerHTML = "X";
		b.ex.fontSize = "20px";
		b.ex.style.color = "black";
		b.ex.style.position = "absolute";
		b.ex.style.top = "0px";
		b.ex.style.right = "0px";
		b.ex.style.width = "40px";
		b.hy = document.createElement( "button" );
		b.hy.innerHTML = "_";
		b.hy.fontSize = "20px";
		b.hy.style.color = "black";
		b.hy.style.position = "absolute";
		b.hy.style.right = "40px";
		b.hy.style.top = "0px";
		b.hy.style.width = "40px";
		b.clicked = 0;
		b.hy.addEventListener( "click", function (ev) { 
			b.dn.style.height = ( !b.clicked ) ? "20px" : "200px"; 
			b.hy.innerHTML    = ( !b.clicked ) ? "+" : "_"; 
			b.clicked   = ( !b.clicked ) ? 1 : 0; 
		} );
		b.dn.appendChild( b.ex );
		b.dn.appendChild( b.hy );
	});
</script>
<style type="text/css">table.cfdump_struct { color: black; }</style>
<div class="cfdebug" id="cfdebug">
	<table>
	<th>Session</th>
	<tr><td>Session Data:</td><td>#sess.key#</td></tr>
	<tr><td>Session Status:</td><td>#sess.status#</td></tr>
	<!---
	<tr><cfdump var = #session#></tr>
		--->
	<!---
		--->
	<tr><cfdump var = #session#></tr>
	</table>
</div>
<div id="sessionKey" style="display:none">#sess.key#</div>
</cfoutput>
</cfif>
<footer>
</footer>
</html>
