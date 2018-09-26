<!--- -------------------------------------------------------------------------
constants.cfm
=============

Notes:
------
These comments are written in Markdown and can be converted to HTML by running
`make doc`.


Date Created:        
------------
2018-09-25


Author(s):   
------------
-

Description: 
------------
A list of constants used throughout the MIV tracking app.

Summary:
--------
I got nothing else :)

 ---- ------------------------------------------------------------------------->
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

	//Unicode character symbols used for application parts
	,ampersand = "&##x2714"
	,thickArrow = "^" /*"&##x26f0"*/
	,hideNav = "V" /*"&##x26f0"*/


	,bpm = { uom="BPM", min=70, max=220, defaultValue=145, step=1, formName = "hr", label="Heart Rate" }
	,rpe = { uom="RPE", min=6, max=20, defaultValue=14, step=1, formName = "rpe", label="RPE" }
	,afct = { uom="", min=-5, max=5, defaultValue=0, step=1, formName = "Othafct", label="Affect" }

	,rpm = { uom="RPM", min=30, max=130, defaultValue=80, step=1, formName = "rpm", label="RPM" }
	,wr  = { uom="lb", min=0, max=50, defaultValue=25, step=1, formName = "watres", label="Watts/Resistance" }
	,mph = { uom="MPH", min=0, max=50, defaultValue=25, step=1, formName = "mph", label="Speed" }
	,prctgrade = { uom="RPM", min=0, max=20, defaultValue=10, step=1, formName = "prctgrade", label="%" }

	//frm_eetl constants
	,eetl_selections = [
		 { prefix="wrmup_", urlparam=0,  pname="Warm-Up" }
		,{ prefix="m5_ex" , urlparam=5,  pname="<5m"  }
		,{ prefix="m10_ex", urlparam=10, pname="<10m" }
		,{ prefix="m15_ex", urlparam=15, pname="<15m" }
		,{ prefix="m20_ex", urlparam=20, pname="<20m" }
		,{ prefix="m25_ex", urlparam=25, pname="<25m" }
		,{ prefix="m30_ex", urlparam=30, pname="<30m" }
		,{ prefix="m35_ex", urlparam=35, pname="<35m" }
		,{ prefix="m40_ex", urlparam=40, pname="<40m" }
		,{ prefix="m45_ex", urlparam=45, pname="<45m" }
		,{ prefix="m3_rec", urlparam=50, pname="3<super>rd</super> Minute Recovery" }
	]

	//frm_retl constants
	//,wt = { uom="lb", min=5, max=300, step=1, form
	,retl_selections = [
		 { prefix="wrmup_"         , urlparam=0, pname="5 Minute Warmup", class=0 }

		,{ prefix="legpress"       , urlparam=1, pname="Leg Press", class=1 }
		,{ prefix="modleg"         , urlparam=2, pname="Modified Leg Press", class=1 }
		,{ prefix="pulldown"       , urlparam=3, pname="Pulldown", class=1 }
		,{ prefix="legcurl"        , urlparam=4, pname="Leg Curl", class=1 }
		,{ prefix="seatedrow"      , urlparam=5, pname="Seated Row", class=1 }
		,{ prefix="kneeextension"  , urlparam=6, pname="Knee Extension", class=1 }
		,{ prefix="bicepcurl"      , urlparam=7, pname="Biceps Curl", class=1 }

		,{ prefix="chestpress"     , urlparam=8, pname="Chest Press", class=2 }
		,{ prefix="chest2"         , urlparam=9, pname="Chest ##2", class=2 }
		,{ prefix="abdominalcrunch", urlparam=10, pname="Abdominal Crunch", class=2 }
		,{ prefix="overheadpress"  , urlparam=11, pname="Overhead Press", class=2 }
		,{ prefix="calfpress"      , urlparam=12, pname="Calf Press", class=2 }
		,{ prefix="shoulder2"      , urlparam=13, pname="Non-Press Shoulder Exercise", class=2 }
		,{ prefix="triceppress"    , urlparam=14, pname="Tricep Push-Down", class=2 }

		//,{ prefix="dumbbellsquat"  , urlparam=5, pname="Dumbbell Squat", class=1 }
	 ]

};
</cfscript>
