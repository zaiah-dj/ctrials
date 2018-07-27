/* List of endurance exercises. */
component name="endurance" {
	this.srcQuery = 0;

	//
	endurance function init () {
		//Label time defaults for endurance
		this.srcQuery = queryNew( 
		 "label,index,text", 
		 "Varchar,Integer,Varchar", [
		 { label="wrmup_", index=0,  text="Warm-Up" }
		,{ label="m5_ex" , index=5,  text="<5m"  }
		,{ label="m10_ex", index=10, text="<10m" }
		,{ label="m15_ex", index=15, text="<15m" }
		,{ label="m20_ex", index=20, text="<20m" }
		,{ label="m25_ex", index=25, text="<25m" }
		,{ label="m30_ex", index=30, text="<30m" }
		,{ label="m35_ex", index=35, text="<35m" }
		,{ label="m40_ex", index=40, text="<40m" }
		,{ label="m45_ex", index=45, text="<45m" }
	//,{ index=50, text="<50m" }
		] );

		//Label defaults for endurance
		//NOTE: RPE, Affect and Heart Rate will not always show (wish i oculd use a query for this...)
		this.labelDefaults = [
			{ uom="rpm", label="RPM", min=30, max=130, step=1, formName="rpm", type=1, frequency="0" }
		 ,{ uom="lb" , label="Watts/Resistance", min=0, max=50, step=1, formName="watres", type=1, frequency="0" }
		 ,{ uom="mph", label="Speed", min=0, max=50, step=1, formName="speed", type=2, frequency="0" }
		 ,{ uom="%"  , label="Percent Grade", min=0, max=20, step=1, formName="prctgrade", type=2, frequency="0" }
		 ,{ uom=""   , label="othMchn1", min=20, max=120, step=1, formName="oth1", type=3, frequency="0" }
		 ,{ uom=""   , label="othMchn2", min=20, max=120, step=1, formName="oth2", type=3, frequency="0" }
		 ,{ uom="bpm", label="Heart Rate", min=20, max=120, step=1, formName="hr", type=0, frequency="0" }
		 ,{ uom="rpe", label="RPE", min=20, max=120, step=1, formName="rpe", type=0, frequency="0,20,45" }
		 ,{ uom="%"  , label="Affect", min=20, max=120, step=1, formName="Othafct", type=0, frequency="0,20,45" }
		];
		return this;
	}

	public function getLabelsFor( Required Numeric id, Required Numeric tb ) {
		ld = [];
		for ( n in this.labelDefaults ) {
			if ( ( n.type eq 0 || n.type eq id ) && (n.frequency eq "0" || ListFind( n.frequency, tb ) )) { 
				ArrayAppend( ld, n );
			}
		}
		return ld;
	}

	public Query function getTimeInfo( Required Numeric id ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qs.addParam( name = "id", value = id, cfsqltype = "cf_sql_numeric"  );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE index = :id" );
		return qr.getResult();	
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
