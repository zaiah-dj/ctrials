<cfscript>
container_nav = [
	{ title = "Check-In", href = "check-in.cfm" }
 ,{ title = "Exercise Data", href = "input.cfm" }
 ,{ title = "Compare Data", href = "compare.cfm" }
 ,{ title = "Information", href = "info.cfm" }
];
</cfscript>

<div class="container-nav">
<cfoutput query="part" >
	<ul class="participant-info-nav">
	<cfif isDefined( "url.id" )>
	 <cfloop array = #container_nav# index="cn">
		<a href="#link( "#cn.href#?id=#participant_id#" )#">
			<cfif data.page eq Left( cn.href, Len( cn.href ) - 4 )>
			<li class="selected">#cn.title#</li>
			<cfelse>
			<li>#cn.title#</li>
			</cfif>
		</a>
	 </cfloop>
	<cfelse>
	 <cfloop array = #container_nav# index="cn">
		<a href="#link( "#cn.href#?id=#participant_id#" )#">
			<li class="selected">#cn.title#</li>
		</a>
	 </cfloop>
	</cfif>
	</ul>
</cfoutput>
</div>
