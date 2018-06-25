/* List of endurance exercises. */
component name="endurance" {
	this.srcQuery = 0;

	//
	endurance function init () {
		this.srcQuery = queryNew( "index,text", "Integer,Varchar", [
		 { index=0,  text="Warm-Up" }
		,{ index=5,  text="<5m"  }
		,{ index=10, text="<10m" }
		,{ index=15, text="<15m" }
		,{ index=20, text="<20m" }
		,{ index=25, text="<25m" }
		,{ index=30, text="<30m" }
		,{ index=35, text="<35m" }
		,{ index=40, text="<40m" }
		,{ index=45, text="<45m" }
	//,{ index=50, text="<50m" }
		] );
		return this;
	}

	public Query function getEndurance( ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qr = qs.execute( sql = "SELECT * FROM sourceQuery" );
		return qr.getResult();	
	}
}
