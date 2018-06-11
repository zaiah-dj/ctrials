<!--- 

default.cfm 
-----------

The first page that staff members see, allowing them
to reorganize participants.


<cfdump var = "Sess status: #sess.status#">
<cfdump var = #part_list#>
<cfabort>
--->

<cfscript>
/*
AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
	querySelector = {
		dom = "##wash-id"
	 ,event = "click"
	 ,noPreventDefault = true
	 ,send = ".listing-drop ul li span:nth-child(2)"
	}
 ,location = link( "update.cfm" ) 
 ,showDebug = true
 ,additional = [ 
		{ name = "this", value = "startSession" }
	 ,{ name = "staffer_id", value = "#randnum(8)#" }
	 ,{ name = "transact_id", value = "#sess.key#" }
	]
);
*/
</cfscript>


<cfoutput>
	<div class="container-header">
		<div class="container-header-inner">
			<!---
			<div class="container-header-left">
				<!--- Search for names --->
				<label>Search Names</label> <input id="bigly-search" type="search">
			</div>
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
				--->
			<!--- Legend --->
			<label>Legend</label>
			<div class="legend" style="position:relative; left: 100px; top:-30px;">
				<div>
				<div class="box endurance-class"></div> Endurance
				</div>
				<div>
				<div class="box resistance-class"></div> Resistance
				</div>
			</div>
		</div>
	</div>

	<div class="container-body">
		<div class="bigly-wrap">
			<div class="bigly bigly-left">
				<div class="listing">
					<ul class="part-drop-list">
						<cfloop query = "antiPartList.results">
							<li class="#iif( ListContains(ENDURANCE, randomGroupCode), DE("endurance"), DE("resistance"))#-class"><!--- draggable="true" ondragstart="drag(event)" --->
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
					<cfloop query = "part_list.results">
						<li>
							<span>#firstname# #lastname#</span>
							<span>#partcipantGUID#</span>
						</li>	
					</cfloop>
				</cfif>
					</ul>
				</div>
			</div>
		</div>

		<!--- On submit, or next, do it. --->
		<form id="wash-id" method="POST" action="#link('input.cfm')#" class="wash">
			<input type="text" name="staffer_id" value="#randnum( 8 )#">
			<input type="text" name="transact_id" value="#sess.key#">
			<input type="text" name="list"> <!--- make a list here --->
			<input type="submit" id="done" value="Done!">
		</form>
	</div>

</cfoutput>
