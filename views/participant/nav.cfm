<cfif isDefined( "part" )>
<cfscript>
exName = (ListContains(ENDURANCE,part.results.randomGroupCode)) ? "Endurance" : "Resistance";
container_nav = [
	{ title = "Check-In", href = "check-in.cfm" }
 ,{ title = "#exName# Data", href = "input.cfm" }
 ,{ title = "Recovery", href = "recovery.cfm" }
/*,{ title = "Compare Data", href = "compare.cfm" }*/
/* ,{ title = "Information", href = "info.cfm" }*/
];
</cfscript>

<div class="container-navAndBodyWrapper">
	<div class="container-nav">
	<cfoutput query="part.results" >
		<ul class="participant-info-nav">
		<cfif isDefined( "url.id" )>
		 <cfloop array = #container_nav# index="cn">
			<a href="#link( "#cn.href#?id=#participantGUID#" )#">
				<cfif data.page eq Left( cn.href, Len( cn.href ) - 4 )>
				<li class="selected">#cn.title#</li>
				<cfelse>
				<li>#cn.title#</li>
				</cfif>
			</a>
		 </cfloop>
		<cfelse>
		 <cfloop array = #container_nav# index="cn">
			<a href="#link( "#cn.href#?id=#participantGUID#" )#">
				<li class="selected">#cn.title#</li>
			</a>
		 </cfloop>
		</cfif>
		</ul>
	</cfoutput>
	</div>
</cfif>
