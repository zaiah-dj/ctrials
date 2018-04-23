<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "endurance" )
{
	try {
		//check fields
		fields = cf.checkFields( form, 
			 "pid"
			,"sess_id"
			,"rpm"
			,"watts_resistance"
			,"grade"
			,"speed"
			,"affect"
			,"equipment"
			,"timeblock"
		);
			
		//...
		if ( !fields.status )
			req.sendAsJson( status = 0, message = "#fields.message#" );	
		
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
		upd = ezdb.exec( 
			string = "SELECT * FROM ac_mtr_giantexercisetable 
			WHERE 
			participantGUID = :pid"
		/*
			,stdywk = ?
			,staffid = ?
			,visitguid = ?
			,dayofwk = ?
			,insertedby = ?
			"
		*/
		 ,datasource="#data.source#"
		 ,bindArgs = { pid="#form.pid#" } 
		);

		if ( !upd.status )
			req.sendAsJson( status = 0, message = "#upd.message#" );
	
		//....	
		//writedump( upd );

		if ( !upd.prefix.recordCount ) {
			upd = ezdb.exec( 
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
				req.sendAsJson( status = 0, message = "#upd.message#" );
			}

		}
		else {
			upd = ezdb.exec( 
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
				 participantGUID = :pid"
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
		ezdb.exec(
			 string = "UPDATE 
				ac_mtr_logging_progress_tracker 
			SET
				 ee_affect = :affect
				,ee_equipment = :equipment
				,ee_grade = :grade
				,ee_rpm = :rpm 
				,ee_speed = :speed 
				,ee_watts_resistance = :watts_resistance
			WHERE 
				active_pid = :aid 
			AND 
				session_id = :sid"
		
			,datasource = "#data.source#"
			,bindArgs = {
				 aid = form.pid
				,sid = form.sess_id
				,affect = form.affect
				,equipment = form.equipment
				,grade = form.grade
				,rpm = form.rpm
				,speed = form.speed
				,watts_resistance = form.watts_resistance
			 }
		);
	}
	catch (any e) {
		req.sendAsJson( status = 0, message = "#e.message# - #e.detail#" );	
	}
	req.sendAsJson( status = 1, message = "#upd.message#" );	
	abort;
}

</cfscript>
<!---
<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "endurance" )
{
	try {
		//Define a progress statement
		progressStmt =
		"UPDATE 
			ac_mtr_logging_progress_tracker 
		SET 
			 ee_rpm = :ee_rpm 
			,ee_speed = :ee_speed 
			,ee_grade = :ee_grade 
			,ee_perceived_exertion = :ee_perceived_exertion 
			,ee_equipment = :ee_equipment
			,ee_affect = :ee_affect
			,ee_watts_resistance = :ee_watts_resistance
		WHERE 
			active_pid = :aid AND session_id = :sid"
		;

		//check fields
		fields = cf.checkFields( form, 
			"pid", "sess_id","el_ee_equipment", "el_ee_affect",
			"el_ee_timeblock","el_ee_rpm","el_ee_watts_resistance",
			"el_ee_speed","el_ee_grade","el_ee_perceived_exertion" );

		if ( !fields.status )
			req.sendAsJson( status = 0, message = "#fields.message#" );	
		
		//then insert or update if the row is not there...
		upd = ezdb.exec( 
			string = "
			SELECT * FROM
				ac_mtr_exercise_log_ee 
			WHERE 
				el_ee_ex_session_id = :sid 
			AND 
				el_ee_pid = :pid 
			AND 
				el_ee_timeblock = :tb"
		 ,datasource="#data.source#"
		 ,bindArgs = {
				sid="#form.sess_id#", 
				pid="#form.pid#", 
				tb="#form.el_ee_timeblock#" 
			} );

		if ( !upd.status )
			req.sendAsJson( status = 0, message = "#upd.message#" );

		if ( !upd.prefix.recordCount ) {
			upd = ezdb.exec( 
				datasource = "#data.source#"
				,string = "INSERT INTO ac_mtr_giantexercisetable
					( participantGUID, 
					 ,mchntype
					 ,#desig#oth1
					 ,#desig#oth2
					 ,#desig#prctgrade
					 ,#desig#rpm
					 ,#desig#speed
					 ,#desig#watres  
					)
					VALUES
					(  :pid
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
				 ,machinetype="#form.el_ee_equipment#"
				 ,oth1="0"
				 ,oth2="0"
				 ,prctgrade="#form.el_ee_grade#"
				 ,rpm="#form.el_ee_rpm#"
				 ,speed="#form.el_ee_speed#"
				 ,watres="#form.el_ee_watts_resistance#"

				 /*,
				 "eq"="#form.el_ee_equipment#" 
				 ,af="#form.el_ee_affect#" 
				 ,pe="#form.el_ee_perceived_exertion#" 
				 ,tb="#form.el_ee_timeblock#" 
				 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
				 ,mdt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
					*/
				} 
			);

			if ( !upd.status ) {
				req.sendAsJson( status = 0, message = "#upd.message#" );
			}

		}
		else {
			upd = ezdb.exec( 
				string = "
				UPDATE 
					ac_mtr_giantexercisetable
				SET
					machinetype = :machine_type,
					#desig#rpm = :rpm,
					#desig#watres = :wr,
					#desig#speed = :speed,
					#desig#prctgrade = :prctgrade,
					#desig#oth1 = :oth1,
					#desig#oth2 = :oth2
				WHERE
					el_ee_pid = :pid"
				,datasource = "#data.source#"
				,bindArgs = { 
					pid = "#form.pid#" 
					,rpm = "#form.el_ee_rpm#" 
					,watres = "#form.el_ee_watts_resistance#" 
					,speed = "#form.el_ee_speed#" 
					,prctgrade = "#form.el_ee_grade#" 
					,oth1= "##"
					,oth2= "##" 
					/*,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}*/
				}
			);	
		}

		//Also save progress (but the thing needs to be checked)
		ezdb.exec(
			string = progressStmt
		 ,datasource = "#data.source#"
		 ,bindArgs = {
				aid = form.pid
			 ,sid = form.sess_id
			 ,ee_rpm = form.el_ee_rpm
			 ,ee_rpm = form.el_ee_rpm
			 ,ee_watts_resistance = form.el_ee_watts_resistance
			 ,ee_speed = form.el_ee_speed
			 ,ee_grade = form.el_ee_grade
			 ,ee_affect = form.el_ee_affect
			 ,ee_perceived_exertion = form.el_ee_perceived_exertion
			 ,ee_equipment = form.el_ee_equipment
		 }
		);
		
	}
	catch (any e) {
		req.sendAsJson( status = 0, message = "#e.message# - #e.detail#" );	
	}
}
</cfscript>
--->
