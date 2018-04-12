<!--- hi --->
<cfscript>
clijs = CreateObject( "component", "components.writeback" );
qu = CreateObject( "component", "components.quella" );
pid = #url.id#;

if ( part.p_exercise eq 0 ) { 
	; 
}
else if ( part.p_exercise eq 1 ) { 
	//Generate the time blocks for endurance exercises.
	times1=[]; ii=1;for ( i = 5; i <= 30; i += 5 ) times1[ ii++ ]	= /*i - 4 & " - " & */"< " & i & " min";
	times2=[]; ii=1;for ( i = 35; i <= 60; i += 5 ) times2[ ii++ ]	= /*i - 4 & " - " & */"< " & i & " min";
	//times1=[]; ii=1;for ( i = 5; i <= 30; i += 5 ) times1[ ii++ ]	= i - 4 & " - " & /*"< " &*/ i & " min";
	//times2=[]; ii=1;for ( i = 35; i <= 60; i += 5 ) times2[ ii++ ]	=i - 4 & " - " & /*"< " &*/ i & " min";

	//Generate a default time.
	defaultTimeblock = ( StructKeyExists( url, "time" ) ) ? url.time : 5;

	//Get queries for recall
	qu.setDs = "#data.source#";
	req = qu.exec(
		string = "SELECT * FROM ac_mtr_exercise_log_ee WHERE el_ee_pid = :pid AND el_ee_ex_session_id = :sid AND el_ee_timeblock = :tb"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = "#url.id#"
		 ,sid = "#sess.key#"
		 ,tb  = "#defaultTimeblock#"
		});

	//Values?
	rc = req.prefix.recordCount;	
	values = [
		{ label = "RPM", uom = "",  min = 20, max = 120, step = 1, name = "el_ee_rpm"
			,def = "#(!rc) ? 0 : iif((req.results.el_ee_rpm eq ""),0,req.results.el_ee_rpm)#" }
	 ,{ label = "Watts/Resistance",uom = "", min = 0, max = 500, step = 1, name = "el_ee_watts_resistance"
			,def = "#(!rc) ? 0 : iif((req.results.el_ee_watts_resistance eq ""),0,req.results.el_ee_watts_resistance)#" }
	 ,{	label = "MPH/Speed", uom = "",    min = 0.1, max = 15, step = 0.5, name = "el_ee_speed"
		  ,def = "#(!rc) ? 0 : iif((req.results.el_ee_speed eq ""),0,req.results.el_ee_speed)#" }
	 ,{ label = "Percent Grade", uom = "",    min = 0, max = 15, step = 1, name = "el_ee_grade"
		  ,def = "#(!rc) ? 0 : iif((req.results.el_ee_grade eq ""),0,req.results.el_ee_grade)#" }
	 ,{ label = "Perceived Exertion Rating",uom = "",    min = 0, max = 5,step = 1, name = "el_ee_perceived_exertion"
		  ,def = "#(!rc) ? 0 : iif((req.results.el_ee_perceived_exertion eq ""),0,req.results.el_ee_perceived_exertion)#" }
	 ,{ label = "Affect",uom = "",    min = -5, max = 5, step = 1, name = "el_ee_perceived_exertion"
		  ,def = 0/*"#(!rc) ? 0 : iif((req.results.el_ee_perceived_exertion eq ""),0,req.results.el_ee_perceived_exertion)#"*/ }
	];

	// Initialize client side AJAX code 
	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update.cfm" )
	 /*,showDebug = true*/
	 ,querySelector = [{
			dom = "##participant_list li, .participant-info-nav li, .inner-selection li, ##sendPageVals"
		 ,event = "click"
		 ,noPreventDefault = true
		 ,send = "input[name^=el_], select[name^=el_]" 
		}]
	 ,additional = [ 
		{ name="this", value= "endurance" }
	 ,{ name="pid", value= "#url.id#" }
	 ,{ name="sess_id", value= "#sess.key#" }
		]
	);
}
else if ( part.p_exercise eq 2 ) { 
	type = (StructKeyExists(url,"extype")) ? url.extype : 1;

	//Pull all exercises	
	reExList=qu.exec( string="SELECT * FROM ac_mtr_re_exercise_list", datasource="#data.source#" );

	//Pull one exercise
	reExSel =qu.exec( string="SELECT * FROM ac_mtr_re_exercise_list WHERE et_id = :et_id", 
		datasource = "#data.source#",
		bindArgs={ et_id = type } );

	//Get the entries in the table.
	pop = qu.exec(
		string = "SELECT * FROM ac_mtr_exercise_log_re WHERE el_re_pid = :pid AND el_re_ex_session_id = :sid AND el_re_extype = :extype"
	 ,datasource = "#data.source#"
	 ,bindArgs = {
			pid = "#url.id#"
		 ,sid = "#sess.key#"
		 ,extype = "#type#"
		});

	//Generate the form from either db or something else...
	pc = pop.prefix.recordCount;
	values = [
		 {label="Set 1", uom="lb",min = 5, max = 100, step = 5, name = "el_re_weight1"
			,def = (!pc) ? 50 : pop.results.el_re_weight1 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "el_re_reps1"
			,def = (!pc) ? 0 : pop.results.el_re_reps1 }
		,{label="Set 2", uom="lb",min = 5, max = 100, step = 5, name = "el_re_weight2"
			,def = (!pc) ? 50 : pop.results.el_re_weight2 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "el_re_reps2" 
			,def = (!pc) ? 0 : pop.results.el_re_reps2 }
		,{label="Set 3", uom="lb",min = 5, max = 100, step = 5, name = "el_re_weight3"
			,def = (!pc) ? 50 : pop.results.el_re_weight3 }
		,{label="", uom="reps",min = 0, max = 15, step = 1, name = "el_re_reps3"
			,def = (!pc) ? 0 : pop.results.el_re_reps3 }
	];
	
	//Initialize AJAX
	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update.cfm" ) 
	 /*,showDebug = true*/
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

