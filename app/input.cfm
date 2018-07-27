<cfscript>
/* input.cfm */

/*

run thru this w/ me


STEP 1: ARRANGE ALL OF THIS CODE SO THAT IT SUCKS LESS
======================================================
regardless of choice, I need:

past res (prev day if same week contains additional results, last week's last day if currentweek > 1 and no other results for the current week )
present res (if available)
a magic identifier ( re = exercise set, ee = exercise timeblock )
an exercise list

optional: a component file with labels and units of measure, but this can just as easily be done in either of the above queries



STEP 2: MERGE THE GIANT QUERIES
======================================================
after this, to not write a whole lot of extra template code, combine the two queries using the following: 
for ( n in prefix ) {
	ArrayAppend( columnNames, n );
	ArrayAppend( columnTypes, n.getType() );
}

for ( n in results ) {
	ArrayAppend( queryValues, { n.key = n.value } );
}

mn = new query(
	ArrayToList( columnNames )
 ,ArrayToList( columnTypes )
 ,queryValues
);	
mn.setName( "c_and_p" );
mn.setDBType( "query" );
mn.setAttributes( sourceQuery = c_and_p );

//Writeout what's going in frere                                    
//writedump( mn );

//loop through on the frontend


STEP 3: CHECK AGAINST PREVIOUS RECORDS THAT WERE IN THE ORIGINAL TABLE
======================================================
this is probably the most time consuming piece

go through previous weeks and check that results pulling works. 

use my own table for this




 */



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

		private.query = dbExec(
			filename = "input-eePastAndCurrent.sql"
		 ,bindArgs = {
				pid = sess.current.participantId 
			 ,endurance = data.data.endurance
			 ,rthrd = sess.csp.recordthread
			 ,stdywk = sess.csp.week 
			 ,dayofwk = sess.current.day 
		});

		public = {
		  cssClassName = "endurance-class"
		 ,eTypeLabel   = private.eTypeLabels[ sess.csp.exerciseParameter ]
		 ,formValues   = endobj.getLabelsFor( sess.csp.exerciseParameter, private.time )
		 ,selectedTime = private.time 
		 ,timeList     = endobj.getEndurance()
		};

		cssClassName = "endurance-class";

		//Loop through and add query results to the source data.
		for ( n in public.formValues ) {
			n.prv = private.query.results[ "p_#private.designation##n.formname#" ]; 
			n.def = private.query.results[ "#private.designation##n.formname#" ]; 
			if ( n.type eq 3 ) {
				n.uom = "uom";
				n.label = private.query.results[ "#n.label#" ];
			}
		}
				
