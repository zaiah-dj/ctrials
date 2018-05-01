<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "resistance" )
{
	try {
		//Auto select exercise type if it's nowhere to be found
		if ( !StructKeyExists( form, "extype" ) )
			form.extype = 0;

		//Figure out the form type.
		if ( form.extype == 0 || form.extype == 1 )
			desig = "abdominalcrunch";
		else if ( form.extype == 2 )
			desig = "bicepcurl";
		else if ( form.extype == 3 )
			desig = "calfpress";
		else if ( form.extype == 4 )
			desig = "chest2";
		else if ( form.extype == 5 )
			desig = "chestpress";
		else if ( form.extype == 6 )
			desig = "dumbbellsquat";
		else if ( form.extype == 7 )
			desig = "kneeextension";
		else if ( form.extype == 8 )
			desig = "legcurl";
		else if ( form.extype == 9 )
			desig = "legpress";
		else if ( form.extype == 10 )
			desig = "overheadpress";
		else if ( form.extype == 11 )
			desig = "pulldown";
		else if ( form.extype == 12 )
			desig = "seatedrow";
		else if ( form.extype == 13 )
			desig = "shoulder2";
		else if ( form.extype == 14 )
			desig = "triceppress";

		//Then check for the right fields.	
		fields = cf.checkFields( form, 
			 "pid"
			,"sess_id"
			,"reps1"
			,"reps2"
			,"reps3"
			,"weight1"
			,"weight2"
			,"weight3"
		);

		if ( !fields.status )
			req.sendAsJson( status = 0, message = "RESISTANCE - #fields.message#" );	
		
		//then insert or update if the row is not there...
		//pid="#form.pid#", extype="#form.el_re_extype#" 
		upd = ezdb.exec( 
			string = "
			SELECT * 
			FROM 
				#data.data.resistance#	
			WHERE 
				participantGUID = :pid "
			,bindArgs = { 
				pid = form.pid
			}
		);

		if ( !upd.status )
			req.sendAsJson( status = 0, message = "RESISTANCE - #upd.message#" );

		//Get a new record thread
		recordThread = ezdb.exec( string = "SELECT newID() as newGUID" ).results.newGUID;

		if ( !upd.prefix.recordCount ) {
			upd = ezdb.exec( 
				datasource = "#data.source#"
				,string = "
					INSERT INTO 
						#data.data.resistance#	
					(  participantGUID
						,recordthread
						,insertedBy
						,dayofwk
						,#desig#Rep1
						,#desig#Rep2
						,#desig#Rep3
						,#desig#Wt1
						,#desig#Wt2
						,#desig#Wt3
					)
					VALUES
					(  :pid
						,:recThr
						,:insBy
						,:dwk
						,:rep1
						,:rep2
						,:rep3
						,:wt1
						,:wt2
						,:wt3
					);"
				,bindArgs = {
					pid   = "#form.pid#" 
				 ,recThr= recordThread
				 ,insBy = "NOBODY" 
				 ,dwk   = old_ws.ps_day 
				 ,rep1  = "#form.reps1#" 
				 ,rep2  = "#form.weight1#" 
				 ,rep3  = "#form.reps2#" 
				 ,wt1   = "#form.weight2#" 
				 ,wt2   = "#form.reps3#" 
				 ,wt3   = "#form.weight3#" 
				} 
			);
		}
		else {
			upd = ezdb.exec( 
				string = "
				UPDATE
					#data.data.resistance#	
				SET 
					 #desig#Rep1 = :rep1
					,#desig#Wt1  = :wt1
					,#desig#Rep2 = :rep2
					,#desig#Wt2  = :wt2
					,#desig#Rep3 = :rep3
					,#desig#Wt3  = :wt3
				WHERE
					participantGUID = :pid
				"
				,datasource = "#data.source#"

				,bindArgs = {
					pid ="#form.pid#" 
				 ,sid ="#form.sess_id#"
				 ,dwk = old_ws.ps_day 
				 ,staffId = 1
				 ,rep1="#form.reps1#" 
				 ,wt1 ="#form.weight1#" 
				 ,rep2="#form.reps2#" 
				 ,wt2 ="#form.weight2#" 
				 ,rep3="#form.reps3#" 
				 ,wt3 ="#form.weight3#" 
				}
			);	
		}

		aaa = SerializeJSON( upd );

		if ( !upd.status ) {
			req.sendAsJson( status = 0, message = "RESISTANCE - #upd.message#" );
		}
	}
	catch (any e) {
		req.sendAsJson( status = 0, message = "RESISTANCE - #e.message# - #e.detail#" );
	}
	req.sendAsJson( status = 1, message = "RESISTANCE - #upd.message# - #aaa#" );	
	abort;
}
</cfscript>