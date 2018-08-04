<div class="container-body">
<cfoutput>
<cfif !isDefined("currentParticipant") or (currentParticipant.results.randomGroupCode eq "")>
	<cfif selectedParticipants.prefix.recordCount gt 0>
		<p style="text-align: left; color: black;">
			Please choose a participant from the top to get started.
		</p>

		<cfscript>
		ContainsRe=0; for ( n in selectedParticipants.results )
			if ( ListContains(RESISTANCE,n.randomGroupCode )) { ContainsRe=1; break; }
		</cfscript>

		
		<div class="zeitgeist">
			<h6>Legend</h6>
			<div style="text-align: left; position: relative; left: 10px; color: black;">
				<!--- Legend --->
				<ul>
					<li><div class="box endurance-class"></div> Endurance</li>
					<li><div class="box resistance-class"></div> Resistance	</li>
					<li><div class="box control-class"></div> Control</li> 
				</ul>
			</div>
		</div>

		<div class="zeitgeist"> 
			<h6>For Resistance participants</h6>
			<ul class="re"> 
				<li>Reps: Repetitions</li>
				<li>W: Resistance weight in lbs.</li>
				<li>3 sets x 10RM with continuous load progression</li>
				<li>*90 sec between sets</li>
				<li>**60 sec between supersets( ~90 sec rest per muscle group)	</li>
			</ul>
		</div>

	<cfelse>
		<p style="text-align: left; color: black;">
			Uh oh!  It looks like you haven't selected any participants yet. 
		</p>

		<p style="text-align: left; color: black;">
			Please start off by selecting a few via the 
			<a href="#link( 'default.cfm' )#">Participant List</a> page.
		</p>
	</cfif>

<cfelse>

	<!--- Place the time or exercise type on the page so that JS can query it. --->
	<input type="hidden" value="#private.magic#" name="#private.hiddenVarName#">

	<!--- Generate the modifier list per each participant type --->
	<ul class="inner-selection">
		<a href="#link( 'input.cfm?id=#url.id#&#private.mpName#=0' )#">
			<li class="#iif(private.magic eq 0, DE('selected'),DE(''))#">5 Minute Warmup</li>
		</a>
	<cfloop query = "#private.modNames#">
		<cfif (urlparam eq 0) && isEnd>
		<cfelse>
		<a href="#link( 'input.cfm?id=#url.id#&#private.mpName#=#urlparam#' )#">
			<li class="#iif(private.magic eq urlparam, DE('selected'),DE(''))#">#pname#</li>
		</a>
		</cfif>
	</cfloop>
		<a href="#link( 'recovery.cfm?id=#url.id#' )#">
			<li class="bg-red stop-sess">Stop Session</li>
		</a>
	</ul>


	<!--- Now show the meat of the content --->
	<div class="selection">
		<!--- Resistance gets these links for quick jumping through results --->
		<div class="links">
		<cfif isRes>
			<a href="##set1">Set 1</a>
			<a href="##set2">Set 2</a>
			<a href="##set3">Set 3</a>
		</cfif>
		</div>

		<!--- The first question always looks the same, so I'll keep that here --->
	<cfif private.magic eq 0>
		<h5>Exercise Prep</h5>
		<table class="table table-striped table-meta">
			<tbody>
				<tr>
					<td>Is the Heart Rate monitor working properly?</td>
					<td>
						<label class="switch">
							<input class="toggler-input" type="checkbox" name="hrMonitor"> 
							<span class="toggler round"></span>
						</label>
					</td>
				</tr>
			</tbody>
		</table>
	</cfif>


		<!--- Show all the exercise metadata here --->
		<br />
		<h5>Exercise Metadata</h5>
		<div class="table-border-meta">
		<table class="table table-striped table-meta">
			<tbody>
				<tr>
					<td><b>Exercise Set</b></td>
					<td>#private.exSetTypeLabel#</td>
				</tr>
			<cfif !isRes>
				<tr>
					<td></td>
					<td></td>
				</tr>
			<cfelse>
				<tr>
					<td><b>Exercise Selected</b></td>
					<td>#private.magicName#</td>
				</tr>
				<tr>
					<td class="title">Machine</td>
					<td>##</td>
				</tr>
				<tr>
					<td class="title">Machine Settings</td>
					<td>## <a href="">Settings</a></td>
				</tr>
				<tr>
					<td class="title">Was exercise done?</td>
					<td>
						<label class="switch">
							<input class="toggler-input" type="checkbox" name="is_exercise_done"> <!--- #iif(private.exdone gt 0,DE('checked'),DE(''))#> --->
							<span class="toggler round"></span>
						</label>
					</td>
				</tr>
				<tr>
					<td class="title">Is this a Superset?</td>
					<td>
						<label class="switch">
							<input class="toggler-input" type="checkbox" name="is_superset"> 
							<!--- #iif(private.exdone eq 2,DE('checked'),DE(''))#> --->
							<span class="toggler round"></span>
						</label>
					</td>
				</tr>
			</cfif>
			</tbody>
		</table>
		</div>

		<!--- Finally, show all the exercise results --->
		<h5>Exercise Results</h5>
		<table class="table table-results-header">
			<thead>
				<tr style="height: 20px">
					<td>Last Visit Results</td>
					<td><b>Exercise Parameter</b></td>
				</tr>
			</thead>
		</table>

			<cfloop query=#private.formValues#> <!---index="v" --->
				<!--- Reference the SQL value up here --->
				<cfset svMostRecent=private.combinedResults[ "p_#private.dbPrefix##formName#" ]>
				<cfset svCurrent=private.combinedResults[ "c_#private.dbPrefix##formName#" ]>
				<cfset def=iif( svCurrent eq "", 0, svCurrent )>


		<table class="table table-results">
			<tbody>
				<cfif isEnd or (isRes and label neq "")>
				<tr> 
					<td><b>#label#</b></td>
					<td></td>
				</tr>
				</cfif>
				<tr>
					<!--- An asterisk should show if nothing is there --->
					<td>#iif(svMostRecent eq 0 || svMostRecent eq "",DE('*'),DE(svMostRecent & ' ' & uom))#</td>
					<td>
						<div class="row">
							<div class="cc col-sm-8">
								<input type="range" min="#min#" max="#max#" class="slider" value="#def#" defaultvalue="#def#" name="#formName#">
							</div>
							<div class="catch cc col-sm-1"><span>#def#</span><span> #uom#</span></div>
							<div class="col-sm-1">
								<button class="incrementor">+</button>
								<button class="incrementor">-</button>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
			</cfloop>
		<input id="sendPageVals" type="submit" value="Save Changes" style="width:200px; color:white;"></input>
	#AjaxClientInitCode#
	</div>
</cfif>
</cfoutput>
</div>
