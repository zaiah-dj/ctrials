<!--- endurance.cfm --->
<cfoutput>
	<!--- Set a time --->
	<input type="hidden" value="#defaultTimeblock#" name="timeblock">

	<cfif data.debug eq 1>
		<cfset DebugClientCode = ajax.ClientDebug()>
	</cfif>

	<!--- TODO: This shouldn't take two loops.  Think about it more. --->
	<div class="inner-selection">
		<ul class="inner-selection">
		<cfloop array=#times# index=ind>
		<cfif ind.index eq defaultTimeblock>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ind.index#' )#">
				<li class="selected">#ind.text#</li>
			</a>
		<cfelseif ind.index lt defaultTimeblock>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ind.index#' )#">
				<li class="completed">#ind.text#</li>
			</a>
		<cfelse>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ind.index#' )#">
				<li>#ind.text#</li>
			</a>
		</cfif>
		</cfloop>
			<a href="#link( 'recovery.cfm?id=#url.id#' )#">
				<li class="bg-red">Stop Session</li>
			</a>
		</ul>
	</div>

	<!--- Now generate the list of exercises --->
	<table class="table table-striped">
		<tbody>
			<tr>
				<td class="title">Exercise Type</td>
				<td>
				<select id="choose_mode" name="equipment" disabled>
					<option value="0">This Will Already be Chosen</option>
					<option selected value="1">Cycle</option>
					<option value="2">Treadmill</option>
					<option value="3">Elliptical</option>
					<option value="4">Other</option>
				</select>
				</td>
			</tr>
		</tbody>
	</table>
		<cfloop array = #values#  index = "val">
	<table class="table table-striped endurance">
		<tbody>
			<tr class="heading">
				<td class="chopt">
					Last Visit's Results
				</td>
				<td> 
					<center><b>#val.label#</b></center>
				</td>
			</tr>
			<tr>
				<td class="title">
					#val.prv# lb
				</td>
				<td>
					<div class="row">
						<cfset def=iif( val.def eq "", 0, val.def )>
						<div class="cc col-sm-7">
							<cfif !structKeyExists( val, "type" )>
							<input type="range" min="#val.min#" max="#val.max#" class="slider" value="#def#" defaultvalue="#def#" name="#val.name#">
							</cfif>
						</div>
						<div class="catch cc col-sm-1">#def#</div>
						<div class="col-sm-1">lb</div>
						<div class="col-sm-1">
							<button class="inc-button">+</button>
							<button class="inc-button">-</button>
						</div>
					</div>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>

	<input id="sendPageVals" type="submit" value="Save Changes" style="width: 200px;color:white;"></input>
	<!--- Real ugly front end initialization code --->
	#AjaxClientInitCode#

</cfoutput>
