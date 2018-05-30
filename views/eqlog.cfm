<cfoutput>
<table>
	<tr>		
		<th>Mfg Desc</th>
		<th>Model Desc</th>
		<th>Setting Desc</th>
		<th>Site GUID</th>
	</tr>		
<Cfloop query="#eqlog.results#">
	<tr>		
		<td>#ManufacturerDescription#</td>
		<td>#ModelDescription#</td>
		<td>#SettingDescription#</td>
		<td>#siteGUID#</td>
	</tr>		
</cfloop>
</table>
</cfoutput>
