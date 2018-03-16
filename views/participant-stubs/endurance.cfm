<!--- endurance.cfm --->

<!--- Populate the exercise time range menu --->
<cfscript>arry=[]; ii=1;for ( i = 5; i <= 60; i += 5 ) arry[ ii++ ]	= i - 4 & " - " & i;</cfscript>

<!--- ... --->
<cfset AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
	location = link( "update.cfm" ) 
 ,querySelector = "input[ type=range ]" 
 ,event = "change"
)>

<!--- Data --->
<cfscript>
values = [
//Cycle only
 { label = "RPM",           uom = "",    min = 5, max = 80, def = 0, step = 2, name = "rpm" }
,{ label = "Watts/Resistance", 
													  uom = "",    min = 0, max = 80, def = 0, step = 1, name = "resistance" }
//Treadmill only
,{ label = "Speed",         uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
,{ label = "Percent Grade", uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}

//All others
,{ label = "Heart Rate",    uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
,{ label = "Blood Pressure",uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
,{ label = "Perceived Exertion Rating",    
													  uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
];
</cfscript>


<cfoutput>
	<!--- Real ugly front end initialization code --->
	#AjaxClientInitCode#

	<ul class="inner-nav">
	<cfloop array=#arry# index=ind> <a href="##"><li>#ind#</li></a></cfloop>
	</ul>

	<table class="table">
		<tbody>
			<tr>
				<td class="title">Exercise Type</td>
				<td>
				<select id="choose_mode" name="mode">
					<option value="0">Choose One</option>
					<option value="1">Cycle</option>
					<option value="2">Treadmill</option>
					<option value="3">Elliptical</option>
					<option value="4">Other</option>
				</select>
				</td>
			</tr>
		</tbody>
	</table>

	<table class="table">
		<tbody>
		<cfloop array = #values#  index = "val">
			<tr>
				<td class="title">#val.label#</td>
				<td>
					<div class="row">
						<div class="cc col-sm-8">
							<cfif !structKeyExists( val, "type" )>
							<input type="range" min="#val.min#" max="#val.max#" class="slider" value="0" defaultvalue="#val.def#" name="#val.name#" data-attr-table="ee">
							</cfif>
						</div>
						<div class="catch cc col-sm-2">0</div>
					</div>
				</td>
			</tr>
		</cfloop>
		</tbody>
	</table>
</cfoutput>
