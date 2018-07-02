<cfscript>
/* input.cfm */
if ( isDefined( "currentParticipant" ) ) {
	if ( ListContains( ENDURANCE, currentParticipant.results.randomGroupCode ) ) {
		//No way to actually do a publically exposed model, so I'll settle for this...
		ptime = (StructKeyExists( url, "time" )) ? url.time : 0;

		private = {
		  time = ptime 
		 ,designation = (ptime eq 50) ? "m5_rec" : endobj.getTimeInfo( ptime ).label 
		 ,eTypeLabels = [ "Cycle", "Treadmill", "Other" ]
		};

		//Check if there are any entries at all.
		private.checkAny = ezdb.exec(
			string = "
				SELECT * FROM #data.data.endurance#
				WHERE participantGUID = :pid
			"
		 ,bindArgs = { pid = sess.current.participantId }
		);
	
		private.lastPrev = ezdb.exec(
			string = "
				SELECT TOP (1) 
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
				AND
					stdywk <= :cweek
				ORDER BY
					stdywk DESC, dayofwk DESC
			"
		, bindArgs = {
				pid = sess.current.participantId 
			 ,cweek = sess.csp.week
		});
				
		//Recall endurance data from the current or last session
		private.query = qu = ezdb.exec(
			string = "
			SELECT * FROM
				( SELECT
						 rec_id 
						,recordthread 
						,participantGUID 
						,dayofwk 
						,stdywk 
						,#private.designation#hr 
						,#private.designation#oth1 
						,#private.designation#oth2 
						,#private.designation#prctgrade 
						,#private.designation#rpm 
						,#private.designation#speed 
						,#private.designation#watres 
						,mchntype 
						,nomchntype 
						,Sessionmisd 
						,breaks 
					FROM
					#data.data.endurance#
				WHERE
					participantGUID = :pid
					AND stdywk = :stdywk
					AND dayofwk = :dayofwk 
					AND recordthread = :rthrd
				) as cweek
			INNER JOIN
			(	SELECT TOP (1) 
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
				AND
					stdywk <= :stdywk
				ORDER BY
					stdywk DESC, dayofwk DESC ) as pweek
			ON pweek.p_participantGUID = cweek.participantGUID
			"
		 ,datasource = "#data.source#"
		 ,bindArgs = {
				pid = sess.current.participantId 
			 ,rthrd = sess.csp.recordthread
			 ,stdywk = sess.csp.week 
			 ,dayofwk = sess.current.day 
			});

		public = {
		  cssClassName = "endurance-class"
		 ,eTypeLabel   = private.eTypeLabels[ sess.csp.exerciseParameter ]
		 ,formValues   = endobj.getLabelsFor( sess.csp.exerciseParameter )
		 ,selectedTime = private.time 
		 ,timeList     = endobj.getEndurance()
		};

		cssClassName = "endurance-class";

		//Loop through and add query results to the source data.
		for ( n in public.formValues ) {
			n.prv = private.query.results[ "p_#private.designation##n.formname#" ]; 
			n.def = private.query.results[ "#private.designation##n.formname#" ]; 
		}
/*
		//Add heart rate
		if ( ListContains( private.time, "0,10,20,30,45" ) )
			ArrayAppend( public.formValues, {uom="", label="Heart Rate",min=10,max=300,step=1,formName="hr" } );

		//Add rpe and affect
		if ( ListContains( private.time, "0,20,45" ) ) {
			ArrayAppend( public.formValues, {uom="", label="RPE (Borg)",min=10,max=300,step=1,formName="rpe" } );
			ArrayAppend( public.formValues, {uom="", label="Affect",min=10,max=300,step=1,formName="affect" } );
		}
*/				
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
		private = {
			cssClassName="resistance-class"

		 ,exlist = resobj.getSpecificExercises( sess.csp.exerciseParameter )

		 ,type = (StructKeyExists(url,"extype")) ? url.extype : 
				( sess.csp.exerciseParameter eq 4 ) ? 1 : 3
		};

		private.loadedExercise = resobj.getExerciseName( private.type );
		private.designation = private.loadedExercise.formName;

		//Get the entries in the table.
		private.query = ezdb.exec(
			string = "
			SELECT * FROM
			( SELECT
				 [rec_id] as p_rec_id
				,[recordthread] as p_recordthread
				,[participantGUID] as pguid 
				,[#private.designation#Wt1] as p_#private.designation#Wt1
				,[#private.designation#Wt2] as p_#private.designation#Wt2
				,[#private.designation#Wt3] as p_#private.designation#Wt3
				,[#private.designation#Rep1] as p_#private.designation#Rep1
				,[#private.designation#Rep2] as p_#private.designation#Rep2
				,[#private.designation#Rep3] as p_#private.designation#Rep3
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
			 ,stdywk = sess.csp.week 
			 ,dayofwk = sess.current.day
			 ,pstdywk = ((sess.current.day - 1) == 0) ? sess.csp.week - 1 : sess.csp.week
			 ,pdayofwk = (( sess.current.day - 1 ) == 0) ? 4 : sess.current.day - 1
			});


		//...
		public = {
		  selName = private.loadedExercise.pname
		 ,reExList = private.exlist
		 ,formValues = resobj.getLabels()
		 ,type = private.type
		};

		//Loop through and add query results to the source data.
		for ( n in public.formValues ) {
			n.prv = private.query.results[ "p_#private.designation##n.formname#" ]; 
			n.def = private.query.results[ "#private.designation##n.formname#" ]; 
		}

		//Initialize AJAX
		AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
			location = link( "update.cfm" ) 
		 /*,showDebug = true*/
		 ,showDebug = true
		 ,additional = [ 
				{ name = "this", value = "resistance" }
			 ,{ name = "sess_id", value = "#sess.key#" }
			 ,{ name="recordThread", value= "#sess.csp.recordthread#" }
			 ,{ name = "pid", value = "#sess.current.participantId#" }
			 ,{ name = "dayofwk", value= "#sess.current.day#" }
			 ,{ name = "stdywk", value= "#sess.csp.week#" }
			 ,{ name = "extype", value = "#private.type#" }
			]
		 ,querySelector = {
				dom = "##participant_list li, .participant-info-nav li, .inner-selection li, ##sendPageVals"
			 ,event = "click"
			 ,noPreventDefault = true
			 ,send = ".slider"
			}
		);
	}
}
</cfscript>
