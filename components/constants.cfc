/* -------------------------------------------------- * 
	constants.cfc

  List of all constants.

	Defaults can be here too, but I'm not sure if this is
	better or worse than putting them in db.  Especially
	since everybody needs them.
 * -------------------------------------------------- */
/*
component name="constants" {

	property Numeric name="bpDaysLimit" default=30
*/
<cfscript>
const = {
	 bpDaysLimit=30
	,bpMinSystolic = 40 
	,bpMaxSystolic = 160
	,bpMinDiastolic = 40
	,bpMaxDiastolic = 90
	,ENDURANCE = 1
	,RESISTANCE = 2
	,ENDURANCE_CLASSIFIERS = "ADUEndur,ATHEndur,ADUEnddur"
	,RESISTANCE_CLASSIFIERS = "ADUResist,ATHResist"
	,CONTROL_CLASSIFIERS = "ADUControl"
	,ENDURANCE = "ADUEndur,ATHEndur,ADUEnddur"
	,RESISTANCE = "ADUResist,ATHResist"
	,CONTROL = "ADUControl"
	,E = 1
	,R = 2
	,C = 3
};
</cfscript>
