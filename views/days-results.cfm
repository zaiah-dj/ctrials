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
<tr>
	<cfloop array=#DaysArr# index=da><td>#da.name#</td></cfloop>
</tr>
<tr>
<cfloop array=#DaysArr# index=da>
	<td>
	<cfif !da.number>
		-
	<cfelse>
		<a href='#link("modal-results.cfm?id=#pid#&week=#week#&day=#da.number#")#'>See Results</a></td>
	</cfif>
	</td>
</cfloop>
</tr>

</cfoutput>
</cfif>
</table>
