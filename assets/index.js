document.addEventListener( "DOMContentLoaded", function (ev) 
{
	//submit to server (handles a lot of data serialization)
	function subToServer ( ev ) {
		if ( this.readyState == 4 && this.status == 200 ) {
			//parsed = JSON.parse( this.responseText );
			
		}
	}


	//???What is this?
	a = [].slice.call( document.querySelectorAll( ".participants li" ) );
	for ( i = 0 ; i < a.length; i++ ) {
		//make it big if clicked
		a[i].addEventListener( "click", function ( ev ) {
			if ( ev.target.parentElement.className.indexOf( "active" ) == -1 ) {
				ev.target.parentElement.className += "active";
				ev.target.parentElement.focus();
			}	
			else {
				ev.target.parentElement.className = "";
			}	
		} );
	}


	//Create a ghetto router
	locarr = location.href.split( "/" ) ;
	loc = locarr[ locarr.length - 1 ];

	if ( loc.indexOf( "input.cfm" ) > -1 ) {

		//Add an event listener to these input slider
		var b = [].slice.call( document.querySelectorAll( ".slider" ) );  

		//...
		for ( i = 0; i < b.length; i++ ) {
			//Get that nice slider effect going
			b[i].addEventListener( "input", function (ev) {
				ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
			} );

			//This allows this to fire and save when the user is done
			b[i].addEventListener( "change", function (ev) {
				//ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
				//alert( "New value is: " + ev.target.value );
				var xhr = new XMLHttpRequest();
				var frm = this;

				//Read that XML	
				xhr.onreadystatechange = subToServer;

				xhr.open( "POST", "", true );
				xhr.send( "postdata=postdata&postdata2=morepostdata" );

			} );
		}
	}
		
})
