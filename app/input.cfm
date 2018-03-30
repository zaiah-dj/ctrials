<!--- ... --->
<cfset clijs = CreateObject( "component", "components.writeback" )>
<cfset qu = CreateObject( "component", "components.quella" )>
<cfset pid = #url.id#>

<!--- Control --->
<cfif #part.p_exercise# eq "0">



<!--- Endurance --->
<cfelseif #part.p_exercise# eq "1">
	<cfscript>
	//Generate the time blocks for endurance exercises.
	times1=[]; ii=1;for ( i = 5; i <= 30; i += 5 ) times1[ ii++ ]	= /*i - 4 & */"< " & i;
	times2=[]; ii=1;for ( i = 35; i <= 60; i += 5 ) times2[ ii++ ]	=/* i - 4 & */"< " & i;

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

	//Generate the form from either db or something else...
	if ( !req.status ) { 
		values = [
			 { label = "RPM",           
					uom = "",    min = 5, max = 80, def = 0, step = 2, name = "el_ee_rpm" }
			,{ label = "Watts/Resistance", 
					uom = "",    min = 0, max = 80, def = 0, step = 1, name = "el_ee_watts_resistance" }
			,{ label = "Speed",         
					uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "el_ee_speed"}
			,{ label = "Percent Grade", 
					uom = "mph", min = 0, max = 80, def = 0, step = 1, name = "el_ee_grade"}
			,{ label = "Perceived Exertion Rating",    
					uom = "mph", min = 0, max = 5, def = 0, step = 1, name = "el_ee_perceived_exertion"}
		];
	}
	else {
		values = [
			 { label = "RPM",           
					uom = "",    min = 5, max = 80, def = "#iif((req.results.el_ee_rpm eq ""),0,req.results.el_ee_rpm)#", step = 2, name = "el_ee_rpm" }
			,{ label = "Watts/Resistance", 
					uom = "",    min = 5, max = 80, def = "#iif((req.results.el_ee_watts_resistance eq ""),0,req.results.el_ee_watts_resistance)#", step = 2, name = "el_ee_watts_resistance" }
			,{ label = "Speed",         
					uom = "",    min = 5, max = 80, def = "#iif((req.results.el_ee_speed eq ""),0,req.results.el_ee_speed)#", step = 2, name = "el_ee_speed" }
			,{ label = "Percent Grade", 
					uom = "",    min = 0, max = 80, def = "#iif((req.results.el_ee_grade eq ""),0,req.results.el_ee_grade)#", step = 2, name = "el_ee_grade" }
			,{ label = "Perceived Exertion Rating",    
					uom = "",    min = 0, max = 5, def = "#iif((req.results.el_ee_perceived_exertion eq ""),0,req.results.el_ee_perceived_exertion)#", step = 1, name = "el_ee_perceived_exertion" }
		];
	}

	// Initialize client side AJAX code 
	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update2.cfm" )
	 ,querySelector = [{
			dom = "##participant_list li, .participant-info-nav li, .inner-selection li"
		 ,noPreventDefault = true
		 ,event = "click"
		 ,send = "input[name^=el_], select[name^=el_]" 
		}]
	 ,additional = [ 
		{ name="this", value= "endurance" }
	 ,{ name="pid", value= "#url.id#" }
	 ,{ name="sess_id", value= "#sess.key#" }
		]
	);
	</cfscript>


<!--- Resistance --->
<cfelseif part.p_exercise eq "2">
	<cfscript>
	type = (StructKeyExists(url,"extype")) ? url.extype : 1;
	reExList=qu.exec( string="SELECT * FROM ac_mtr_re_exercise_list", datasource="#data.source#" );
	reExSel =qu.exec( string="SELECT * FROM ac_mtr_re_exercise_list WHERE et_id = :et_id", 
		datasource = "#data.source#",
		bindArgs={ et_id = type } );

	AjaxClientInitCode = CreateObject( "component", "components.writeback" ).Client( 
		location = link( "update.cfm" ) 
	 ,additional = [ 
			{ name = "this", value = "resistance" }
		 ,{ name = "sess_id", value = "#sess.key#" }
		 ,{ name = "pid", value = "#pid#" }
		]
	 ,querySelector = {
			dom = "##participant_list li, .participant-info-nav li, .inner-selection li"
		 ,noPreventDefault = true
		 ,event = "click"
		 ,send = ".slider"
		}
	);
	</cfscript>

</cfif>
