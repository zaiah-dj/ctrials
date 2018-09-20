<cfoutput>
	<div class="container-body">
		<div id="staff-reorder">
			<div style="width: 100%; height: 150px;">
				<h5>Area for Notes</h5>
				Below are lists of participants.
			</div>

			<div class="group">
				<h5>Assigned to Me</h5>
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
						<li class="#listClassPrefix#-class">
							<div class="left">#firstname# #lastname#</div>
							<div class="right">
								PID: #pid#<br />
								Acrostic: #iif(acrostic eq "",DE('Unspecified'),DE(acrostic))#
							</div>
						</li>
					</cfloop>
					</ul>
				</div>
			</div>

			<div class="group">
				<h5>Assigned to Others</h5>
				<div class="listing">
					<ul class="disp-list disp-assignees">
					<cfloop query=associatedParticipants.results>
						<cfif ListContains( const.ENDURANCE, randomGroupCode )>
							<cfset listClassPrefix="endurance">
						<cfelseif ListContains( const.RESISTANCE, randomGroupCode )>
							<cfset listClassPrefix="resistance">
						<cfelse>
							<cfset listClassPrefix="control">
						</cfif>
						<li class="#listClassPrefix#-class">
							<div class="left">#firstname# #lastname#</div>
							<div class="right">Assigned to<br />#staff_fname# #staff_lname#</div>
						</li>
					</cfloop>
					</ul>
				</div>
			</div>

			<div class="group">
				<h5>Unassigned</h5>
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
						<li class="#listClassPrefix#-class">
							<div class="left">#firstname# #lastname#</div>
							<div class="right">
								PID: #pid#<br />
								Acrostic: #iif(acrostic eq "",DE('Unspecified'),DE(acrostic))#
							</div>
						</li>
					</cfloop>
					</ul>
				</div>
			</div>
		</div>

			
	</div>
</cfoutput>
