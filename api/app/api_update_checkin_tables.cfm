<cfscript>
errstr = "Error at /api/checkin/* - ";
if ( !StructIsEmpty( form ) ) {
	try {
		//A lot of this can be cleaned up using the validate() function
		stat = cmValidate( form, {
			ps_day = { req = true }
		 ,ps_pid = { req = true }
		 ,ps_weight = { req = true }
		 ,ps_week = { req = true }
		 ,param = { req = true }
		 ,insby  = { req = false, ifNone = 0 }
		 ,ps_next_sched = { req = false , ifNone = 0 }
		 ,bp_systolic = { req = false, ifNone = 0 }
		 ,bp_diastolic = { req = false, ifNone = 0 }
		 ,opt1 = { req = false , ifNone = "" }
		 ,opt2 = { req = false , ifNone = "" }
		} );

		if ( !stat.status ) {
			req.sendAsJson( status = 0, message ="Form values were expected and not there: #SerializeJSON(stat)#" ); 
		}

		fv = stat.results;
		
		//Add a row to the blood pressure table. (if required)
		if ( fv.bp_systolic > 0 && fv.bp_diastolic > 0 ) {
			exists = dbExec( string = "SELECT bp_pid FROM #data.data.bloodpressure# WHERE bp_pid = :id",
				bindArgs = { id = fv.ps_pid } ).results.bp_pid;
			sqlString = ""; 

			if ( exists eq "" ) {
				sqlString = "INSERT INTO #data.data.bloodpressure#
					VALUES ( :id,:systolic, :diastolic, :recorddate, NULL )";
			}
			else {
				sqlString = "UPDATE #data.data.bloodpressure# SET
					bp_systolic = :systolic, bp_diastolic = :diastolic
				 ,bp_daterecorded = :recorddate WHERE bp_pid = :id";
			} 

			bpi = dbExec(
				 string = sqlString
				,bindArgs={ 
					 id        = fv.ps_pid
					,systolic  = fv.bp_systolic
					,diastolic = fv.bp_diastolic
					,recorddate= { value=Now(), type="cf_sql_date" }
				});


			if ( !bpi.status ) {
				errAndRedirect( "Error at process_checkin_form.cfm: #SerializeJSON(bpi)#" );	
			}
		}

		//Update the session with the correct type
		sc.exerciseParameter = fv.param;
		sc.week = fv.ps_week;

		//Select a table name
		tbName = ( sc.randomizedTypeName eq "endurance" ) ? "#data.data.endurance#" : "#data.data.resistance#"; 
		isEnd = ( sc.randomizedTypeName eq "endurance" ) ? 1 : 0;
		isRes = ( sc.randomizedTypeName eq "endurance" ) ? 0 : 1;

		//Is there already a record?
		exists = dbExec(string="SELECT participantGUID FROM #tbName# 
			WHERE participantGUID = :pid AND dayofwk = :dwk AND stdywk = :swk AND recordthread = :rid"
	   ,bindArgs = { pid=fv.ps_pid, dwk = cs.day, swk = fv.ps_week, rid = { value=sc.recordthread, type = "varchar" }}
		).results.participantGUID;
				
		//Write weight regardless, and target heart rate if this is an endurance participant
		sqlString = "";
		if ( exists eq "" ) {
			sqlString	= "
				INSERT INTO #tbName# 
					( 
					  #iif( isEnd, DE('mchntype'), DE('bodypart') )# 
					, insertedBy
					, weight
					, participantGUID
					, recordthread
					, dayofwk
					, stdywk 
					, othMchn1
					, othMchn2
					)
		    VALUES 
					( 
					  #iif( isEnd, DE(':mchntype'), DE(':bodypart') )# 
					, :iby 
					, :weight 
					, :pid
					, :rthd
					, :dwk
					, :swk   
					, :om1
					, :om2
					)
				";
		}
		else { 
			sqlString	= "
				UPDATE 
					#tbName# 
				SET 
					weight  = :weight
				 ,#iif( isEnd, DE('mchntype = :magic'), DE('bodypart = :magic') )# 
				 ,othMchn1= :om1
				 ,othMchn2= :om2
				WHERE participantGUID = :pid 
				AND recordthread = :rthd
				AND dayofwk = :dwk 
				AND stdywk = :swk
			";
		}

		qh = dbExec(
			string = sqlString
		 ,bindArgs = {
			  magic   = fv.param
			 ,iby     = fv.insby
			 ,weight  = fv.ps_weight
			 ,pid     = fv.ps_pid
			 ,rthd    = { value = sc.recordthread, type = "varchar" }
			 ,dwk     = cs.day
			 ,swk     = fv.ps_week
			 ,om1     = fv.opt1
			 ,om2     = fv.opt2
		 }
		);

		if ( !qh.status ) { 
			errAndRedirect( "Error at process_checkin_form.cfm (152): #SerializeJSON(qh)#" );
		}
	}
	catch (any ff) {
		writedump( ff );
		errAndRedirect( goto="check-in", msg="Error at process_checkin_form.cfm: " );
	}

	//At this point the check-in form was successfully completed, so mark it
}
</cfscript>
