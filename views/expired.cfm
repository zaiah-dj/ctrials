<div class="error">
	<cfif StructKeyExists( url, "id" )>
	<cfoutput><p>#reasons[ url.id ]#</p></cfoutput>
	</cfif>
</div>
