<table>
<cfif not aIsDefined> 
	<tr>
		<td>No Results</td>
	</tr>
<cfelse>
<!--- Loop through the days and show me a list on every change --->

<cfloop query=a.results>
	<cfset DaysArr[ #dayOfWk# ].number = dayofwk >
</cfloop>

<cfoutput>
<cfloop array=#DaysArr# index=da>
	<tr>
		<td>#da.name#</td>
	<cfif !da.number>
		<td> - </td>
	<cfelse>
		<cfset go_here = link("modal-results.cfm?week=#week#&day=#da.number#")>
		<td><a href="#go_here#">See Results</a></td>
	</cfif>
	</tr>	
</cfloop>

</cfoutput>
</cfif>
</table>
