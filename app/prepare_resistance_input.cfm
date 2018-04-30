<cfscript>
if ( isDefined("part") && part.p_exercise eq 2 ) 
{
	type = (StructKeyExists(url,"extype")) ? url.extype : 1;
	pid = url.id;

	//Pull all exercises	
	reExList=ezdb.exec( 
		string="SELECT * FROM #data.data.exerciseList#", 
		datasource="#data.source#" );

	//Pull one exercise
	reExSel =ezdb.exec( 
		string="SELECT * FROM #data.data.exerciseList# WHERE et_id = :et_id", 
		datasource = "#data.source#",
		bindArgs={ et_id = type } );

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
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = "#pid#"
		 ,sid = "#sess.key#"
		 ,extype = "#type#"
		});

	//Generate the form from either db or something else...
	pc = pop.prefix.recordCount;
	values = [
		 {label="Set 1", uom="lb",min = 5, max = 100, step = 5, name = "weight1"
			,def = (!pc) ? 50 : pop.results.el_re_weight1 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps1"
			,def = (!pc) ? 0 : pop.results.el_re_reps1 }
		,{label="Set 2", uom="lb",min = 5, max = 100, step = 5, name = "weight2"
			,def = (!pc) ? 50 : pop.results.el_re_weight2 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps2" 
			,def = (!pc) ? 0 : pop.results.el_re_reps2 }
		,{label="Set 3", uom="lb",min = 5, max = 100, step = 5, name = "weight3"
			,def = (!pc) ? 50 : pop.results.el_re_weight3 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "reps3"
			,def = (!pc) ? 0 : pop.results.el_re_reps3 }
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
		 ,{ name = "el_re_extype", value = "#type#" }
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
