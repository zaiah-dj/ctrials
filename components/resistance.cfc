/* List of resistance exercises. */
component name="resistance" {
	this.srcQuery = 0;

	//
	resistance function init () {
		this.srcQuery = queryNew( 
		 "prefix,urlparam,pname", 
		 "Varchar,Integer,Varchar", [
			 { prefix="wrmup"          , urlparam=0, pname="5 Minute Warmup" }
			,{ prefix="chestpress"     , urlparam=1, pname="Chest Press" }
			,{ prefix="chest2"         , urlparam=2, pname="Chest ##2" }
			,{ prefix="abdominalcrunch", urlparam=3, pname="Abdominal Crunch" }
			,{ prefix="overheadpress"  , urlparam=4, pname="Overhead Press" }
			,{ prefix="seatedrow"      , urlparam=5, pname="Seated Row" }
			,{ prefix="shoulder2"      , urlparam=6, pname="Shoulder ##2" }
			,{ prefix="triceppress"    , urlparam=7, pname="Tricep Press" }
			,{ prefix="legpress"       , urlparam=8, pname="Leg Press" }
			,{ prefix="calfpress"      , urlparam=9, pname="Calf Press" }
			,{ prefix="pulldown"       , urlparam=10, pname="Pulldown" }
			,{ prefix="legcurl"        , urlparam=11, pname="Leg Curl" }
			,{ prefix="dumbbellsquat"  , urlparam=12, pname="Dumbbell Squat" }
			,{ prefix="kneeextension"  , urlparam=13, pname="Knee Extension" }
			,{ prefix="bicepcurl"      , urlparam=14, pname="Bicep Curl" }
		 ]);

		this.qqq = queryNew( 
			"type,index,label", 
			"Integer,Integer,Varchar", [
			 { type = 0, index=1, label = "abdominalcrunch" }
			,{ type = 1, index=10, label = "abdominalcrunch" }
			,{ type = 2, index=7, label = "bicepcurl" }
			,{ type = 3, index=1, label = "calfpress" }
			,{ type = 4, index=9, label = "chest2" }
			,{ type = 5, index=8, label = "chestpress" }
			,{ type = 6, index=1, label = "dumbbellsquat" }
			,{ type = 7, index=6, label = "kneeextension" }
			,{ type = 8, index=4, label = "legcurl" }
			,{ type = 9, index=1, label = "legpress" }
			,{ type = 10, index=11, label = "overheadpress" }
			,{ type = 11, index=3, label = "pulldown" }
			,{ type = 12, index=5, label = "seatedrow" }
			,{ type = 13, index=13, label = "shoulder2" }
			,{ type = 14, index=14, label = "triceppress" }
		]);

		//Form label defaults for resistance exericses.
		this.labelDefaults = [
			 {uom="lb"  ,label="Set 1",min=5,max=100, step=5, formName = "Wt1" ,index=1 }
			,{uom="reps",label=""     ,min=0,max=15 , step=1, formName = "Rep1",index=1 }
			,{uom="lb"  ,label="Set 2",min=5,max=100, step=5, formName = "Wt2" ,index=2 }
			,{uom="reps",label=""     ,min=0,max=15 , step=1, formName = "Rep2",index=2 }
			,{uom="lb"  ,label="Set 3",min=5,max=100, step=5, formName = "Wt3" ,index=3 }
			,{uom="reps",label=""     ,min=0,max=15 , step=1, formName = "Rep3",index=3 }
		 //,{ uom="bpm", label="Heart Rate", min=20, max=120, step=1, formName="hr", type=0, frequency="0" }
		 //,{ uom="rpe", label="RPE", min=20, max=120, step=1, formName="rpe", type=0, frequency="0,20,45" }
		 //,{ uom="%"  , label="Affect", min=20, max=120, step=1, formName="Othafct", type=0, frequency="0,20,45" }
		];

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

	public function getExercises() {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.exercises ); 
		qr = qs.execute( sql = "SELECT * FROM sourceQuery" );
		return qr.getResult();	
	}

	public function getLabels() {
		return this.labelDefaults;
	}

	//USe this to clean up the result set
	public function getLabelsFor() {
		return this.labelDefaults;
	}

	public function getSpecificLabels( Required Numeric id ) {
		ld = []; for ( n in this.labelDefaults ) ( n.index eq id ) ? ArrayAppend( ld, n ) : 0;
		return ld; //this.labelDefaults;
	}

	public Query function getSpecificModifiers ( Required Numeric id ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.exercises ); 
		qs.addParam( name="id", value=arguments.id, cfsqltype="cf_sql_numeric" );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE etype = :id" );
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
		qs.setAttributes( sourceQuery = this.exercises ); 
		qs.addParam( name="id", value=arguments.id, cfsqltype="cf_sql_numeric" );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE type = :id" );
		return qr.getResult();	
	}
}
