<cfparam name="url.id" default="">
<cfparam name="session.id" default="">
<cfscript>
if ( isDefined( "part" ) && ListContains( ENDURANCE, part.results.randomGroupCode ) )
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
		//,{ index=50, text='<50m' }
		//,{ index=55, text='Recovery' }
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
	/*
	//This will work for regular usage, if going back in time though, still not right.. 
	ranges = ezdb.exec(
		string = "
			SELECT
				MAX( stdywk ) as mstdywk 
			 ,MAX( dayofwk ) as mdayofwk
			FROM
				#data.data.endurance#
			WHERE
				participantGUID = :pid
			GROUP BY
				participantGUID
		"
	 ,datasource = "#data.source#"
	 ,bindArgs = { pid = currentId });
	*/
/*
	prv = ezdb.exec(
		string = "
			SELECT * 
			FROM
				#data.data.endurance#
			WHERE
				participantGUID = :pid
			AND stdywk = :stdywk
			AND dayofwk = :dayofwk
		"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = currentId
		 ,stdywk = ((currentDay - 1) == 0) ? currentWeek - 1 : currentWeek
		 ,dayofwk = (( currentDay - 1 ) == 0) ? 4 : currentDay - 1
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
		 ,stdywk = currentWeek
		 ,dayofwk = currentDay
		});
*/

	req = ezdb.exec(
		string = "
		SELECT * FROM
			( SELECT * FROM
				#data.data.endurance#
			WHERE
				participantGUID = :pid
			AND stdywk = :stdywk
			AND dayofwk = :dayofwk ) as cweek
		INNER JOIN
		( SELECT
			 rec_id as p_rec_id
      ,recordthread as p_recordthread
      ,participantGUID as p_participantGUID
      ,dayofwk as p_dayofwk
      ,stdywk as p_stdywk
      ,#desig#hr as p_#desig#hr
      ,#desig#oth1 as p_#desig#oth1
      ,#desig#oth2 as p_#desig#oth2
      ,#desig#prctgrade as p_#desig#prctgrade
      ,#desig#rpm as p_#desig#rpm
      ,#desig#speed as p_#desig#speed
      ,#desig#watres as p_#desig#watres
      ,mchntype as p_mchntype
      ,nomchntype as p_nomchntype
      ,Sessionmisd as p_Sessionmisd
      ,breaks as p_breaks 
			FROM
				#data.data.endurance#
			WHERE
				participantGUID = :pid
			AND stdywk = :pstdywk
			AND dayofwk = :pdayofwk ) as pweek

		ON pweek.p_participantGUID = cweek.participantGUID
		"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = currentId
		 ,stdywk = currentWeek
		 ,dayofwk = currentDay
		 ,pstdywk = ((currentDay - 1) == 0) ? currentWeek - 1 : currentWeek
		 ,pdayofwk = (( currentDay - 1 ) == 0) ? 4 : currentDay - 1
		});

	//Prefill any values that need to be prefilled	 
	rc = req.prefix.recordCount;	

	values = [
		{ show = true, label = "RPM", uom = "",  min = 20, max = 120, step = 1, name = "rpm"
			,def = req.results[ "#desig#rpm" ], prv = req.results[ "p_#desig#rpm" ] }
	 ,{ show = true, label = "Watts/Resistance",uom = "", min = 0, max = 500, step = 1, name = "watts_resistance"
			,def = req.results[ "#desig#watres" ], prv = req.results[ "p_#desig#watres" ] }
	 ,{	show = true, label = "MPH/Speed", uom = "",    min = 0.1, max = 15, step = 0.5, name = "speed"
			,def = req.results[ "#desig#speed" ], prv = req.results[ "p_#desig#speed" ] }
	 ,{ show = true, label = "Percent Grade", uom = "",    min = 0, max = 15, step = 1, name = "grade"
			,def = req.results[ "#desig#prctgrade" ], prv = req.results[ "p_#desig#prctgrade" ] }
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
	 ,{ name="pid", value= "#currentId#" }
	 ,{ name="dayofwk", value= "#currentDay#" }
	 ,{ name="stdywk", value= "#currentWeek#" }
	 ,{ name="sess_id", value= "#sess.key#" }
		]
	);
}
</cfscript>
