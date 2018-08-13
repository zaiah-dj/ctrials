<!--- 

default.cfm 
-----------

The first page that staff members see, allowing them
to reorganize participants.

--->

<cfoutput>
	<div class="container-header">
		<div class="legend">
			<!--- Legend --->
			<ul>
				<li><b>Legend</b></li>
				<li><div class="box endurance-class"></div> Endurance</li>
				<li><div class="box resistance-class"></div> Resistance	</li>
				<li><div class="box control-class"></div> Control</li> 
			</ul>
		</div>
	</div>

	<div class="container-body">
		<div class="bigly-wrap">
			<div class="bigly bigly-left">
				<div class="listing">
					<ul class="part-drop-list">
						<cfloop query = unselectedParticipants.results>
							<cfif ListContains( ENDURANCE, randomGroupCode )>
								<cfset listClassPrefix="endurance">
							<cfelseif ListContains( RESISTANCE, randomGroupCode )>
								<cfset listClassPrefix="resistance">
							<cfelse>
								<cfset listClassPrefix="control">
							</cfif>
							<li class="#listClassPrefix#-class">
								<span>#firstname# #lastname# (#pid#)</span>
								<span>#participantGUID#</span>
							</li>	
						</cfloop>
					</ul>
				</div>
			</div>

			<div class="bigly bigly-right" style="float: right;" ondrop="drop(event)" ondragover="allowDrop(event)">
				<div class="listing listing-drop">
					<ul> 
				<cfif sess.status gte 2>
					<cfloop query = selectedParticipants.results>
						<cfif ListContains( ENDURANCE, randomGroupCode )>
							<cfset listClassPrefix="endurance">
						<cfelseif ListContains( RESISTANCE, randomGroupCode )>
							<cfset listClassPrefix="resistance">
						<cfelse>
							<cfset listClassPrefix="control">
						</cfif>
						<li class="#listClassPrefix#-class-dropped">
							<div class="left">
							<span>#firstname# #lastname#</span>
							<span>#participantGUID#</span>
							<span>(#pid#)</span>
							</div>
							<div class="right">
							<a href="" class="release">Release</a>
							</div>
						</li>	
					</cfloop>
				</cfif>
					</ul>
				</div>
			</div>
		</div>

		<!--- On submit, or next, do it. --->
		<form id="wash-id" method="POST" action="#link('input.cfm')#" class="wash">
			<input type="text" name="interventionist_id" value="#session.userguid#">
			<input type="text" name="transact_id" value="#sess.key#">
			<input type="text" name="sessday_id" value="#csSid#">
			<input type="text" name="list"> <!--- make a list here --->
			<input type="submit" id="done" value="Done!">
		</form>
	</div>

</cfoutput>
