/* List of resistance exercises. */
component name="resistance" {
	this.srcQuery = 0;

	resistance function init () {
		this.srcQuery = queryNew( 
		 "prefix,urlparam,pname,class", 
		 "Varchar,Integer,Varchar,Integer", [
			 { prefix="wrmup_"         , urlparam=0, pname="5 Minute Warmup", class=0 }

			,{ prefix="legpress"       , urlparam=1, pname="Leg Press", class=1 }
			,{ prefix="modleg"         , urlparam=2, pname="Modified Leg Press", class=1 }
			,{ prefix="pulldown"       , urlparam=3, pname="Pulldown", class=1 }
			,{ prefix="legcurl"        , urlparam=4, pname="Leg Curl", class=1 }
			,{ prefix="seatedrow"      , urlparam=5, pname="Seated Row", class=1 }
			,{ prefix="kneeextension"  , urlparam=6, pname="Knee Extension", class=1 }
			,{ prefix="bicepcurl"      , urlparam=7, pname="Biceps Curl", class=1 }

			,{ prefix="chestpress"     , urlparam=8, pname="Chest Press", class=2 }
			,{ prefix="chest2"         , urlparam=9, pname="Chest ##2", class=2 }
			,{ prefix="abdominalcrunch", urlparam=10, pname="Abdominal Crunch", class=2 }
			,{ prefix="overheadpress"  , urlparam=11, pname="Overhead Press", class=2 }
			,{ prefix="calfpress"      , urlparam=12, pname="Calf Press", class=2 }
			,{ prefix="shoulder2"      , urlparam=13, pname="Non-Press Shoulder Exercise", class=2 }
			,{ prefix="triceppress"    , urlparam=14, pname="Tricep Push-Down", class=2 }

			//,{ prefix="dumbbellsquat"  , urlparam=5, pname="Dumbbell Squat", class=1 }
		 ]);

		//Form label defaults for resistance exericses.
		this.labelDefaults = queryNew( 
		 "uom,label,min,max,step,formName,index,paramMatch",
		 "Varchar,Varchar,Integer,Integer,Integer,Varchar,Integer,Integer", [
			 {uom="lb"  ,label="Set 1",min=5,max=100, step=5, formName = "Wt1" ,index=1, paramMatch=1}
			,{uom="reps",label=""     ,min=0,max=15 , step=1, formName = "Rep1",index=1, paramMatch=1}
			,{uom="lb"  ,label="Set 2",min=5,max=100, step=5, formName = "Wt2" ,index=2, paramMatch=1}
			,{uom="reps",label=""     ,min=0,max=15 , step=1, formName = "Rep2",index=2, paramMatch=1}
			,{uom="lb"  ,label="Set 3",min=5,max=100, step=5, formName = "Wt3" ,index=3, paramMatch=1}
			,{uom="reps",label=""     ,min=0,max=15 , step=1, formName = "Rep3",index=3, paramMatch=1}
		  ,{uom="bpm", label="Heart Rate", min=20, max=120, step=1, formName="hr", index=0, paramMatch=0}
		  ,{uom="rpe", label="RPE",        min=20, max=120, step=1, formName="rpe", index=0, paramMatch=0}
		  ,{uom="%"  , label="Affect",     min=20, max=120, step=1, formName="Othafct", index=0, paramMatch=0}
		]);

		this.exercises = queryNew( 
			"type,id,etype,ssGroup,pname,formName,desc", 
			"Integer,Integer,Integer,Integer,Varchar,Varchar,Varchar", [
			
		//Chest, shoulders, triceps, ads, calves
		 { type=5, id=5, etype=4,ssGroup=1,pname='Chest Press', formName='chestpress', desc='' }
		,{ type=4, id=4, etype=4,ssGroup=2,pname='Chest No. 2', formName='chest2', desc='' }
		,{ type=1, id=1, etype=4,ssGroup=2,pname='Abdominal Crunch', formName='abdominalcrunch', desc='' }
		,{ type=10,id=10,etype=4,ssGroup=3,pname='Overhead Press', formName='overheadpress', desc='' }
		,{ type=12,id=12,etype=4,ssGroup=3,pname='Seated Row', formName='seatedrow', desc='' }
		,{ type=13,id=13,etype=4,ssGroup=4,pname='Shoulder No. 2', formName='shoulder2', desc='' }
		,{ type=14,id=14,etype=4,ssGroup=4,pname='Tricep Press-Down', formName='triceppress', desc='' }
	
		//Hips/thighs, back, biceps	

		//Calf Press should be 'Modified Leg Press'
		//Dumbbell Squat should be 'Seated Row'
		,{ type=9, id=9, etype=5,ssGroup=0,pname='Leg Press', formName='legpress', desc='' }
		,{ type=3, id=3, etype=5,ssGroup=1,pname='Calf Press', formName='calfpress', desc='' }
		,{ type=11,id=11,etype=5,ssGroup=2,pname='Pulldown', formName='pulldown', desc='' }
		,{ type=8, id=8, etype=5,ssGroup=3,pname='Leg Curl', formName='legcurl', desc='' }
		,{ type=6, id=6, etype=5,ssGroup=0,pname='Dumbbell Squat', formName='dumbbellsquat', desc='' }
		,{ type=7, id=7, etype=5,ssGroup=4,pname='Knee Extension', formName='kneeextension', desc='' }
		,{ type=2, id=2, etype=5,ssGroup=4,pname='Biceps Curl', formName='bicepcurl', desc='' }
			] 
		);
		return this;
	}

	public function getLabels() {
		return this.labelDefaults;
	}

	//USe this to clean up the result set
	public function getLabelsFor( Required Numeric a, Required Numeric b ) {
//writedump( private.formValues );writedump( private.magic );abort;
		pullFrom = ( b ) ? 1 : 0;
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.labelDefaults );
		qs.addParam( name = "t", value = pullFrom, cfsqltype="cf_sql_numeric" );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE paramMatch = :t" ); 
//writedump( qr ); abort;
		return qr.getResult();	
	}

	public function getSpecificLabels( Required Numeric id ) {
		ld = []; for ( n in this.labelDefaults ) ( n.index eq id ) ? ArrayAppend( ld, n ) : 0;
		return ld; //this.labelDefaults;
	}

	public Query function getAllModifiers ( ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qr = qs.execute( sql = "SELECT * FROM sourceQuery" );
		return qr.getResult();	
	}

	public Query function getSpecificModifiers ( Required Numeric id ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qs.addParam( name="id", value=arguments.id, cfsqltype="cf_sql_numeric" );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE class = :id OR class = 0" );
		return qr.getResult();	
	}

	public Query function getResistance( ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qr = qs.execute( sql = "SELECT * FROM sourceQuery" );
		return qr.getResult();	
	}

	public Query function getExerciseName( Required Numeric id ) {
		qs = new query();	
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qs.addParam( name="id", value=arguments.id, cfsqltype="cf_sql_numeric" );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE urlparam = :id" );
		return qr.getResult();	
	}
}
