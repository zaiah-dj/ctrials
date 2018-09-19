/* ----------------------------------------------------*
maybe.js
--------

Things that I'd like to add, but might not prove all
that useful.

 * ----------------------------------------------------*/


/* ------------------------------------ *
function submitAPIRequest( obj ) 

Submit a request to an API endpoint, catching
any errors and whatnot.

An example:
...
	submitAPIRequest({ 
		location: "/motrpac/web/secure/dataentry/iv/api/note_update.cfm" 
	 ,onFailure: function ( arg ) { ; }
	 ,onSuccess: function ( arg ) {
			parsed = JSON.parse( this.responseText );
			(li = document.createElement( "li" )).innerHTML = noteValue;
			//li.innerHTML = noteValue;
			ref.appendChild( li ); 
			//TODO: This is not the greatest way to remove this box. 
			shadenode.parentElement.removeChild( shadenode );
		} 
	 ,payload: {
			note: noteValue
		 ,pid:  pd[0].value
		 ,sid:  sd[0].value
		}
	);

 * ------------------------------------ */
function submitAPIRequest( obj ) {
	//Run some sanity checks
	if ( !obj.location ) {
		console.log( "submitAPIRequest: 'location' key not specified in my argument object..." );
		return;
	}	

	//We can make educated assumptions otherwise...
	var lMethod = ( !obj.method ) ? "POST" : obj.method;

	//Update the note field	
	var xhr = new XMLHttpRequest();	

	//A defualt onreadystatechange is here, but you can define another if need be.
	xhr.onreadystatechange = function (ev) { 
		if ( this.readyState == 4 && this.status == 200 ) {
			try {
				console.log( this.responseText );
				parsed = JSON.parse( this.responseText );
				var par = [].slice.call( document.querySelectorAll( "ul.participant-notes" ) );
				var li = document.createElement( "li" );
				li.innerHTML = noteValue;
				par[0].appendChild( li ); 
				//TODO: This is not the greatest way to remove this box. 
				shadenode.parentElement.removeChild( shadenode );
			}
			catch (err) {
				console.log( err.message );console.log( this.responseText );
				return;
			}
		}
	}


	//Make the request
	if ( obj.method != "POST" ) {
		xhr.open( obj.method, obj.location, true );
		xhr.send( );
	}
	else if ( obj.method == "POST" ) {
		xhr.open( "POST", obj.location, true );
		xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
		xhr.send( 
			"note=" + noteValue + 
			"&pid=" + pd[0].value +
			"&sid=" + sd[0].value
		);
	}
	/*else {;}*/ //This ought to be for multipart requests...
}
