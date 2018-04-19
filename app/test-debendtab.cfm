<cffunction name="sendRequest">
	<cfargument name="status">
	<cfargument name="message">

	<cfset aa = CreateObject("component", "components.requestLogger" )
		.init(table = "ac_mtr_serverlog", ds="#data.source#")
		.append(message = "#arguments.message#")>

	<cfcontent type="application/json">
		<cfoutput>{ "status": #arguments.status#, "message": "#arguments.message#" }</cfoutput>  
	</cfcontent>
	<cfabort>

</cffunction>

<cfscript>
cc = createObject("component", "components.checkFields");
qu = createObject("component", "components.quella");

if ( StructKeyExists( form, "this" ) && form.this eq "endurance" )
{
	try {
		//Define a progress statement
		progressStmt =
		"UPDATE 
			ac_mtr_logging_progress_tracker 
		SET
			 ee_affect = :affect
			,ee_equipment = :equipment
			,ee_grade = :grade
			,ee_perceived_exertion = :perceived_exertion
			,ee_rpm = :rpm 
			,ee_speed = :speed 
			,ee_watts_resistance = :watts_resistance
		WHERE 
			active_pid = :aid 
		AND 
			session_id = :sid"
		;
	
		//check fields
		fields = cc.checkFields( form, 
			 "pid"
			,"sess_id"
			,"rpm"
			,"watts_resistance"
			,"grade"
			,"speed"
			,"affect"
			,"percex"
			,"equipment"
		);
			
		//...
		if ( !fields.status )
			sendRequest( status = 0, message = "#fields.message#" );	
		
		//Figure out the form field name 
		desig = "";
		if ( form.timeblock eq 0 )
			desig = "wrmup_";
		else if ( form.timeblock gt 45 )
			desig = "m5_rec";
		else { 
			desig = "m#form.timeblock#_ex";
		}
		
		//then insert or update if the row is not there...
		//add stdywk, staffid, visitguid, dayofwk, insertedby to get an accurate count
		upd = qu.exec( 
			string = "SELECT * FROM ac_mtr_giantexercisetable 
			WHERE 
			participantGUID = :pid			
			,stdywk = ?
			,staffid = ?
			,visitguid = ?
			,dayofwk = ?
			,insertedby = ?
			"
		 ,datasource="#data.source#"
		 ,bindArgs = { pid="#form.pid#" } );

		if ( !upd.status )
			sendRequest( status = 0, message = "#upd.message#" );
writedump( upd );

abort;			
		if ( !upd.prefix.recordCount ) {
			upd = qu.exec( 
				datasource = "#data.source#"
				,string = "INSERT INTO ac_mtr_giantexercisetable
					( participantGUID
					 ,insertedBy
					 ,mchntype
					 ,#desig#oth1
					 ,#desig#oth2
					 ,#desig#prctgrade
					 ,#desig#rpm
					 ,#desig#speed
					 ,#desig#watres  
					)
					VALUES
					(  
						 :pid
						,:insertedby
						,:machine_type
						,:oth1
						,:oth2
						,:prctgrade
						,:rpm
						,:speed
						,:watres
					)"
				,bindArgs = {
				  pid="#form.pid#" 
				 ,insertedby = "NOBODY"
				 ,machine_type=form.equipment
				 ,oth1="0"
				 ,oth2="0"
				 ,prctgrade="#form.grade#"
				 ,rpm="#form.rpm#"
				 ,speed="#form.speed#"
				 ,watres="#form.watts_resistance#"
				} 
			);

			if ( !upd.status ) {
				sendRequest( status = 0, message = "#upd.message#" );
			}

		}
		else {
			upd = qu.exec( 
				string = "
				 UPDATE 
					ac_mtr_giantexercisetable
				 SET
					 mchntype = :machine_type
					,#desig#oth1 = :oth1
					,#desig#oth2 = :oth2
					,#desig#prctgrade = :prctgrade
					,#desig#rpm = :rpm
					,#desig#speed = :speed
					,#desig#watres = :watres
				 WHERE
				 el_ee_pid = :pid"
				,datasource = "#data.source#"
				,bindArgs = { 
					 pid = "#form.pid#" 
					,machine_type = form.equipment
					,oth1= "0"
					,oth2= "0" 
					,prctgrade = "#form.grade#" 
					,rpm = "#form.rpm#" 
					,speed = "#form.speed#" 
					,watres = "#form.watts_resistance#"
				}
			);	
		}

		//Also save progress (but the thing needs to be checked)
		qu.exec(
			 string = progressStmt
			,datasource = "#data.source#"
			,bindArgs = {
				 aid = form.pid
				,sid = form.sess_id
				,affect = form.affect
				,equipment = form.equipment
				,grade = form.grade
				,perceived_exertion = form.percex
				,rpm = form.rpm
				,speed = form.speed
				,watts_resistance = form.watts_resistance
			 }
		);
	}
	catch (any e) {
		sendRequest( status = 0, message = "#e.message# - #e.detail#" );	
	}
	sendRequest( status = 1, message = "#upd.message#" );	
	abort;
}
</cfscript>