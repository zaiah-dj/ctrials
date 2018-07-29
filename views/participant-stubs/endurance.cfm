<!--- endurance.cfm --->
<cfoutput>
	<!--- Set a time --->
	<input type="hidden" value="#private.magic#" name="timeblock">

	<cfif data.debug eq 1>
		<cfset DebugClientCode = ajax.ClientDebug()>
	</cfif>

	<!--- TODO: This shouldn't take two loops.  Think about it more. --->
	<ul class="inner-selection">
	<cfloop query=#public.timeList#> 
		<cfset timelink = link( "input.cfm?id=#url.id#&time=#index#" )> 
	<cfif index eq public.selectedTime>
		<a href="#timelink#"><li class="selected">#text#</li></a>
	<cfelseif index lt public.selectedTime>
		<a href="#timelink#"><li class="completed">#text#</li></a>
	<cfelse>
		<a href="#timelink#"><li>#text#</li></a>
	</cfif>
	</cfloop>
		<a href="#link( 'recovery.cfm?id=#url.id#' )#"><li class="bg-red">Stop Session</li></a>
	</ul>

	<div class="selection">
		<!--- Now generate the list of exercises --->
		<table class="table table-striped">
			<thead>
				<tr>
					<td class="title">Exercise Type</td>
					<td>#public.eTypeLabel#</td>
				</tr>
			</thead>
		</table>
<cfloop array=#private.formValues# index="v"> 
	<!--- Reference the SQL value up here --->
	<cfset svMostRecent = private.combinedResults[ "p_#private.dbPrefix##v.formName#" ]>
	<cfset svCurrent = private.combinedResults[ "c_#private.dbPrefix##v.formName#" ]>

	<!--- Now start templating --->
	<table class="table table-striped endurance">
		<tbody>
			<tr class="heading">
				<td class="chopt">Last Visit Results</td>
				<td><center><b>#v.label#</b></center></td>
			</tr>
			<tr>
				<td class="title">
					<!--- An asterisk should show if nothing is there --->
					#iif(svMostRecent eq "",DE('*'),DE(svMostRecent & ' ' & v.uom))#
				</td>
				<td>
					<div class="row">
						<cfset def=iif( svCurrent eq "", 0, svCurrent )>
						<div class="cc col-sm-8">
							<input type="range" min="#v.min#" max="#v.max#" class="slider" value="#def#" defaultvalue="#def#" name="#v.formName#">
						</div>
						<div class="catch cc col-sm-1"><span>#def#</span><span> #v.uom#</span></div>
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
		</div>

	<!--- Real ugly front end initialization code --->
	#AjaxClientInitCode#
</cfoutput>
