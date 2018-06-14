<table>
<cfif not aIsDefined> 
	<tr>
		<td>No Results</td>
	</tr>
<cfelse>
<!--- ... --->
<cfset inc = 1>

<cfset DaysArr=["Mon","Tue","Wed","Thu","Fri","Sat"]>

<!--- Loop through the days and show me a list on every change --->
<cfoutput>
<cfloop query=a.results>
	<tr>
<cfif inc eq #dayOfWk#>
	<td>#dayName#</td>
	<td>See Results</td>
<cfelseif inc lt #dayOfWk#>
	<cfloop condition = "inc lt dayofwk"> 
	<td>#DaysArr[ inc ]#</td>
	<cfset inc++>
	</cfloop> 
	</tr>	
</cfif>
<cfset inc++>
</cfloop>
<cfloop condition = "inc lt 7">
	<tr>	
	<td>#DaysArr[inc]#</td>
	<td> - </td>
	<cfset inc++>
	</tr>	
</cfloop>

</cfoutput>
</cfif>
</table>
