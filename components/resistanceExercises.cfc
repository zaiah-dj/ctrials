/* List of resistance exercises. */
component name="resistanceExercises" {
	this.srcQuery = 0;

	//constructor
	resistanceExercises function init ( ) {
		this.srcQuery = queryNew( "id,etype,pname,form_name,description", "Integer,Integer,Varchar,Varchar,Varchar", [
		 { id=1,  etype =  1, pname = 'Abdominal Crunch', form_name = 'abdominalcrunch', description = '' }
		,{ id=2,  etype =  1, pname = 'Bicep Curl', form_name = 'bicepcurl', description = '' }
		,{ id=3,  etype =  2, pname = 'Calf Press', form_name = 'calfpress', description = '' }
		,{ id=4,  etype =  1, pname = 'Chest', form_name = 'chest2', description = '' }
		,{ id=5,  etype =  1, pname = 'Chest Press', form_name = 'chestpress', description = '' }
		,{ id=6,  etype =  2, pname = 'Dumbbell Squat', form_name = 'dumbbellsquat', description = '' }
		,{ id=7,  etype =  2, pname = 'Knee Extension', form_name = 'kneeextension', description = '' }
		,{ id=8,  etype =  2, pname = 'Leg Curl', form_name = 'legcurl', description = '' }
		,{ id=9,  etype =  2, pname = 'Leg Press', form_name = 'legpress', description = '' }
		,{ id=10,  etype =  1, pname = 'Overhead Press', form_name = 'overheadpress', description = '' }
		,{ id=11,  etype =  1, pname = 'Pulldown', form_name = 'pulldown', description = '' }
		,{ id=12,  etype =  1, pname = 'Seated Row', form_name = 'seatedrow', description = '' }
		,{ id=13,  etype =  1, pname = 'Shoulder', form_name = 'shoulder2', description = '' }
		,{ id=14,  etype =  1, pname = 'Tricep Press', form_name = 'triceppress', description = '' }
	]);

		return this;
	}

	public Numeric function upperBody() {
		return 1;
	}

	public Numeric function lowerBody() {
		return 2;
	}

	public Query function getAllExercises( ) {
		return this.srcQuery;	
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
