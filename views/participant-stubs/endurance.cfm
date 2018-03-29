<!--- endurance.cfm --->

<!--- Client side init code --->
<cfset AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
	location = link( "update.cfm" )
 ,querySelector = [{
		dom = "##participant_list li, .participant-info-nav li, .inner-selection li"
	 ,noPreventDefault = true
	 ,event = "click"
	 ,send = "input[name^=el_], select[name^=el_]" 
	}]
 ,additional = [ 
	{ name="this", value= "endurance" }
 ,{ name="pid", value= "#url.id#" }
 ,{ name="sess_id", value= "#sess.key#" }
	]
)>

<!--- Populate the exercise time range menu --->
<cfscript>arry1=[]; ii=1;for ( i = 5; i <= 30; i += 5 ) arry1[ ii++ ]	= /*i - 4 & */"< " & i;</cfscript>
<cfscript>arry2=[]; ii=1;for ( i = 35; i <= 60; i += 5 ) arry2[ ii++ ]	=/* i - 4 & */"< " & i;</cfscript>

<!--- Data --->
<cfscript>
values = [
//Cycle only
 { label = "RPM",           uom = "",    min = 5, max = 80, def = 0, step = 2, name = "el_ee_rpm" }
,{ label = "Watts/Resistance", 
													  uom = "",    min = 0, max = 80, def = 0, step = 1, name = "el_ee_watts_resistance" }
//Treadmill only
,{ label = "Speed",         uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "el_ee_speed"}
,{ label = "Percent Grade", uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "el_ee_grade"}

//All others
/*,{ label = "Heart Rate",    uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}
,{ label = "Blood Pressure",uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "speed"}*/
,{ label = "Perceived Exertion Rating",    
													  uom = "mph", min = 0, max = 5, def = 0, step = 1, name = "el_ee_perceived_exertion"}
];
</cfscript>

<script>
 document.addEventListener("DOMContentLoaded", function (ev) {
	//a=[].slice.call( document.querySelectorAll("#participant_list li, .participant-info-nav li, ul.inner-selection li") );
	a=[].slice.call( document.querySelectorAll( "input[name^=el_], select[name^=el_]" ) );
	console.log( a ); });
</script>

<cfoutput>
	<div class="inner-selection">
		<ul class="inner-selection">
		<cfset ii=5>
		<cfloop array=#arry1# index=ind> 
		<cfif isDefined("url.time") && ii eq url.time>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ii#' )#"><li class="selected">#ind#</li></a>
		<cfelseif isDefined("url.time") && ii lt url.time>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ii#' )#"><li class="completed">#ind#</li></a>
		<cfelse>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ii#' )#"><li>#ind#</li></a>
		</cfif>
		<cfset ii += 5>
		</cfloop>
		</ul>
		
		<ul class="inner-selection">
		<cfloop array=#arry2# index=ind> 
		<cfif isDefined("url.time") && ii eq url.time>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ii#' )#"><li class="selected">#ind#</li></a>
		<cfelseif isDefined("url.time") && ii lt url.time>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ii#' )#"><li class="completed">#ind#</li></a>
		<cfelse>
			<a href="#link( 'input.cfm?id=#url.id#&time=#ii#'  )#"><li>#ind#</li></a>
		</cfif>
		<cfset ii += 5>
		</cfloop>
		</ul>
	</div>

	<cfif StructKeyExists( url, "time" )>
		<input type="hidden" value="#url.time#" name="el_ee_timeblock">
	<cfelse>
		<input type="hidden" value="5" name="el_ee_timeblock">
	</cfif>

	<table class="table">
		<tbody>
			<tr>
				<td class="title">Exercise Type</td>
				<td>
				<select id="choose_mode" name="el_ee_equipment" disabled>
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

	<!--- Real ugly front end initialization code --->
	#AjaxClientInitCode#

</cfoutput>
