<cfscript>
if ( StructKeyExists( form, "this" ) && form.this eq "resistance" )
{
	try {
		if ( form.extype = 0 )
			desig = "abdominalcrunch";
		else if ( form.extype = 1 )
			desig = "bicepcurl";
		else if ( form.extype = 2 )
			desig = "calfpress";
		else if ( form.extype = 3 )
			desig = "chest2";
		else if ( form.extype = 4 )
			desig = "chestpress";
		else if ( form.extype = 5 )
			desig = "dumbbellsquat";
		else if ( form.extype = 6 )
			desig = "kneeextension";
		else if ( form.extype = 7 )
			desig = "legcurl";
		else if ( form.extype = 8 )
			desig = "legpress";
		else if ( form.extype = 9 )
			desig = "overheadpress";
		else if ( form.extype = 10 )
			desig = "pulldown";
		else if ( form.extype = 11 )
			desig = "seatedrow";
		else if ( form.extype = 12 )
			desig = "shoulder2";
		else if ( form.extype = 13 )
			desig = "triceppress";

		//Figure out the form field name 
		desig = "";
		if ( form.el_ee_timeblock eq 0 )
			desig = "wrmup_";
		else if ( form.el_ee_timeblock gt 45 )
			desig = "m5_rec";
		else {
			desig = "m#form.el_ee_timeblock#_ex";
		}

		//Then check for the right fields.	
		fields = cc.checkFields( form, 
			 "pid"
			,"sess_id"
			,"#desig#Rep1"
			,"#desig#Rep2"
			,"#desig#Rep3"
			,"#desig#Wt1"
			,"#desig#Wt2"
			,"#desig#Wt3"
		);

		if ( !fields.status )
			req.sendRequest( status = 0, message = "#fields.message#" );	
		
		//then insert or update if the row is not there...
		upd = qu.exec( 
			string = "SELECT * FROM ac_mtr_giantexercisetable WHERE el_re_ex_session_id = :sid AND el_re_pid = :pid AND el_re_extype = :extype",
			datasource="#data.source#",
			bindArgs = { sid="#form.sess_id#", pid="#form.pid#", extype="#form.el_re_extype#" } 
		);

		if ( !upd.status )
			req.sendRequest( status = 0, message = "#upd.message#" );

		if ( !upd.prefix.recordCount ) {
			upd = qu.exec( 
				datasource = "#data.source#",
				string = "INSERT INTO ac_mtr_giantexercisetable 
					( participantGUID, #desig#hr, #desig#oth1, #desig#oth2, #desig#prctgrade, #desig#rpm, #design#speed, #desig#watres )
					VALUES
					( :pid,          ,:r1       ,:w1         , :r2        , :w2             , :r3       , :w3          ,:extype, :dt, :mdt );",
				bindArgs = {
					pid="#form.pid#" 
				 ,sid="#form.sess_id#"

				 ,hr="#form.el_re_reps1#" 
				 ,oth1="#form.el_re_weight1#" 
				 ,oth2="#form.el_re_reps2#" 
				 ,prctgrade="#form.el_re_weight2#" 
				 ,rpm="#form.el_re_reps3#" 
				 ,speed="#form.el_re_weight3#" 
				 ,watres="#form.el_re_extype#" 

				 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
				 ,mdt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
				} 
			);
		}
		else {
			upd = qu.exec( 
				string = "UPDATE ac_mtr_exercise_log_re 
				SET 
					el_re_reps1 = :r1,
					el_re_weight1 = :w1,
					el_re_reps2 = :r2,
					el_re_weight2 = :w2,
					el_re_reps3 = :r3,
					el_re_weight3 = :w3,
					el_re_extype = :extype,
					el_re_datetime_modified = :dt
				WHERE
					el_re_ex_session_id = :sid 
				AND
					el_re_extype = :extype
				AND
					el_re_pid = :pid"

				,datasource = "#data.source#"

				,bindArgs = {
					pid="#form.pid#" 
				 ,sid="#form.sess_id#"

				 ,r1="#form.el_re_reps1#" 
				 ,w1="#form.el_re_weight1#" 
				 ,r2="#form.el_re_reps2#" 
				 ,w2="#form.el_re_weight2#" 
				 ,r3="#form.el_re_reps3#" 
				 ,w3="#form.el_re_weight3#" 

				 ,extype="#form.el_re_extype#" 
				 ,dt={value=DateTimeFormat( Now(), "YYYY-MM-DD" ), type="cfsqldatetime"}
				}
			);	
		}

		//Progress tracking
		qu.exec( 
			string = progressStmt
		 ,datasource = "#data.source#"
		 ,bindArgs = {
				aid = form.pid
			 ,sid = form.sess_id
			 ,re_reps1 = form.el_re_reps1
			 ,re_weight1 = form.el_re_weight1
			 ,re_reps2 = form.el_re_reps2
			 ,re_weight2 = form.el_re_weight2
			 ,re_reps3 = form.el_re_reps3
			 ,re_weight3 = form.el_re_weight3
			}
		);
	}
	catch (any e) {
		req.sendRequest( status = 0, message = "#e.message# - #e.detail#" );
	}
}
</cfscript>
