<!--- add_participant.cfm --->
<cfscript>
req.sendAsJson( status = 0, message = "updated part table." ); abort;
//add
dbExec(
string = "
	INSERT INTO #data.data.sessiondpart# 
		( sp_sessdayid, 
			sp_participantrecordkey, 
			sp_participantGUID, 
			sp_participantrecordthread )
	VALUES 
		( :sessdayid, 
			:prkid, 
			:guid, 
			'' )
"
bindArgs = {

}
);
</cfscript>
