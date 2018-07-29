<!--- resistance.cfm --->
<cfoutput>
	<!--- Show front-end initialization code --->
	<cfif data.debug eq 1>
		<cfset DebugClientCode = ajax.ClientDebug()>
	</cfif>

	
	<!--- The first question is the warmup page... --->
	


	<!--- Let's see all of these in a list --->
	<ul class="inner-selection">
	<cfset cnt=0>
		<a href="#link( 'input.cfm?id=#url.id#' )#"><li class="smaller">5 Minute Warmup</li></a>
	<cfloop query = "#private.modNames#">
		<a href="#link( 'input.cfm?id=#url.id#&extype=#id#' )#"><li class="#iif(private.magic eq id, DE('selected'),DE(''))#">#pname#</li></a>
	</cfloop>
		<a href="#link( 'recovery.cfm?id=#url.id#' )#"><li class="bg-red stop-sess">Stop Session</li></a>
	</ul>

	<div class="selection">
		<div class="links">
			<a href="##set1">Set 1</a>
			<a href="##set2">Set 2</a>
			<a href="##set3">Set 3</a>
		</div>

		<table class="table table-striped">
			<tbody>
			<tr>
				<td class="title">Exercise</td>
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
						<input class="toggler-input" type="checkbox" name="exercise_done">
						<span class="toggler round"></span>
					</label>
				</td>
			</tr>
			<tr>
				<td class="title">Is this a Superset?</td>
				<td>
					<label class="switch">
						<input class="toggler-input" type="checkbox" name="is_superset">
						<span class="toggler round"></span>
					</label>
				</td>
			</tr>
			</tbody>
		</table><br />

		<table class="table table-striped endurance-result-set">
	<cfloop array="#private.formValues#" index="v">
		<cfset svMostRecent = private.combinedResults[ "p_#private.dbPrefix##v.formName#" ]>
		<cfset svCurrent = private.combinedResults[ "c_#private.dbPrefix##v.formName#" ]>

		<cfif #v.label# neq "">
			<tr class="heading">
				<td>Last Visit Results</td>
				<td id="set#v.index#"><b>#v.label# - $EXERCISENAME</b></td>
			</tr>
		</cfif>
			<tr> 
				<td> 
					<!--- An asterisk should show if nothing is there --->
					#iif(svMostRecent eq "",DE('*'),DE(svMostRecent & ' ' & v.uom))#
				</td>
				<td>
					<div class="row">
						<cfset def=iif( svCurrent eq "", 0, svCurrent )>
						<div class="col-sm-8">
							<input type="range" min="#v.min#" max="#v.max#" class="slider" value="#def#" defaultvalue="0" name="#v.formName#" step="#v.step#">
						</div>
						<div class="catch cc col-sm-1"><span>#def#</span><span> #v.uom#</span></div>
						<div class="col-sm-1">
							<button class="incrementor">+</button>
							<button class="incrementor">-</button>
						</div>
					</div>
				</td>
			</tr>
			<cfif #v.label# eq "">
			<tr></tr>	
			</cfif>
	</cfloop> 
		</table>

		<input id="sendPageVals" type="submit" value="Save Changes" style="width: 200px;color:white;"></input>
		<div class="paddMe"></div>
	</div>



<!--- Real ugly front end initialization code --->
#AjaxClientInitCode#
</cfoutput>
