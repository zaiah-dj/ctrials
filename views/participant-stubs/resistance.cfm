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
		<cfif Len(pname) gte 13>
			<cfset classnames="smaller">
		<CFELSE>
			<cfset classnames="">
		</cfif>

		<a href="#link( 'input.cfm?id=#url.id#&extype=#id#' )#"><li class="#iif(public.type eq id, DE('selected'),DE(''))# #classnames#">#pname#</li></a>
	</cfloop>
		<a href="#link( 'recovery.cfm?id=#url.id#' )#"><li class="bg-red stop-sess">Stop Session</li></a>
	</ul>

	<div class="selection">
		<table class="table table-striped">
			<thead>
				<tr>
					<td class="title">Machine Settings</td>
					<td>Paramount XL-300</td>
				</tr>
			</thead>
		<!---
		</table>
		<table class="table table-striped participant-entry resistance">
		--->
	<cfloop array="#public.formValues#" index="vv">
		<cfif #vv.label# neq "">
		<tr class="heading">
			<td class="chopt">Last Visit's Results</td>
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
			<tr>
				<td class="title">Superset ##1</td>
				<td>
					<input type=number>
					<input type=number>
				</td>
			</tr>
			<tr>
				<td class="title">Superset ##2</td>
				<td>
					<input type=number>
					<input type=number>
				</td>
			</tr>
			<tr>
				<td class="title">Superset ##3</td>
				<td>
					<input type=number>
					<input type=number>
				</td>
			</tr>
		</table>
	</div>


	<input id="sendPageVals" type="submit" value="Save Changes" style="width: 200px;color:white;"></input>

<!--- Real ugly front end initialization code --->
#AjaxClientInitCode#
</cfoutput>
