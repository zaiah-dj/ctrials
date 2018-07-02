<cfoutput>
	<div class="container-body">
<!---
		<table>
			<tr>
				<th>ID</th>
				<th>First Name</th>
				<th>Last Name</th>
			</tr>
		<cfloop query=public.staff.results>
			<tr>
				<td>#ts_id#</td>
				<td>#ts_firstname#</td>
				<td>#ts_lastname#</td>
			</tr>
		</cfloop>
		</table>
--->

		<cfloop query=public.sel.results>
		<div>
			<u>#firstname# #lastname# ( #acrostic# )</u>
		</div>
		</cfloop>

	</div>
</cfoutput>
