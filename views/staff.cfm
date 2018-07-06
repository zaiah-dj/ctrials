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

		<div id="staff-reorder">
			<div class="listing">
			<cfloop query=public.sel.results>
			<div>
				<u>#firstname# #lastname# ( #acrostic# ) </u>
			</div>
			</cfloop>
			</div>

			<div class="listing">
			<cfloop query=public.allSel.results>
			<div>
				<u>#firstname# #lastname# ( Assigned to #ts_staffid# ) </u>
			</div>
			</cfloop>
			</div>

			<div class="listing">
			<cfloop query=unselectedParticipants.results>
			<div>
				<u>#firstname# #lastname# ( #acrostic# ) </u>
			</div>
			</cfloop>
			</div>
		</div>

			
	</div>
</cfoutput>
