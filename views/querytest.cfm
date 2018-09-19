<div class="container-body">
<style type="text/css">
td.struct { line-height: 20px !important; }
</style>
<table>
<cfscript>
for ( n in private.lastdays.results )
{writeoutput( "<tr>" );writedump( n ); writeoutput( "</tr>" );}
for ( n in private.etc.results )
{writeoutput( "<tr>" );writedump( n ); writeoutput( "</tr>" );}
</cfscript>
</table>
</div>
