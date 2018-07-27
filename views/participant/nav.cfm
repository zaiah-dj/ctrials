<cfif isDefined( "currentParticipant" )>
<cfscript>
//Choose text based on what kind of code is loaded
cprgc = currentParticipant.results.randomGroupCode;

if ( cprgc eq "" ) 
	{ listClassPrefix = "unselected"; exName = "Nothing"; }
else if ( ListContains( ENDURANCE, cprgc ) )
	{ listClassPrefix = "endurance"; exName = "Endurance"; }
else if ( ListContains( RESISTANCE, cprgc ) )
	{ listClassPrefix = "resistance"; exName = "Resistance"; }
else {
	listClassPrefix="control"; exName = "Control";
}

//The navigation menu
container_nav = [
	{ title = "Check-In", href = "check-in.cfm", show = true }
 ,{ title = "#exName# Data", href = "input.cfm", show = ( listClassPrefix neq "control" ) } 
 ,{ title = "Recovery", href = "recovery.cfm", show = ( listClassPrefix neq "control" ) } 
/*,{ title = "Compare Data", href = "compare.cfm" }*/
/* ,{ title = "Information", href = "info.cfm" }*/
];
</cfscript>

<cfoutput>
<div class="container-navAndBodyWrapper #listClassPrefix#-class-container">
	<div class="container-nav">
	<cfloop query= currentParticipant.results >
		<ul class="participant-info-nav">
		<cfif isDefined( "url.id" )>
		 <cfloop array = #container_nav# index="cn">
			<cfif cn.show>
			<a href="#link( "#cn.href#?id=#participantGUID#" )#">
				<cfif data.page eq Left( cn.href, Len( cn.href ) - 4 )>
				<li class="selected">#cn.title#</li>
				<cfelse>
				<li>#cn.title#</li>
				</cfif>
			</a>
			</cfif>
		 </cfloop>
		<cfelse>
		 <cfloop array = #container_nav# index="cn">
			<cfif cn.show>
			<a href="#link( "#cn.href#?id=#participantGUID#" )#">
				<li class="selected">#cn.title#</li>
			</a>
			</cfif>
		 </cfloop>
		</cfif>
		</ul>
	</cfloop>
	</div>
</cfoutput>
</cfif>
