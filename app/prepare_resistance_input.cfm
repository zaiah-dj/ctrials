<cfscript>
if ( isDefined("currentParticipant") && ListContains(RESISTANCE, currentParticipant.results.randomGroupCode) ) {
	cssClassName="resistance-class";
	type = (StructKeyExists(url,"extype")) ? url.extype : 1;
	pid = sess.current.participantId; 
	aweek = StructKeyExists( old_ws, "ps_week" ) ? old_ws.ps_week : 1;
	aday = StructKeyExists( old_ws, "ps_day" ) ? old_ws.ps_day : 1;
	//ex=createObject("component","components.exercises").init();

	//Pull all exercises	
	//ezdb.exec( string="SELECT * FROM #data.data.exerciseList#" );
	reExList=exe.getSpecificExercises( sess.current.exerciseParameter );

	//Pull one exercise
	reExSel =ezdb.exec( 
		string="SELECT * FROM #data.data.exerciseList# WHERE et_id = :et_id", 
		bindArgs={ et_id = type } );

	//Figure out the form type.
	if ( type == 0 || type == 1 )
		desig = "abdominalcrunch";
	else if ( type == 2 )
		desig = "bicepcurl";
	else if ( type == 3 )
		desig = "calfpress";
	else if ( type == 4 )
		desig = "chest2";
	else if ( type == 5 )
		desig = "chestpress";
	else if ( type == 6 )
		desig = "dumbbellsquat";
	else if ( type == 7 )
		desig = "kneeextension";
	else if ( type == 8 )
		desig = "legcurl";
	else if ( type == 9 )
		desig = "legpress";
	else if ( type == 10 )
		desig = "overheadpress";
	else if ( type == 11 )
		desig = "pulldown";
	else if ( type == 12 )
		desig = "seatedrow";
	else if ( type == 13 )
		desig = "shoulder2";
	else if ( type == 14 )
		desig = "triceppress";
/*
	prv = ezdb.exec(
		string = "
		SELECT * FROM 
			#data.data.resistance#	
		WHERE 
			participantGUID = :pid 
			AND stdywk = :stdywk
			AND dayofwk = :dayofwk
		"
	 ,bindArgs = {
			pid = sess.current.participantId
		 ,stdywk = aweek - 1 
		 ,dayofwk = aday
		});
*/
	//Get the entries in the table.
	pop = ezdb.exec(
		string = "
		SELECT * FROM
		( SELECT
			 [rec_id] as p_rec_id
      ,[recordthread] as p_recordthread
      ,[participantGUID] as pguid 
			,[#desig#Wt1] as p_#desig#Wt1
			,[#desig#Wt2] as p_#desig#Wt2
			,[#desig#Wt3] as p_#desig#Wt3
			,[#desig#Rep1] as p_#desig#Rep1
			,[#desig#Rep2] as p_#desig#Rep2
			,[#desig#Rep3] as p_#desig#Rep3
			FROM 
				#data.data.resistance#
			WHERE 
				participantGUID = :pid 
				AND stdywk = :pstdywk
				AND dayofwk = :pdayofwk
		) AS pweek
		INNER JOIN
		( SELECT 
				* 
			FROM 
				#data.data.resistance#	
			WHERE 
				participantGUID = :pid 
				AND stdywk = :stdywk
				AND dayofwk = :dayofwk
		) AS cweek
		ON pweek.pguid = cweek.participantGUID
		"
	 ,bindArgs = {
			pid = sess.current.participantId
		 ,stdywk = aweek
		 ,dayofwk = aday
		 ,pstdywk = ((sess.current.day - 1) == 0) ? aweek - 1 : aweek
		 ,pdayofwk = (( aday - 1 ) == 0) ? 4 : aday - 1
		});


	//Generate the form from either db or something else...
	pc = pop.prefix.recordCount;
	w1 = ( pc ) ? pop.results[ "#desig#Wt1" ] : 0;
	w2 = ( pc ) ? pop.results[ "#desig#Wt2" ] : 0;
	w3 = ( pc ) ? pop.results[ "#desig#Wt3" ] : 0;
	r1 = ( pc ) ? pop.results[ "#desig#Rep1" ] : 0;
	r2 = ( pc ) ? pop.results[ "#desig#Rep2" ] : 0;
	r3 = ( pc ) ? pop.results[ "#desig#Rep3" ] : 0;
/*
	pw1 = ( pc ) ? prv.results[ "#desig#Wt1" ] : 0;
	pw2 = ( pc ) ? prv.results[ "#desig#Wt2" ] : 0;
	pw3 = ( pc ) ? prv.results[ "#desig#Wt3" ] : 0;
	pr1 = ( pc ) ? prv.results[ "#desig#Rep1" ] : 0;
	pr2 = ( pc ) ? prv.results[ "#desig#Rep2" ] : 0;
	pr3 = ( pc ) ? prv.results[ "#desig#Rep3" ] : 0;
*/
	values = [
		 {label="Set 1", uom="lb",min = 5, max = 100, step = 5, name = "weight1"
			,def = pop.results[ "#desig#Wt1" ], prv = pop.results[ "p_#desig#Wt1" ] }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps1"
			,def = pop.results[ "#desig#Rep1" ], prv = pop.results[ "p_#desig#Rep1" ] }
		,{label="Set 2", uom="lb",min = 5, max = 100, step = 5, name = "weight2"
			,def = pop.results[ "#desig#Wt2" ], prv = pop.results[ "p_#desig#Wt2" ] }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps2" 
			,def = pop.results[ "#desig#Rep2" ], prv = pop.results[ "p_#desig#Rep2" ] }
		,{label="Set 3", uom="lb",min = 5, max = 100, step = 5, name = "weight3"
			,def = pop.results[ "#desig#Wt3" ], prv = pop.results[ "p_#desig#Wt3" ] }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps3"
			,def = pop.results[ "#desig#Rep3" ], prv = pop.results[ "p_#desig#Rep3" ] }
	];
	
	//Initialize AJAX
	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update.cfm" ) 
	 /*,showDebug = true*/
	 ,showDebug = true
	 ,additional = [ 
			{ name = "this", value = "resistance" }
		 ,{ name = "sess_id", value = "#sess.key#" }
		 ,{ name = "pid", value = "#pid#" }
		 ,{ name = "dayofwk", value= "#aday#" }
		 ,{ name = "stdywk", value= "#aweek#" }
		 ,{ name = "extype", value = "#type#" }
		]
	 ,querySelector = {
			dom = "##participant_list li, .participant-info-nav li, .inner-selection li, ##sendPageVals"
		 ,event = "click"
		 ,noPreventDefault = true
		 ,send = ".slider"
		}
	);
}
</cfscript>
