<cfscript>
	ezdb  = CreateObject( "component", "components.quella" );
	ezdb.exec( string = "DELETE FROM ac_mtr_endurance_test_v3" );
	ezdb.exec( string = "DELETE FROM ac_mtr_resistance_test_v3" );
</cfscript>
