<cfscript>
/*Include all CFCs here*/
ajax  = CreateObject( "component", "components.writeback" );
ezdb  = CreateObject( "component", "components.quella" );
rl    = CreateObject( "component", "components.requestLogger" );
cf    = CreateObject( "component", "components.checkFields" );
req   = CreateObject( "component", "components.sendRequest" ).init( dsn="#data.source#" );
ezdb.setDs( datasource = "#data.source#" );
</cfscript>
