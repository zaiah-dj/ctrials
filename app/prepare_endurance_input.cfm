<cfscript>
if ( isDefined( "part" ) && part.p_exercise eq 1 ) 
{
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
	defaultTimeblock = ( StructKeyExists( url, "time" ) ) ? url.time : 5;

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
	req = ezdb.exec(
		string = "
			SELECT * FROM
				#data.data.endurance#
			WHERE
				participantGUID = :pid"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = "#url.id#"
		 ,sid = "#sess.key#"
		 ,tb  = "#defaultTimeblock#"
		});

	//Values?
	rc = req.prefix.recordCount;	
	values = [
		{ show = true, label = "RPM", uom = "",  min = 20, max = 120, step = 1, name = "rpm"
			,def = req.results[ "#desig#rpm" ] } 
	 ,{ show = true, label = "Watts/Resistance",uom = "", min = 0, max = 500, step = 1, name = "watts_resistance"
			,def = req.results[ "#desig#watres" ] }
	 ,{	show = true, label = "MPH/Speed", uom = "",    min = 0.1, max = 15, step = 0.5, name = "speed"
			,def = req.results[ "#desig#speed" ] }
	 ,{ show = true, label = "Percent Grade", uom = "",    min = 0, max = 15, step = 1, name = "grade"
			,def = req.results[ "#desig#prctgrade" ] }
/*	 ,{ show = true, label = "Perceived Exertion Rating",uom = "",    min = 0, max = 5,step = 1, name = "rpe"
			,def = req.results[ "#desig#rpe" ] }*/
	 ,{ show = true, label = "Affect",uom = "",    min = -5, max = 5, step = 1, name = "affect"
		  ,def = 0/*"#(!rc) ? 0 : iif((req.results.el_ee_perceived_exertion eq ""),0,req.results.el_ee_perceived_exertion)#"*/ }
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
	 ,{ name="sess_id", value= "#sess.key#" }
		]
	);
}
</cfscript>
