/* List of resistance exercises. */
component name="exercises" {
	this.srcQuery = 0;

	//constructor
	exercises function init ( ) {
		this.srcQuery = queryNew( "id,etype,pname,form_name,description", "Integer,Integer,Varchar,Varchar,Varchar", [
		 { id=1,  etype=4, pname = 'Abdominal Crunch', form_name = 'abdominalcrunch', description = '' }
		,{ id=2,  etype=4, pname = 'Bicep Curl', form_name = 'bicepcurl', description = '' }
		,{ id=3,  etype=5, pname = 'Calf Press', form_name = 'calfpress', description = '' }
		,{ id=4,  etype=4, pname = 'Chest', form_name = 'chest2', description = '' }
		,{ id=5,  etype=4, pname = 'Chest Press', form_name = 'chestpress', description = '' }
		,{ id=6,  etype=5, pname = 'Dumbbell Squat', form_name = 'dumbbellsquat', description = '' }
		,{ id=7,  etype=5, pname = 'Knee Extension', form_name = 'kneeextension', description = '' }
		,{ id=8,  etype=5, pname = 'Leg Curl', form_name = 'legcurl', description = '' }
		,{ id=9,  etype=5, pname = 'Leg Press', form_name = 'legpress', description = '' }
		,{ id=10,  etype=4, pname = 'Overhead Press', form_name = 'overheadpress', description = '' }
		,{ id=11,  etype=4, pname = 'Pulldown', form_name = 'pulldown', description = '' }
		,{ id=12,  etype=4, pname = 'Seated Row', form_name = 'seatedrow', description = '' }
		,{ id=13,  etype=4, pname = 'Shoulder', form_name = 'shoulder2', description = '' }
		,{ id=14,  etype=4, pname = 'Tricep Press', form_name = 'triceppress', description = '' }

		 //The other exercises go here
		,{ id=15,  etype =  1, pname = 'Cycle', form_name = 'cycle', description = '' }
		,{ id=16,  etype =  2, pname = 'Treadmill', form_name = 'treadmill', description = '' }
		,{ id=17,  etype =  3, pname = 'Other', form_name = 'other', description = '' }
		]);

		return this;
	}

	public Numeric function upperBody() {
		return 4;
	}

	public Numeric function lowerBody() {
		return 5;
	}

	public Numeric function cycle() {
		return 1;
	}

	public Numeric function treadmill() {
		return 2;
	}

	public Numeric function other() {
		return 3;
	}

	public Query function getAllExercises( ) {
		return this.srcQuery;	
	}

	public Query function getEnduranceExercises( ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE etype IN (1,2,3) " );
		return qr.getResult();
	}

	public Query function getResistanceExercises( ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE etype IN ( 4,5 ) " );
		return qr.getResult();
	}

	public function getSpecificExercises ( required Numeric extype ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qs.addParam( name="extype", value=arguments.extype, cfsqltype="cf_sql_numeric" );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE etype = :extype" );
		return qr.getResult();
	}
}
