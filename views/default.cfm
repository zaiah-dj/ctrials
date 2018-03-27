<!--- 

default.cfm 
-----------

The first page that staff members see, allowing them
to reorganize participants.

--->
<cfset submit_link="#link( 'start-daily.cfm' )#">
<cfset linkish="#link( 'chosen.cfm' )#">
<style type="text/css">
.short-list { position: relative; border/*-bottom*/: 2px solid black; margin-bottom: 10px; width: 100%; }
.wash input[type=text] { display: none; }
.short-list ul li { width: 50px; display: inline-block; background: black; padding-left: 10px; }
.short-list ul li:hover { background: white; }


</style>


<cfoutput>
<!--- Include the requirements for touch --->
<script type="text/javascript" src="#link( 'assets/touch.js' )#"></script>

<cfif data.debug eq 1>
	<div class="debug2">#mySession# - #sessionStatus#</div>
</cfif>

	<div class="container-header">
		<div class="container-header-inner">
			<div class="container-header-left">
				<!--- Search for names --->
				<label>Search Names</label> <input id="bigly-search" type="search">
			</div>

			<!--- Legend --->
			<div class="container-header-right">
				<label>Legend</label>
				<div class="legend">
					<div>
					<div class="box endurance-class"></div> Endurance
					</div>
					<div>
					<div class="box resistance-class"></div> Resistance
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="container-body">
		<div class="bigly-wrap">
			<div class="bigly bigly-left">
				<div class="listing">
					<ul class="part-drop-list">
						<cfloop query = "all_part_list">
							<li class="#iif( participant_exercise eq 1, DE("endurance"), DE("resistance"))#-class"><!--- draggable="true" ondragstart="drag(event)" --->
								<span>#participant_fname# #participant_lname#</span>
								<span>#participant_id#</span>
							</li>	
						</cfloop>
					</ul>
				</div>
			</div>

			<div class="bigly bigly-right" style="float: right;" ondrop="drop(event)" ondragover="allowDrop(event)">
				<div class="listing listing-drop">
					<ul> 
				<cfif sessionStatus eq 2>
					<cfloop query = "part_list">
						<li>
							<span>#participant_fname# #participant_lname#</span>
							<span>#participant_id#</span>
						</li>	
					</cfloop>
				</cfif>
					</ul>
				</div>
			</div>
		</div>

		<!--- On submit, or next, do it. --->
		<form id="wash-id" method="POST" action="#link('chosen.cfm')#" class="wash"> 
			<input type="text" name="staffer_id" value="#randnum( 8 )#"> 
			<input type="text" name="transact_id" value="#mySession#"> 
			<input type="text" name="list"> <!--- make a list here --->
			<input type="submit" id="done" value="Done!">
		</form>
	</div>

</cfoutput>
