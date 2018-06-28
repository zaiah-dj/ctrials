<!--- endurance.cfm --->
<cfoutput>
	<!--- Set a time --->
	<input type="hidden" value="#dtb#" name="timeblock">

	<cfif data.debug eq 1>
		<cfset DebugClientCode = ajax.ClientDebug()>
	</cfif>

	<!--- TODO: This shouldn't take two loops.  Think about it more. --->
	<div class="inner-selection">
		<ul class="inner-selection">
		<cfloop query=#times#> 
		<cfset timelink = link( "input.cfm?id=#url.id#&time=#index#" )> 
		<cfif index eq dtb>
			<a href="#timelink#"><li class="selected">#text#</li></a>
		<cfelseif index lt dtb>
			<a href="#timelink#"><li class="completed">#text#</li></a>
		<cfelse>
			<a href="#timelink#"><li>#text#</li></a>
		</cfif>
		</cfloop>
			<a href="#link( 'recovery.cfm?id=#url.id#' )#"><li class="bg-red">Stop Session</li></a>
		</ul>
	</div>

	<!--- Now generate the list of exercises --->
	<table class="table table-striped">
		<tbody>
			<tr>
				<td class="title">Exercise Type</td>
				<td>
					<cfif sess.csp.exerciseParameter eq 1>	
						Cycle
					<cfelseif sess.csp.exerciseParameter eq 2>	
						Treadmill	
					<cfelseif sess.csp.exerciseParameter eq 3>	
						Other	
					</cfif>
				</td>
			</tr>
		</tbody>
	</table>
<cfloop array = #values#  index = "val">
	<cfif val.show>
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
					<cfif val.prv eq "">*<cfelse>#val.prv# #val.uom#</cfif>
				</td>
				<td>
					<div class="row">
						<cfset def=iif( val.def eq "", 0, val.def )>
						<div class="cc col-sm-8">
							<cfif !structKeyExists( val, "type" )>
							<input type="range" min="#val.min#" max="#val.max#" class="slider" value="#def#" defaultvalue="#def#" name="#val.name#">
							</cfif>
						</div>
						<div class="catch cc col-sm-1"><span>#def#</span><span> #val.uom#</span></div>
						<div class="col-sm-1">
							<button class="incrementor">+</button>
							<button class="incrementor">-</button>
						</div>
					</div>
				</td>
			</tr>
	</cfif>
</cfloop>
		</tbody>
	</table>

	<input id="sendPageVals" type="submit" value="Save Changes" style="width:200px; color:white;"></input>
	<!--- Real ugly front end initialization code --->
	#AjaxClientInitCode#
</cfoutput>
