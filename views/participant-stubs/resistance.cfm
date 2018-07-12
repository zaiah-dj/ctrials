<!--- resistance.cfm --->
<cfoutput>
	<!--- Show front-end initialization code --->
	<cfif data.debug eq 1>
		<cfset DebugClientCode = ajax.ClientDebug()>
	</cfif>

	<!--- Let's see all of these in a list ---> <ul class="inner-selection">
	<cfset cnt=0>
		<a href="#link( 'input.cfm?id=#url.id#' )#"><li class="smaller">5 Minute Warmup</li></a>
	<cfloop query = "#public.reExList#">
		<a href="#link( 'input.cfm?id=#url.id#&extype=#id#' )#"><li class="#iif(public.type eq id, DE('selected'),DE(''))#">#pname#</li></a>
	</cfloop>
		<a href="#link( 'recovery.cfm?id=#url.id#' )#"><li class="bg-red stop-sess">Stop Session</li></a>
	</ul>

	<div class="selection">
		<div class="links">
			<cfloop array=#public.setlinks# index="lk">
				<a href="#lin#&set=#lk.index#">#lk.name#</a>
			</cfloop>
		</div>

		<table class="table table-striped">
			<tr>
				<td class="title">Exercise</td>
				<td>#public.selName#</td>
			</tr>
			<tr>
				<td class="title">Machine</td>
				<td>#public.machineFullName# <a href="">Settings</a></td>
			</tr>
		</table>

		<table class="table table-striped endurance-result-set">
	<cfloop array="#public.formValues#" index="vv">
		<cfif #vv.label# neq "">
		<tr class="heading">
			<td>Last Visit's Results</td>
			<td><b>#vv.label# - #public.selName#</b></td>
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
	</div>


	<input id="sendPageVals" type="submit" value="Save Changes" style="width: 200px;color:white;"></input>

<!--- Real ugly front end initialization code --->
#AjaxClientInitCode#
</cfoutput>
