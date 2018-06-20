<table class="inner">
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
	<cfloop array=#DaysArr# index=da><th>#da.name#</th></cfloop>
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
