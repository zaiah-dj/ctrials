<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "endurance" ) {
	try {
		//Define an error string for use throughout this part
		errstr = "Error at /api/endurance/* - ";

/*
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
*/

		//TODO: This needs to be able to check types
		req.sendAsJson( status = 0, message = "#errstr# - #serializeJSON(val)#" );	
		stat = val.validate( form, {
			 pid = { req = true }

			,sess_id = { req = true/*, type = "numeric"*/ }

			,rpm = { req = true/*, type = "numeric"*/ }

			,watts_resistance = { req = true/*, type = "numeric"*/ }

			,grade = { req = true/*, type = "numeric"*/ }

			,speed = { req = true/*, type = "numeric"*/ }

			,affect = { req = true/*, type = "numeric"*/ }

			/*Should only fit in a certain range of values*/ 
			,equipment = { req = true/*, type = "numeric"*/ }

			/*Should never be out of range of 0 - 50*/
			,timeblock = { req = true/*, type = "numeric"*/ }
		});	

		if ( !stat.status ) {
			req.sendAsJson( status = 0, message = "#errstr# #fields.message#" );	
		}
		
		//Figure out the form field name 
		desig = "";
		if ( form.timeblock eq 0 )
			desig = "wrmup_";
		else if ( form.timeblock gt 45 )
			desig = "m5_rec";
		else { 
			desig = "m#form.timeblock#_ex";
		}

		//Check for the presence of a field already
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

		if ( !upd.status ) {
			req.sendAsJson( status = 0, message = "ENDURANCE - #upd.message#" );
		}
	
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
			req.sendAsJson( status = 0, message = "#errstr# - #upd.message#" );
			abort;
		}
	}
	catch (any e) {
		req.sendAsJson( status = 0, message = "#errstr# #e.message# - #e.detail# " );	
		abort;
	}
	req.sendAsJson( status = 1, message = "SUCCESS @ /api/endurance/* - #upd.message#" );	
	abort;
}

</cfscript>
