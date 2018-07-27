component name="resistance" {
	this.srcQuery = 0;

	//
	resistance function init () {
		this.labelDefaults = [
			 {label="Set 1",uom="lb"  ,min = 5,max = 100,step = 5,formName = "Wt1" ,index=1 }
			,{label=""     ,uom="reps",min = 0,max = 15 ,step = 1,formName = "Rep1",index=1 }
			,{label="Set 2",uom="lb"  ,min = 5,max = 100,step = 5,formName = "Wt2" ,index=2 }
			,{label=""     ,uom="reps",min = 0,max = 15 ,step = 1,formName = "Rep2",index=2 }
			,{label="Set 3",uom="lb"  ,min = 5,max = 100,step = 5,formName = "Wt3" ,index=3 }
			,{label=""     ,uom="reps",min = 0,max = 15 ,step = 1,formName = "Rep3",index=3 }
		];

		/*
			 { type = 0, desig = "abdominalcrunch" }
			,{ type = 1, desig = "abdominalcrunch" }
			,{ type = 2, desig = "bicepcurl" }
			,{ type = 3, desig = "calfpress" }
			,{ type = 4, desig = "chest2" }
			,{ type = 5, desig = "chestpress" }
			,{ type = 6, desig = "dumbbellsquat" }
			,{ type = 7, desig = "kneeextension" }
			,{ type = 8, desig = "legcurl" }
			,{ type = 9, desig = "legpress" }
			,{ type = 10, desig = "overheadpress" }
			,{ type = 11, desig = "pulldown" }
			,{ type = 12, desig = "seatedrow" }
			,{ type = 13, desig = "shoulder2" }
			,{ type = 14, desig = "triceppress" }
		*/

		this.srcQuery = queryNew( "type,order,desig", "Integer,Integer,Varchar", [
			 { type = 0, order=1, desig = "abdominalcrunch" }
			,{ type = 1, order=10, desig = "abdominalcrunch" }
			,{ type = 2, order=7, desig = "bicepcurl" }
			,{ type = 3, order=1, desig = "calfpress" }
			,{ type = 4, order=9, desig = "chest2" }
			,{ type = 5, order=8, desig = "chestpress" }
			,{ type = 6, order=1, desig = "dumbbellsquat" }
			,{ type = 7, order=6, desig = "kneeextension" }
			,{ type = 8, order=4, desig = "legcurl" }
			,{ type = 9, order=1, desig = "legpress" }
			,{ type = 10, order=11, desig = "overheadpress" }
			,{ type = 11, order=3, desig = "pulldown" }
			,{ type = 12, order=5, desig = "seatedrow" }
			,{ type = 13, order=13, desig = "shoulder2" }
			,{ type = 14, order=14, desig = "triceppress" }
		]);

/*
		this.exercises = queryNew( 
			"type,id,etype,pname,formName,description", 
			"Integer,Integer,Integer,Varchar,Varchar,Varchar", [
		 { type=1, id=1,  etype=4, pname = 'Abdominal Crunch', formName = 'abdominalcrunch', description = '' }
		,{ type=2, id=2,  etype=4, pname = 'Bicep Curl', formName = 'bicepcurl', description = '' }
		,{ type=3, id=3,  etype=5, pname = 'Calf Press', formName = 'calfpress', description = '' }
		,{ type=4, id=4,  etype=4, pname = 'Chest', formName = 'chest2', description = '' }
		,{ type=5, id=5,  etype=4, pname = 'Chest Press', formName = 'chestpress', description = '' }
		,{ type=6, id=6,  etype=5, pname = 'Dumbbell Squat', formName = 'dumbbellsquat', description = '' }
		,{ type=7, id=7,  etype=5, pname = 'Knee Extension', formName = 'kneeextension', description = '' }
		,{ type=8, id=8,  etype=5, pname = 'Leg Curl', formName = 'legcurl', description = '' }
		,{ type=9, id=9,  etype=5, pname = 'Leg Press', formName = 'legpress', description = '' }
		,{ type=10, id=10,  etype=4, pname = 'Overhead Press', formName = 'overheadpress', description = '' }
		,{ type=11, id=11,  etype=4, pname = 'Pulldown', formName = 'pulldown', description = '' }
		,{ type=12, id=12,  etype=4, pname = 'Seated Row', formName = 'seatedrow', description = '' }
		,{ type=13, id=13,  etype=4, pname = 'Shoulder', formName = 'shoulder2', description = '' }
		,{ type=14, id=14,  etype=4, pname = 'Tricep Press', formName = 'triceppress', description = '' }
		]);

*/

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

	public function getSpecificLabels( Required Numeric id ) {
		ld = []; for ( n in this.labelDefaults ) ( n.index eq id ) ? ArrayAppend( ld, n ) : 0;
		return ld; //this.labelDefaults;
	}

	public Query function getSpecificExercises( Required Numeric id ) {
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
