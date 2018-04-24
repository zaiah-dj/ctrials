<!--- endurance.cfm --->
<cfoutput>
	<!--- Set a time --->
	<input type="hidden" value="#defaultTimeblock#" name="timeblock">

	<cfif data.debug eq 1>
		<cfset DebugClientCode = clijs.ClientDebug()>
	</cfif>

	<!--- TODO: This shouldn't take two loops.  Think about it more. --->
	<div class="inner-selection">
		<ul class="inner-selection">
		<cfloop array=#times# index=ind>
		<cfif ind.index eq 30><br /></cfif>
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
		</ul>
	</div>

	<!--- Now generate the list of exercises --->
	<table class="table">
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
		<cfloop array = #values#  index = "val">
			<tr>
				<td class="title">
					#val.label# ( 0 )
				</td>
				<td>
					<div class="row">
					</div>
					<div class="row">
						<div class="cc col-sm-7">
							<cfif !structKeyExists( val, "type" )>
							<input type="range" min="#val.min#" max="#val.max#" class="slider" value="#val.def#" defaultvalue="#val.def#" name="#val.name#">
							</cfif>
						</div>
						<div class="catch cc col-sm-2">#val.def#</div>
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

	<!--- Real ugly front end initialization code --->
	#AjaxClientInitCode#

</cfoutput>
