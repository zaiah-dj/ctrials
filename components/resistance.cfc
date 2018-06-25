component name="resistance" {
	this.srcQuery = 0;

	//
	resistance function init () {
		this.srcQuery = queryNew( "type,desig", "Integer,Varchar", [
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
		]);
		return this;
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
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE type = :id" );
		return qr.getResult();	
	}
}
