<!--- resistance.cfm --->
<cfoutput>
	<!--- Show front-end initialization code --->
	<cfif data.debug eq 1>
		<cfset DebugClientCode = clijs.ClientDebug()>
	</cfif>

	<!--- Let's see all of these in a list --->
	<ul class="inner-selection">
	<cfset cnt=0>
	<cfloop query = "#reExList.results#"> 
		<a href="#link( 'input.cfm?id=#url.id#&extype=#et_id#' )#"><li #iif(type eq et_id, DE('class="selected"'),DE(''))#>#et_name#</li></a>
		<cfif ++cnt eq 4>
			<br />
		</cfif> 
	</cfloop>
	</ul>

	<div class="selection">
		<table class="table table-striped participant-entry resistance">
	<cfloop array="#values#" index="vv">
		<cfif #vv.label# neq "">
		<tr class="heading">
			<td class="chopt">Last Visit's Results</td>
			<td><b>#vv.label# - #reExSel.results.et_name#</b></td>
		</tr>
		</cfif>
		<tr>
			<td> 
				0 #vv.uom#	
			</td>
			<td>
				<div class="row">
					<div class="col-sm-7">
						<input type="range" min="#vv.min#" max="#vv.max#" class="slider" value="#vv.def#" defaultvalue="0" name="#vv.name#" step="#vv.step#">
					</div>
					<div class="catch cc col-sm-1">#vv.def#</div>
					<div class="col-sm-1">#vv.uom#</div>
						<div class="col-sm-1">
							<button class="inc-button">+</button>
							<button class="inc-button">-</button>
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
