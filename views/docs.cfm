<cfoutput>
<!---
<link rel=stylesheet href="#link( 'assets/zero.css' )#">
<link rel=stylesheet href="#link( 'assets/default.css' )#">
<link rel=stylesheet href="#link( 'assets/docs.css' )#">
--->
</cfoutput>
<style type="text/css">
h3 + p { dispalay: 
</style>

<cfoutput>
<h1>Documentation for Motrpac Intervention Tracking System</h1>

<h2>Endpoints</h2>

<ul>
<cfloop collection = "#data.routes#"  item = "rifle">
	<li>
		<a href="###rifle#">#rifle#</a>
	</li>	
</cfloop>
</ul>



<cfloop collection = "#data.routes#"  item = "rifle">
	<cfset sf = #StructFind( data.routes, rifle )#>
	<h2 id=#rifle#>#rifle#</h2>
	<p>
		<cfif StructKeyExists( sf, "hint" )>
			#sf.hint#
		</cfif>
	</p>

	<h3>Miniature Route List</h3>
	<cfdump var = #sf#>
	<p>
	</p>
</cfloop>

</cfoutput>



<cfscript>
/*
A file that should help this be more or less self documenting

//Reading the JSON file would really help.

//Table of contents
writeoutput( '<ul>' );
for ( x in data.routes ) {
	v = x;
	writeoutput( '<li><a href="' & link( v & ".cfm" ) & '">' & v & '</a></li>' );
}
writeoutput( '</ul>' );


//List everything else
for ( x in data.routes ) {
	writeoutput( "<h2>" & x & "</h2>" );
}

//writedump( data.routes );
*/
</cfscript>


