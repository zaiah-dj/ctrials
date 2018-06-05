<cfoutput>
<h3>Week #week# | Day #day#</h3>
<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14" index="lweek">
<a class="modal-load" href="#link( 'modal-results.cfm?id=#currentId#&week=#lweek#' )#">Week #lweek#</a>
</cfloop>
<table>
<cfif ( part.results.randomGroupCode eq ENDURANCE )>
	<thead>
		<th>???</th>
	<cfloop array="#times#" index="tx"><th>#tx.text#</th></cfloop>
	</thead>
	<cfloop query = ee.results >
		<cfloop list="hr,prctgrade,rpm,speed,watres" index="listItem">
	<tr>
		<td>
			<cfswitch expression=#listItem#>
				<cfcase value="hr">HR</cfcase>
				<cfcase value="prctgrade">% Grade</cfcase>
				<cfcase value="rpm">RPM</cfcase>
				<cfcase value="speed">Speed</cfcase>
				<cfcase value="watres">Watts of Resistance</cfcase>
			</cfswitch>
		</td>
		<cfloop array="#times#" index="tx">
		<td>
		#Evaluate("m" & tx.index & "_ex" & listItem )#
		</cfloop>
		</td>
	</tr>
		</cfloop>
	</cfloop>
<cfelseif ( part.results.randomGroupCode eq RESISTANCE )>
	<thead>
	<cfloop query = reExList.results >
		<th></th>
	</cfloop>
	</thead>

	<cfloop query = rr.results >

	</cfloop>
</cfif>
</table>
</cfoutput>
