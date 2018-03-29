component {
	public function checkFields( scope ) {
		if ( !IsStruct( scope ) ) {
			writeoutput( "[scope] parameter to checkFields() must be a struct.  The intended use of this function is to check either URL, FORM or SESSION for certain field names.  You may also check your own structs if necessary." );
			abort;
		}

		//Cycle through all the arguments and make a judgment
		for ( n in arguments ) {
			if ( n eq "scope" )
				continue;
			else {
				if ( !IsSimpleValue( arguments[n] ) )
					return { status = false, message = n & " didn't exist in requested scope." };
				if ( !StructKeyExists( scope, arguments[n] ) )
					return { status = false, message = "Key '" & arguments[n] & "' didn't exist in requested scope." };
			}
		}

		//return true;
		return { status = true, message = "Success" };
	}
}