//writedump( private );
//abort;
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
			 ,{ name="insBy", value = "#sgid#" }
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

		private.selection = (StructKeyExists( url, "set" )) ? 
			(( url.set < 1 || url.set > 6 ) ? 1 : url.set ) : 1;

		private.loadedExercise = resobj.getExerciseName( private.type );
		
		private.designation = private.loadedExercise.formName;

		private.exarr = [
		 "268AA2A1-24B9-439D-A249-8BB77C14A203"
		,"918EE32D-EA22-48B2-810F-B0B80F6DE011"
		,"D7307741-EA1C-44A2-A0D8-ECBA549334DA"
		,"6B026296-D237-41EB-9B3C-EFD932CA3282"
		,"08334B5D-114D-4576-9EDC-FBB9163F5B61"
		,"5C8D84BE-63FF-49F5-A095-BCD9C68EC049"
		,"3BD0A9C3-BA50-485A-802B-28D927250481"
		,"162D5A58-B5E2-4A9F-9255-00CB2FAE560A"
		,"75A86ADB-BA66-48BB-ABE4-946608D6D298"
		,"D60B18B7-08B3-489F-B869-D0E4582DFA61"
		,"C2576D22-0925-4ED8-9863-EBC7B9968646"
		,"2534F4B4-A551-4FDF-A4A5-D8E26D157609"
		,"8446D9BD-8656-45E4-9B95-87E5E6B54EC7"
		,"21CCBAEF-9F5E-4EB6-A3AC-71AB47B8781A"
		,"E42C8006-567E-4666-A395-1B6D8673758E"
		,"8FCA3C6B-2ADF-4BDA-8A42-4CBFA91137CC"];


		//Can load machines per exercise (sometimes there's multiple that could be chosen, should be a dropdown)
		//Can load settings per machine
	

		//Equipment log
		exerciseId = private.exarr[ 9 ];	
		private.allSettingsPerExercise = ezdb.exec(
			string = "
	SELECT DISTINCT * FROM
	( SELECT settingGUID AS stgGUID, settingDescription FROM #data.data.etst# ) As Sett
	INNER JOIN
	(	SELECT * FROM
		( 
			SELECT * FROM
			( 
				SELECT * FROM
				( SELECT 
						machineGUID as a_maguid
					 ,manufacturerGUID as a_mnguid
					FROM #data.data.etma# ) As Ma
				INNER JOIN
				( SELECT
						manufacturerGUID
					 ,manufacturerDescription
					FROM #data.data.etmn# ) As Mn
				ON Ma.a_mnguid = Mn.manufacturerGUID
			) As AllManufacturers
			INNER JOIN
			( 
				SELECT * FROM
				( SELECT 
						machineGUID as b_maguid
				   ,modelGUID as b_moguid
					FROM #data.data.etma# ) As Ma
				INNER JOIN
				( SELECT 
						modelGUID
					 ,modelDescription
					FROM #data.data.etmo# ) As Mo
				ON Ma.b_moguid = Mo.modelGUID
			) As AllModels
			ON AllManufacturers.a_maguid = AllModels.b_maguid 
		) As Machines

		INNER JOIN
		(
			SELECT * FROM
				( SELECT * FROM #data.data.etex# ) AS EXY
				INNER JOIN
				(
					SELECT * FROM
					( SELECT * FROM 
						#data.data.participants# 
						WHERE participantGUID = :pid ) AS PT
					INNER JOIN
					(
						SELECT 
							 siteGUID AS sGUID
							,equipmentGUID
							,settingGUID	
							,machineGUID
							,exerciseGUID AS exGUID
						FROM
							( SELECT DISTINCT
									siteGUID AS ETSSITEGUID
								 ,equipmentGUID AS eGUID
								 ,settingGUID	
								FROM
								#data.data.et#
							) AS ETS
						INNER JOIN
							( SELECT DISTINCT
									siteGUID
								 ,machineGUID
								 ,equipmentGUID
								 ,exerciseGUID
								 ,active
								FROM 
									#data.data.eteq# 
								WHERE 
									active = 1
								AND
									interventionGUID = 'BE3D6628-7BC2-452C-92AC-9F03B992316B'
							) AS ETE
						ON ETS.ETSSITEGUID = ETE.siteGUID 
					) AS PE 
					ON PT.siteGUID = PE.sGUID  
					WHERE exGUID = :exc
				) AS AXY
				ON EXY.exerciseGUID = AXY.exGUID
			) As ABB 
			ON Machines.a_maguid = ABB.machineGUID
		) AS Other
		ON Sett.stgGUID = Other.settingGUID
			"
		 ,bindArgs = {
				pid = sess.current.participantId,
				exc = exerciseId
			}	
		);

		//To just get the machine name, I can use qoq and trim further	
		mn = new query();	
		mn.setName( "juice" );
		mn.setDBType( "query" );
		mn.setAttributes( sourceQuery = private.allSettingsPerExercise.results );
		qr = mn.execute( sql = "SELECT DISTINCT manufacturerdescription, modeldescription FROM sourceQuery" );
		qr = qr.getResult();

		private.query = dbExec(
			filename = "input-rePastAndCurrent.sql"
		 ,bindArgs = {
				pid = sess.current.participantId 
			 ,resistance = data.data.resistance
			 ,rthrd = sess.csp.recordthread
			 ,stdywk = sess.csp.week 
			 ,dayofwk = sess.current.day 
		});

		//TODO: Create a superset db, and change these indices again
		public = {
		  selName = private.loadedExercise.pname
		 ,reExList = private.exlist
		 ,formValues = resobj.getLabels( )
		 ,type = private.type
		 ,machineFullName = qr.manufacturerdescription & " " & qr.modeldescription
		 ,selection = private.selection
		 ,setlinks = [
				{ index=1, name="Set 1" }	
			 ,{ index=2, name="Set 2" }	
			 ,{ index=3, name="Set 3" }	
			]
		};

		//Eww, all of these links are so ugly...
		lin = "#cgi.script_name#?id=#sess.current.participantId#&extype=#public.type#";

		//Loop through and add query results to the source data.
		for ( n in public.formValues ) {
			n.prv = private.query.results[ "p_#private.designation##n.formname#" ]; 
			n.def = private.query.results[ "#private.designation##n.formname#" ]; 
		}


writedump( private );
abort;


		//Initialize AJAX
		AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
			location = link( "update.cfm" ) 
		 /*,showDebug = true*/
		 ,showDebug = true
		 ,additional = [ 
				{ name = "this", value = "resistance" }
			 ,{ name = "sess_id", value = "#sess.key#" }
			 ,{ name = "recordThread", value= "#sess.csp.recordthread#" }
			 ,{ name = "pid", value = "#sess.current.participantId#" }
			 ,{ name = "dayofwk", value= "#sess.current.day#" }
			 ,{ name = "stdywk", value= "#sess.csp.week#" }
			 ,{ name = "extype", value = "#private.type#" }
			 ,{ name = "insBy", value = "#sgid#" }
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
