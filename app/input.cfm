<!---
input.cfm
---------
--->
<cfscript>
if ( isDefined( "currentParticipant" ) ) {
	if ( ListContains( ENDURANCE, currentParticipant.results.randomGroupCode ) ) {
		//No way to actually do a publically exposed model, so I'll settle for this...
		clijs = CreateObject( "component", "components.writeback" );
		obj   = CreateObject( "component", "components.endurance" ).init();
		ptime = (StructKeyExists( url, "time" )) ? url.time : 0;

		private = {
		  time = ptime 
		 ,designation = (ptime eq 50) ? "m5_rec" : obj.getTimeInfo( ptime ).label 
		 ,eTypeLabels = [ "Cycle", "Treadmill", "Other" ]
		};

		//Recall endurance data from the current or last session
		private.query = qu = ezdb.exec(
			string = "
			SELECT * FROM
				( SELECT * FROM
					#data.data.endurance#
				WHERE
					participantGUID = :pid
					AND stdywk = :stdywk
					AND dayofwk = :dayofwk 
					AND recordthread = :rthrd
				) as cweek
			INNER JOIN
			( SELECT
				 rec_id as p_rec_id
				,recordthread as p_recordthread
				,participantGUID as p_participantGUID
				,dayofwk as p_dayofwk
				,stdywk as p_stdywk
				,#private.designation#hr as p_#private.designation#hr
				,#private.designation#oth1 as p_#private.designation#oth1
				,#private.designation#oth2 as p_#private.designation#oth2
				,#private.designation#prctgrade as p_#private.designation#prctgrade
				,#private.designation#rpm as p_#private.designation#rpm
				,#private.designation#speed as p_#private.designation#speed
				,#private.designation#watres as p_#private.designation#watres
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
				pid = sess.current.participantId 
			 ,rthrd = sess.csp.recordthread
			 ,stdywk = sess.csp.week 
			 ,dayofwk = sess.current.day 
			 ,pstdywk = ((sess.current.day - 1) == 0) ? sess.csp.week - 1 : sess.csp.week
			 ,pdayofwk = (( sess.current.day - 1 ) == 0) ? 4 : sess.current.day - 1
			});

		public = {
		  cssClassName = "endurance-class"
		 ,eTypeLabel   = private.eTypeLabels[ sess.csp.exerciseParameter ]
		 ,formValues   = obj.getLabelsFor( sess.csp.exerciseParameter )
		 ,selectedTime = private.time 
		 ,timeList     = obj.getEndurance()
		};

		cssClassName = "endurance-class";

		//Loop through and add query results to the source data.
		for ( n in public.formValues ) {
			n.prv = private.query.results[ "p_#private.designation##n.formname#" ]; 
			n.def = private.query.results[ "#private.designation##n.formname#" ]; 
		}

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
		 ,{ name="exParam", value= "#sess.csp.exerciseParameter#" }
		 ,{ name="pid", value= "#sess.current.participantId#" }
		 ,{ name="recordThread", value= "#sess.csp.recordthread#" }
		 ,{ name="dayofwk", value= "#sess.current.day#" }
		 ,{ name="stdywk", value= "#sess.csp.week#" }
		 ,{ name="sess_id", value= "#sess.key#" }
			]
		);
	}
	else if ( ListContains(RESISTANCE, currentParticipant.results.randomGroupCode) ) {
		cssClassName="resistance-class";
		type = (StructKeyExists(url,"extype")) ? url.extype : 1;
		pid = sess.current.participantId; 
		aweek = StructKeyExists( old_ws, "ps_week" ) ? old_ws.ps_week : 1;
		aday = StructKeyExists( old_ws, "ps_day" ) ? old_ws.ps_day : 1;
		res=createObject("component","components.resistance").init();

		//Pull all exercises	
		//ezdb.exec( string="SELECT * FROM #data.data.exerciseList#" );
		reExList=exe.getSpecificExercises( sess.csp.exerciseParameter );

		//Pull one exercise
		reExSel =ezdb.exec( 
			string="SELECT * FROM #data.data.exerciseList# WHERE et_id = :et_id", 
			bindArgs={ et_id = type } );

		//Pull exercise name	
		desig = res.getExerciseName( type ).desig; 

		//Get the entries in the table.
		qu = ezdb.exec(
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
					AND recordthread = :rthrd
			) AS cweek
			ON pweek.pguid = cweek.participantGUID
			"
		 ,bindArgs = {
				pid = sess.current.participantId
			 ,rthrd = { value = sess.csp.recordthread, type = "varchar" }
			 ,stdywk = aweek
			 ,dayofwk = aday
			 ,pstdywk = ((sess.current.day - 1) == 0) ? aweek - 1 : aweek
			 ,pdayofwk = (( aday - 1 ) == 0) ? 4 : aday - 1
			});

//writedump( qu ); abort;

		//Generate the form from either db or something else...
		pc = qu.prefix.recordCount;
		values = [
			 {label="Set 1", uom="lb",min = 5, max = 100, step = 5, name = "weight1"
				,def = qu.results[ "#desig#Wt1" ], prv = qu.results[ "p_#desig#Wt1" ] }
			,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps1"
				,def = qu.results[ "#desig#Rep1" ], prv = qu.results[ "p_#desig#Rep1" ] }
			,{label="Set 2", uom="lb",min = 5, max = 100, step = 5, name = "weight2"
				,def = qu.results[ "#desig#Wt2" ], prv = qu.results[ "p_#desig#Wt2" ] }
			,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps2" 
				,def = qu.results[ "#desig#Rep2" ], prv = qu.results[ "p_#desig#Rep2" ] }
			,{label="Set 3", uom="lb",min = 5, max = 100, step = 5, name = "weight3"
				,def = qu.results[ "#desig#Wt3" ], prv = qu.results[ "p_#desig#Wt3" ] }
			,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps3"
				,def = qu.results[ "#desig#Rep3" ], prv = qu.results[ "p_#desig#Rep3" ] }
		];
		
		//Initialize AJAX
		AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
			location = link( "update.cfm" ) 
		 /*,showDebug = true*/
		 ,showDebug = true
		 ,additional = [ 
				{ name = "this", value = "resistance" }
			 ,{ name = "sess_id", value = "#sess.key#" }
			 ,{ name="recordThread", value= "#sess.csp.recordthread#" }
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
//writedump( qu ); abort;
}
</cfscript>
