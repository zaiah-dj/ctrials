/* -------------------------------------------------- * 
	endurance.cfc

  List of endurance exercises. 
 * -------------------------------------------------- */
component name="endurance" {
	this.srcQuery = 0;

	//
	endurance function init () {
		//Label time defaults for endurance
		this.srcQuery = queryNew( 
		 "prefix,urlparam,pname", 
		 "Varchar,Integer,Varchar", [
		 { prefix="wrmup_", urlparam=0,  pname="Warm-Up" }
		,{ prefix="m5_ex" , urlparam=5,  pname="<5m"  }
		,{ prefix="m10_ex", urlparam=10, pname="<10m" }
		,{ prefix="m15_ex", urlparam=15, pname="<15m" }
		,{ prefix="m20_ex", urlparam=20, pname="<20m" }
		,{ prefix="m25_ex", urlparam=25, pname="<25m" }
		,{ prefix="m30_ex", urlparam=30, pname="<30m" }
		,{ prefix="m35_ex", urlparam=35, pname="<35m" }
		,{ prefix="m40_ex", urlparam=40, pname="<40m" }
		,{ prefix="m45_ex", urlparam=45, pname="<45m" }
		,{ prefix="m3_rec", urlparam=50, pname="3<super>rd</super> Minute Recovery" }
//	,{ prefix="m5_rec", urlparam=50, pname="Stop Session" }
		]);

		//Label defaults for endurance
		//NOTE: RPE, Affect and Heart Rate will not always show (wish i oculd use a query for this...)
		this.labelDefaults = queryNew( 
		 "uom,label,min,max,step,formName,type,paramMatch",
		 "Varchar,Varchar,Integer,Integer,Integer,Varchar,Integer,Integer", [
			{ uom="RPM", label="RPM", min=30, max=130, step=1, formName="rpm", type=1, paramMatch=1 }
		 ,{ uom="lb" , label="Watts/Resistance", min=0, max=50, step=1, formName="watres", type=1, paramMatch=1 }
		 ,{ uom="MPH", label="Speed", min=0, max=50, step=1, formName="speed", type=2, paramMatch=1 }
		 ,{ uom="%"  , label="Percent Grade", min=0, max=20, step=1, formName="prctgrade", type=2, paramMatch=1 }
		 ,{ uom=""   , label="othMchn1", min=20, max=120, step=1, formName="oth1", type=3, paramMatch=1 }
		 ,{ uom=""   , label="othMchn2", min=20, max=120, step=1, formName="oth2", type=3, paramMatch=1 }
		 ,{ uom="BPM", label="Heart Rate", min=70, max=140, step=1, formName="hr", type=0, paramMatch=0 }
		 ,{ uom="RPE", label="RPE", min=6, max=20, step=1, formName="rpe", type=0, paramMatch=0 }
		 ,{ uom=""   , label="Affect", min=-5, max=5, step=1, formName="Othafct", type=0, paramMatch=0 }
		]);

		return this;
	}

	public function getLabelsFor( Required Numeric a, Required Numeric b ) {
		pullFrom = ( b==0 || b==20 || b==45 ) ? 0 : -1;
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.labelDefaults );
		qs.addParam( name = "mod", value = pullFrom, cfsqltype="cf_sql_numeric" );
		qs.addParam( name = "t", value = a, cfsqltype="cf_sql_numeric" );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE type = :t OR type = :mod" );
		return qr.getResult();	
	}

	public Query function getTimeInfo( Required Numeric id ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qs.addParam( name = "id", value = id, cfsqltype = "cf_sql_numeric"  );
		qr = qs.execute( sql = "SELECT * FROM sourceQuery WHERE urlparam = :id" );
		return qr.getResult();	
	}

	public Query function getModifiers( ) {
		qs = new query();	
		qs.setName( "juice" );
		qs.setDBType( "query" );
		qs.setAttributes( sourceQuery = this.srcQuery ); 
		qr = qs.execute( sql = "SELECT * FROM sourceQuery" );
		return qr.getResult();	
	}

}
