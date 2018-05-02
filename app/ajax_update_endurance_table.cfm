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
			req.sendAsJson( status = 0, message = "ENDURANCE - #fields.message#" );	
		
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
			 //,visitguid = :visitguid
				//,visitguid = sess.key
		upd = ezdb.exec( 
			string = "
			SELECT * FROM 
				#data.data.endurance#	
			WHERE
				participantGUID = :pid
			AND stdywk = :stdywk
			AND dayofwk = :dayofwk
			"
		 ,datasource="#data.source#"
		 ,bindArgs = { 
				 pid = form.pid
				,stdywk = form.stdywk
				,dayofwk = form.dayofwk
			}
		);

		if ( !upd.status )
			req.sendAsJson( status = 0, message = "ENDURANCE - #upd.message#" );
	
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
					 ,dayofwk
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
					  ,:dwk
					  ,:swk
					  ,:staffid
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
				 ,dwk = "#form.dayofwk#"
				 ,swk = "#form.stdywk#"
				 ,staffid=1
				} 
			);
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
				 	participantGUID = :pid
				 AND
					dayofwk = :dwk
				 AND
					stdywk = :swk
				"
				,datasource = "#data.source#"
				,bindArgs = { 
					 pid = form.pid
					,machine_type = form.equipment
					,oth1 = "0"
					,oth2 = "0" 
					,dwk = "#form.dayofwk#"
					,swk = "#form.stdywk#"
					,prctgrade = form.grade 
					,rpm = form.rpm 
					,speed = form.speed 
					,watres = form.watts_resistance
				}
			);	
		}
		if ( !upd.status ) {
			req.sendAsJson( status = 0, message = "ENDURANCE - #upd.message#" );
			abort;
		}
	}
	catch (any e) {
		req.sendAsJson( status = 0, message = "ENDURANCE UPDATE FAILED - #e.message# - #e.detail# " );	
		abort;
	}
	req.sendAsJson( status = 1, message = "ENDURANCE - #upd.message#" );	
	abort;
}

</cfscript>
