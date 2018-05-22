<h2>Results #part.results >
<cfoutput>
<table>
<cfif ( part.results.randomGroupCode eq ENDURANCE )>
	<thead>
	<cfloop array = times>
		<th>#times.text#</th>
	</cfloop>
	</thead>
	<cfloop query = ee.results >

	</cfloop>
<cfelseif ( part.results.randomGroupCode eq RESISTANCE )>
	<thead>
	<cfloop query = reExList.results >
		<th></th>
	</cfloop>
	</thead>

	<cfloop query = rr.results >

	</cfloop>
</cfif>
</table>
</cfoutput>
