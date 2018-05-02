<cfparam name="url.id" default="">
<cfparam name="session.id" default="">
<cfscript>
if ( isDefined( "part" ) && part.p_exercise eq 1 ) 
{
	clijs = CreateObject( "component", "components.writeback" );
	//Generate the time blocks for endurance exercises.
	times = [
		 { index=0,  text="Warm-Up" }
		,{ index=5,  text='<5m'  }
		,{ index=10, text='<10m' }
		,{ index=15, text='<15m' }
		,{ index=20, text='<20m' }
		,{ index=25, text='<25m' }
		,{ index=30, text='<30m' }
		,{ index=35, text='<35m' }
		,{ index=40, text='<40m' }
		,{ index=45, text='<45m' }
		,{ index=50, text='<50m' }
		,{ index=55, text='Recovery' }
	];

	//Generate a default time.
	defaultTimeblock = ( StructKeyExists( url, "time" ) ) ? url.time : 0;

	//Figure out the form field name 
	desig = "";
	if ( defaultTimeblock eq 0 )
		desig = "wrmup_";
	else if ( defaultTimeblock gt 45 )
		desig = "m5_rec";
	else { 
		desig = "m#defaultTimeblock#_ex";
	}

	//Get queries for recall
	ezdb.setDs = "#data.source#";
	prv = ezdb.exec(
		string = "
			SELECT * FROM
				#data.data.endurance#
			WHERE
				participantGUID = :pid
			AND stdywk = :stdywk
			AND dayofwk = :dayofwk
		"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = currentId
		 ,stdywk = old_ws.ps_week - 1 
		 ,dayofwk = old_ws.ps_day
		});

	req = ezdb.exec(
		string = "
			SELECT * FROM
				#data.data.endurance#
			WHERE
				participantGUID = :pid
			AND stdywk = :stdywk
			AND dayofwk = :dayofwk
		"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = currentId
		 ,stdywk = old_ws.ps_week 
		 ,dayofwk = old_ws.ps_day
		});

	//Prefill any values that need to be prefilled	 
//writedump( req );writedump( prv );abort;
	rc = req.prefix.recordCount;	
	rpm = ( rc ) ? req.results[ "#desig#rpm" ] : 0;
	watres = ( rc ) ? req.results[ "#desig#watres" ] : 0;
	speed = ( rc ) ? req.results[ "#desig#speed" ] : 0;
	prctgrade = ( rc ) ? req.results[ "#desig#prctgrade" ] : 0;
	prpm = ( rc ) ? prv.results[ "#desig#rpm" ] : 0;
	pwatres = ( rc ) ? prv.results[ "#desig#watres" ] : 0;
	pspeed = ( rc ) ? prv.results[ "#desig#speed" ] : 0;
	pprctgrade = ( rc ) ? prv.results[ "#desig#prctgrade" ] : 0;

	values = [
		{ show = true, label = "RPM", uom = "",  min = 20, max = 120, step = 1, name = "rpm"
			,def = rpm, prv = prpm }
	 ,{ show = true, label = "Watts/Resistance",uom = "", min = 0, max = 500, step = 1, name = "watts_resistance"
			,def = watres, prv = pwatres }
	 ,{	show = true, label = "MPH/Speed", uom = "",    min = 0.1, max = 15, step = 0.5, name = "speed"
			,def = speed, prv = pspeed }
	 ,{ show = true, label = "Percent Grade", uom = "",    min = 0, max = 15, step = 1, name = "grade"
			,def = prctgrade, prv = pprctgrade }
/*	 ,{ show = true, label = "Perceived Exertion Rating",uom = "",    min = 0, max = 5,step = 1, name = "rpe"
			,def = req.results[ "#desig#rpe" ] }*/
	 ,{ show = true, label = "Affect",uom = "",    min = -5, max = 5, step = 1, name = "affect"
		  ,def = 0, prv = 0 }
	];

	// Initialize client side AJAX code 
	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update.cfm" )
	 ,showDebug = true
	 ,querySelector = [{
			dom = "##participant_list li, .participant-info-nav li, .inner-selection li, ##sendPageVals"
		 ,event = "click"
		 ,noPreventDefault = true
		 ,send = "input, select" 
		}]
	 ,additional = [ 
		{ name="this", value= "endurance" }
	 ,{ name="pid", value= "#url.id#" }
	 ,{ name="dayofwk", value= "#old_ws.ps_day#" }
	 ,{ name="stdywk", value= "#old_ws.ps_week#" }
	 ,{ name="sess_id", value= "#sess.key#" }
		]
	);
}
</cfscript>
