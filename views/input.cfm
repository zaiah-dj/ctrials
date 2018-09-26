<cfoutput>
<div class="container-body">
<cfif currentParticipant.results.randomGroupCode eq "">
	<cfif selectedParticipants.prefix.recordCount gt 0>
		<p style="text-align: left; color: black;">
			Please choose a participant from the top to get started.
		</p>

		<cfscript>
		ContainsRe=0; for (n in selectedParticipants.results)
			if ( ListContains(const.RESISTANCE, n.randomGroupCode )) { ContainsRe=1; break; }
		</cfscript>

		<div class="zeitgeist">
			<h6>Legend</h6>
			<div style="text-align: left; position: relative; left: 10px; color: black;">
				<!--- Legend --->
				<ul>
					<li><div class="box endurance-class"></div> Endurance</li>
					<li><div class="box resistance-class"></div> Resistance</li>
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

<cfelseif private.proceed eq false>
	<!--- No participant checked-in --->
	<p style="color: black;">
	#private.message#
	</p>

<cfelse>
	<!--- Place the time or exercise type on the page so that JS can query it. --->
	<input type="hidden" value="#private.magic#" name="#private.hiddenVarName#">

	<!--- Generate the modifier list per each participant type --->
	<ul class="inner-selection">
		<a href="#link( 'input.cfm?id=#url.id#&#private.mpName#=0' )#">
			<li class="#iif(private.magic eq 0, DE('selected'),DE(''))#">
				<!--- The x2714 is a checkbox --->
				<cfif ListFind( private.edlist, 0)>&##x2714</cfif>
				5 Minute Warmup
			</li>
		</a>
	<cfloop query = "#private.modNames#">
		<cfif ((urlparam eq 0) && isEnd) || ((urlparam eq 0) && isRes)>
		<cfelse>
		<a href="#link( 'input.cfm?id=#url.id#&#private.mpName#=#urlparam#' )#">
			<li class="#iif(private.magic eq urlparam, DE('selected'),DE(''))#">
				<cfif ListFind( private.edlist, urlparam )>&##x2714</cfif>
				#pname#
			</li>
		</a>
		</cfif>
	</cfloop>
		<a href="#link( 'recovery.cfm?id=#url.id#&abort=true&#private.mpName#=#private.magic#' )#">
			<li class="bg-red stop-sess">Stop Session</li>
		</a>
	</ul>


	<!--- Now show the meat of the content --->
	<div class="selection">
	<cfif private.magic eq 0>
		<h5>Exercise Prep</h5>
		<table class="table table-striped table-meta">
			<tbody>
				<tr>
					<td>Exercise Class</td>
					<td>#private.exSetTypeLabel#</td>
				</tr>
				<tr>
					<td>Is the Heart Rate monitor working properly?</td>
					<td>
						<label class="switch">
							<input class="toggler-input" type="checkbox" name="hrworking" 
								#iif(private.etc.results.c_Hrworking gt 0,DE('checked'),DE(''))#>
							<span class="toggler round"></span>
							<div>#iif( private.etc.results.c_Hrworking gt 0, DE('Yes'),DE('No') )#</div>
						</label>
					</td>
				</tr>
				<cfif isEnd>
				<tr>
					<td>Warm-Up Start Time <i>(24 hour HH:mm)</i></td>
					<td>
						<button class="stateChange">Begin Exercise</button>
						<cfif ( private.etc.results.c_wrmup_starttime gt 0)>
							<cfset tfhr_time=DateTimeFormat( private.etc.results.c_wrmup_starttime, "HH:nn" )>
						<cfelse>
							<cfset tfhr_time="">
						</cfif>
						<input type="text" placeholder="HH:MM" name="tfhr_time" value="#tfhr_time#"></input>
					</td>
				</tr>
				</cfif>
			</tbody>
		</table>
	</cfif>


		<!--- Show all the exercise metadata here --->
		<br />
	<cfif private.magic gt 0>
		<h5>Exercise Machine Type</h5>
		<div class="table-border-meta">
		<table class="table table-striped table-meta">
			<tbody>
				<tr>
					<td><b>Exercise Set</b></td>
					<td>#private.exSetTypeLabel#</td>
				</tr>
			<cfif !isRes>
				<tr><td></td><td></td></tr>
			<cfelse>
				<tr>
					<td><b>Exercise Selected</b></td>
					<td>#private.magicName#</td>
				</tr>
				<tr>
					<td class="title">Was exercise done?</td>
					<td>
						<label class="switch">
							<input class="toggler-input" type="checkbox" 
								#iif(private.exBool.exercise gt 0,DE('checked'),DE(''))#
								name="is_exercise_done">
								
							<span class="toggler round"></span>
							<div>#iif( private.exBool.exercise gt 0, DE('Yes'),DE('No') )#</div>
						</label>
					</td>
				</tr>
				<tr>
					<td class="title">Is this a Superset?</td>
					<td>
						<label class="switch">
							<input class="toggler-input" type="checkbox" 
								#iif(private.exBool.superset gt 0,DE('checked'),DE(''))#
								name="is_superset">
							<span class="toggler round"></span>
							<div>#iif( private.exBool.superset gt 0, DE('Yes'),DE('No') )#</div>
						</label>
					</td>
				</tr>
			</cfif>
			</tbody>
		</table>
		</div>
	</cfif>

	<cfif isRes and private.magic gt 0>
		<h5>Machine Data</h5>
		<div class="table-border-meta">
		<table class="table table-striped table-meta">
			<tbody>
				<tr>
					<td class="title">Machine</td>
					<td>
						#private.eqlog.results.manufacturerdescription#
						#private.eqlog.results.modeldescription#
					</td>
				</tr>
				<tr>
					<td class="title">Machine Settings</td>
					<td>
					<ul>
					<cfloop query=#private.eqlog.results#>	
						<li>#settingDescription#</li>
					</cfloop>
					</ul>
					</td>
				</tr>
				<cfif private.showResl and private.allSettings.prefix.recordCount gt 0>
				<tr>
					<td class="title">Machine Settings</td>
					<td>
					<table>
						<tr>
							<td>Name</td>
							<td>Setting Value</td>
						</tr>
						<tr>
							<td>#private.settings.setting1na#</td>
							<td>#private.settings.setting1#</td>
						</tr>
						<tr>
							<td>#private.settings.setting2na#</td>
							<td>#private.settings.setting2#</td>
						</tr>
						<tr>
							<td>#private.settings.setting3na#</td>
							<td>#private.settings.setting3#</td>
						</tr>
						<tr>
							<td>#private.settings.setting4na#</td>
							<td>#private.settings.setting4#</td>
						</tr>
					</table>
					</td>
				</tr>
				</cfif>
			</tbody>
		</table>
		</div>
	</cfif>

		<!--- Finally, show all the exercise results --->
		<h5>Exercise Results</h5>
		<div><!--- class="table-border-meta" --->
		<table class="table table-results-header">
			<thead>
				<tr style="height: 20px">
					<td>Last Session Results</td>
					<td><b>Exercise Parameter</b></td>
				</tr>
			</thead>
		</table>
			<cfloop query = #private.formValues# >
				<!--- Reference the SQL value up here --->
				<cfset svMostRecent=private.combinedResults[ "p_#private.dbPrefix##formName#" ]>
				<cfset svCurrent=private.combinedResults[ "c_#private.dbPrefix##formName#" ]>
				<cfset def=iif( svCurrent eq "", Round(min + ((max - min) / 2)), svCurrent )>
			

		<table class="table table-results">
			<tbody>
				<cfif isEnd or (isRes and label neq "")>
				<tr> 
					<td><b>#label#</b></td>
					<td></td>
				</tr>
				</cfif>
				<tr>
					<td>
						#iif(svMostRecent eq "" || svMostRecent eq 0,DE('N/A' & ' <small>' & uom & '</small>'),DE(svMostRecent & ' ' & uom))#
						<span class="tiny">(as of #private.etc.results.p_d_visit#)</span>
					</td>
					<td>
						<div class="input-slider">
							<div class="input-slider--slider">
								<input type="range" min="#min#" max="#max#" class="slider" value="#def#" defaultvalue="#def#" name="#formName#">
								<div class="input-slider--slider--ranges">
									<div class="input-slider--slider--min">#min#</div>
									<div class="input-slider--slider--max">#max#</div>
								</div>
							</div>
							<div class="input-slider--value"><span>#def#</span><span> #uom#</span></div>
							<div class="input-slider--buttons">
								<button class="input-slider--incrementor js-up">#const.thickArrow#</button>
								<button class="input-slider--incrementor js-down">#const.thickArrow#</button>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>

			</cfloop>
		</div>
		<input id="sendPageVals" type="submit" value="Save Changes" style="width:200px; color:white;"></input>

		<div class="addl">
			<input type="hidden" name="this" value="#private.cssPrefix#">
			<input type="hidden" name="exparam" value="#sc.exerciseParameter#">
			<input type="hidden" name="sess_id" value="#session.ivId#">
			<input type="hidden" name="pid" value="#cs.participantId#">
			<input type="hidden" name="dayofwk" value="#session.currentDayOfWeek#">
			<input type="hidden" name="stdywk" value="#sc.week#">
			<input type="hidden" name="#private.hiddenVarName#" value="#private.magic#">
			<input type="hidden" name="insBy" value="#usr.userguid#">
			<input type="hidden" name="pageUpdated" value=0> 
			<!---
			<input type="hidden" name="recordthread" value="#sc.recordthread#">
	#AjaxClientInitCode#
				--->
		</div>

	</div>
</cfif>
</div>
</cfoutput>
