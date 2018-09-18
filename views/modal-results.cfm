<cfoutput>
<h3>Week #week# | Day #day#</h3>
<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14" index="lweek">
<a class="modal-load" href="#link( 'modal-results.cfm?id=#cs.participantId#&week=#lweek#' )#">Week #lweek#</a>
</cfloop>
<table>
<cfif ListContains(const.ENDURANCE, currentParticipant.results.randomGroupCode)>
	<thead>
		<th>Endurance Exercises</th>
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
<cfelseif ListContains(const.RESISTANCE, currentParticipant.results.randomGroupCode)>
	<!--- Create a seperate list for looping --->
	<cfset NameList=[]>

	<Cfloop query=reExList>
		<cfset ArrayAppend( NameList, "#prefix#" )>
	</cfloop>

	<!--- Create the column header --->
	<thead>
		<th>Resistance Exercises</th>
	<cfloop query = reExList>
		<th style="width:6.5%">#pname#</th>
	</cfloop>
	</thead>

<!---
	<!--- Now loop through and generate the table's values --->
	<cfloop query = rr.results >
		<cfloop list="Wt1,Rep1,Wt2,Rep2,Wt3,Rep3" index="ind">
		<tr>
			<td>
			<cfswitch expression=#ind#>
				<cfcase value="Wt1">Set 1 Weight</cfcase>
				<cfcase value="Rep1">Set 1: Repetitions</cfcase>
				<cfcase value="Wt2">Set 2: Weight</cfcase>
				<cfcase value="Rep2">Set 2: Repetitions</cfcase>
				<cfcase value="Wt3">Set 3: Weight</cfcase>
				<cfcase value="Rep3">Set 3: Repetitions</cfcase>
			</cfswitch>
			</td>
			<cfloop array = "#NameList#" index="fm" >
			<td style="width:6.5%">#Evaluate( fm & ind )#</td>
			</cfloop>
		</tr>
		</cfloop>
	</cfloop>
--->
</cfif>
</table>
</cfoutput>
