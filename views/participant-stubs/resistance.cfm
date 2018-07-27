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
	<cfloop query = "#public.reExList#">
		<a href="#link( 'input.cfm?id=#url.id#&extype=#id#' )#"><li class="#iif(public.type eq id, DE('selected'),DE(''))#">#pname#</li></a>
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
				<td>#public.selName#</td>
			</tr>
			<tr>
				<td class="title">Machine</td>
				<td>#public.machineFullName#</td>
			</tr>
			<tr>
				<td class="title">Machine Settings</td>
				<td>#public.machineFullName# <a href="">Settings</a></td>
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
	<cfloop array="#public.formValues#" index="vv">
			<cfif #vv.label# neq "">
			<tr class="heading">
				<td>Last Visit's Results</td>
				<td id="set#vv.index#"><b>#vv.label# - #public.selName#</b></td>
			</tr>
			</cfif>
			<tr> 
				<td> 
					<cfif #vv.prv# eq "">*<cfelse>#vv.prv# #vv.uom#</cfif>
				</td>
				<td>
					<div class="row">
						<div class="col-sm-8">
							<cfset def=iif( vv.def eq "", 0, vv.def )>
							<input type="range" min="#vv.min#" max="#vv.max#" class="slider" value="#def#" defaultvalue="0" name="#vv.formName#" step="#vv.step#">
						</div>
						<div class="catch cc col-sm-1"><span>#def#</span><span> #vv.uom#</span></div>
						<div class="col-sm-1">
							<button class="incrementor">+</button>
							<button class="incrementor">-</button>
						</div>
					</div>
				</td>
			</tr>
			<cfif #vv.label# eq "">
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
