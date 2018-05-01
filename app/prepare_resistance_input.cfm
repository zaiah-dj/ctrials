<cfscript>
if ( isDefined("part") && part.p_exercise eq 2 ) 
{
	type = (StructKeyExists(url,"extype")) ? url.extype : 1;
	pid = url.id;

	//Pull all exercises	
	reExList=ezdb.exec( string="SELECT * FROM #data.data.exerciseList#" );

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

	//Get the entries in the table.
	pop = ezdb.exec(
		string = "
		SELECT * FROM 
			ac_mtr_exercise_log_re 
		WHERE 
			el_re_pid = :pid 
		AND 
			el_re_ex_session_id = :sid 
		AND 
			el_re_extype = :extype"
	 ,bindArgs = {
			pid = "#pid#"
		 ,sid = "#sess.key#"
		 ,extype = "#type#"
		});


	pop = ezdb.exec(
		string = "
		SELECT * FROM 
			#data.data.resistance#	
		WHERE 
			participantGUID = :pid 
		"
	 ,bindArgs = {
			pid = "#pid#"
		 ,extype = "#type#"
		});

	//Generate the form from either db or something else...
	pc = pop.prefix.recordCount;
	w1 = ( pc ) ? pop.results[ "#desig#Wt1" ] : 0;
	w2 = ( pc ) ? pop.results[ "#desig#Wt2" ] : 0;
	w3 = ( pc ) ? pop.results[ "#desig#Wt3" ] : 0;
	r1 = ( pc ) ? pop.results[ "#desig#Rep1" ] : 0;
	r2 = ( pc ) ? pop.results[ "#desig#Rep2" ] : 0;
	r3 = ( pc ) ? pop.results[ "#desig#Rep3" ] : 0;

	values = [
		 {label="Set 1", uom="lb",min = 5, max = 100, step = 5, name = "weight1"
			,def = w1 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps1"
			,def = r1 }
		,{label="Set 2", uom="lb",min = 5, max = 100, step = 5, name = "weight2"
			,def = w2 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps2" 
			,def = r2 }
		,{label="Set 3", uom="lb",min = 5, max = 100, step = 5, name = "weight3"
			,def = w3 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps3"
			,def = r3 }
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
