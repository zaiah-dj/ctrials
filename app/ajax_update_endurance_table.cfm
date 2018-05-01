<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "endurance" )
{
	try 
	{
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
			string = "
			SELECT * FROM 
				#data.data.endurance#	
			WHERE
				participantGUID = :pid
			 ,stdywk = :stdywk
			 ,staffid = :staffid
			 ,visitguid = :visitguid
			 ,dayofwk = :dayofwk
			 ,insertedby = :insertedby
			"
		 ,datasource="#data.source#"
		 ,bindArgs = { 
				 pid = form.pid
				,stdywk = 1 
				,dayofwk = 1 
				,staffid = form.staffid
				,visitguid = form.visitguid
				,insertedby = form.insertedby
			}
		);

		if ( !upd.status )
			req.sendAsJson( status = 0, message = "#upd.message#" );
	
		//....	
		//writedump( upd );

		if ( !upd.prefix.recordCount ) {
			upd = ezdb.exec( 
				datasource = "#data.source#"
				,string = "INSERT INTO 
				#data.data.endurance#	
					( participantGUID
					 ,insertedBy
					 ,mchntype
					 ,#desig#oth1
					 ,#desig#oth2
					 ,#desig#prctgrade
					 ,#desig#rpm
					 ,#desig#speed
					 ,#desig#watres  
					 ,dayOfwk
					 ,stdywk
					 ,staffid
					)
					VALUES
					(  :pid
						,:insertedby
						,:machine_type
						,:oth1
						,:oth2
						,:prctgrade
						,:rpm
						,:speed
						,:watres
					  ,:dayOfwk
					  ,:stdywk
					  ,;staffid
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
				 ,dayOfwk=1
				 ,stdywk=1
				 ,staffid=32423
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
					#data.data.endurance#	
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
					 pid = form.pid
					,machine_type = form.equipment
					,oth1 = "0"
					,oth2 = "0" 
					,prctgrade = form.grade 
					,rpm = form.rpm 
					,speed = form.speed 
					,watres = form.watts_resistance
				}
			);	
		}

/*
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
*/
	}
	catch (any e) {
		req.sendAsJson( status = 0, message = "#e.message# - #e.detail#" );	
	}
	req.sendAsJson( status = 1, message = "#upd.message#" );	
	abort;
}

</cfscript>
