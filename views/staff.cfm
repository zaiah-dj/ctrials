<cfoutput>
	<div class="container-body">
		<div id="staff-reorder">
			<div style="width: 100%; height: 150px;">
				<h5>Area for Notes</h5>
				Below are lists of participants.
			</div>

			<div class="group">
				<h5>Selected</h5>
				<div class="listing">
					<ul class="disp-list">
					<cfloop query=selectedParticipants.results>
						<cfif ListContains( const.ENDURANCE, randomGroupCode )>
							<cfset listClassPrefix="endurance">
						<cfelseif ListContains( const.RESISTANCE, randomGroupCode )>
							<cfset listClassPrefix="resistance">
						<cfelse>
							<cfset listClassPrefix="control">
						</cfif>
						<li class="#listClassPrefix#-class">#firstname# #lastname# ( #pid# ) </li>
					</cfloop>
					</ul>
				</div>
			</div>

			<div class="group">
				<h5>Assigned</h5>
				<div class="listing">
					<ul class="disp-list">
<!---
					<cfloop query=public.allSel.results>
						<li>#firstname# #lastname# ( Assigned to #ts_staffguid# ) </li>
					</cfloop>
--->
					</ul>
				</div>
			</div>

			<div class="group">
				<h5>Available</h5>
				<div class="listing">
					<ul class="disp-list">
					<cfloop query=unselectedParticipants.results>
						<cfif ListContains( const.ENDURANCE, randomGroupCode )>
							<cfset listClassPrefix="endurance">
						<cfelseif ListContains( const.RESISTANCE, randomGroupCode )>
							<cfset listClassPrefix="resistance">
						<cfelse>
							<cfset listClassPrefix="control">
						</cfif>
						<li class="#listClassPrefix#-class">#firstname# #lastname# ( #pid# ) </li>
					</cfloop>
					</ul>
				</div>
			</div>
		</div>

			
	</div>
</cfoutput>
