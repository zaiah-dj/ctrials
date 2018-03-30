component {
	public function sendJson( required numeric status, required string message, fields ) {
		
		writeoutput( '{ "status":	#status#, "message": "#message#" }' );
		return true;
	}
}
