var subLink = "/motrpac/web/secure/dataentry/iv/update.cfm";


function onError( msg ) {
	console.log( msg );
}


document.addEventListener( "DOMContentLoaded", function (ev) 
{
	//Create a ghetto router
	locarr = location.href.split( "/" ) ;
	loc = locarr[ locarr.length - 1 ];

	//AJAX notes
	if ( loc.indexOf( "check-in.cfm" ) > -1 ) {
		var butt = document.getElementById("ps_note_save");
		butt.addEventListener( "click", function (ev) {
			ev.preventDefault();
			var pid = [].slice.call( 
				document.querySelectorAll("input[name=ps_pid]") );
			var note = [].slice.call( 
				document.querySelectorAll("textarea[name=ps_notes]") );
			var noteValue = note[0]["value"];
			var xhr = new XMLHttpRequest();	
			xhr.onreadystatechange = function (ev) { 
				if ( this.readyState == 4 && this.status == 200 ) {
					try {
						console.log( this.responseText );
						parsed = JSON.parse( this.responseText );
						var par = [].slice.call( 
							document.querySelectorAll("ul.participant-notes") );
						var li = document.createElement( "li" );
						li.innerHTML = noteValue;
						par[0].appendChild( li ); 
					}
					catch (err) {
						console.log( err.message );console.log( this.responseText );
						return;
					}
				}
			}
			xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update-note.cfm", true );
			xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
			xhr.send( 
				"note=" + note.innerHTML + 
				"&pid=" + pid.value 
			);
		});
	}

	//input only will initialize this...
	if ( loc.indexOf( "input.cfm" ) > -1 || loc.indexOf( "check-in.cfm" ) > -1 )
	{
		//Add an event listener to these input slider
		var b = [].slice.call( document.querySelectorAll( ".slider" ) );  

		//Get that nice slider effect going
		for ( i = 0; i < b.length; i++ ) {
			b[i].addEventListener( "input", function (ev) {
				ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
				//xlogger( "Slider value changed to: " + ev.target.value );
			} );
		}

		//Get the buttons
		for ( i = 0; i < b.length; i++ ) {
			//I think these are buttons
			if (( aac = b[i].parentElement.parentElement.childNodes[7] ) ) {
				aac.childNodes[1].addEventListener( "click", function (ev) {
					ev.preventDefault();
					aav = ev.target.parentElement.parentElement.childNodes[3];
console.log( aav );
					ev.target.value = aav.innerHTML = ++(aav.innerHTML);
				} );
				aac.childNodes[3].addEventListener( "click", function (ev) {
					ev.preventDefault();
					aav = ev.target.parentElement.parentElement.childNodes[3];
console.log( aav );
					ev.target.value = aav.innerHTML = --(aav.innerHTML);
				} ); 
			}
		}

		//Initialize all modals
		var modals = [].slice.call( document.querySelectorAll( ".modal-activate" ) );  
		if ( modals.length ) {
			for ( i=0; i < modals.length; i++ ) {
				//modals[i].addEventListener( "focus", makeModal );
				modals[i].addEventListener( "click", makeModal );
			}
		}
	}

	//Start listening out for touch events
	touchEl = [].slice.call( document.querySelectorAll( ".part-drop-list li" ) );
	if ( touchEl.length ) 
	{
		//Respond to touch and drag
		for ( i=0; i < touchEl.length; i++ ) 
		{
			el = touchEl[ i ];
			el.setAttribute( "draggable", true );
			el.addEventListener( "dragstart", drag ); 
			el.addEventListener( "touchstart", ts, true );
		}
	} 

	//Get .listing
	list = [].slice.call( document.querySelectorAll( ".listing" ) );
	for ( i=0; i<list.length; i++ ) {
		list[i].addEventListener( "touchEnd", te );
		list[i].addEventListener( "touchMove", tm );
		list[i].addEventListener( "touchCancel", tc );
	}

	//Sequence all JS data (This entire sequence can be replaced with the CFWriteback thing.
	if (( ww =document.getElementById( "wash-id" ) )) {
		ww.addEventListener( "click", function (ev) {
			ev.preventDefault();
			//Serialize all the data
			vv=[];
			vals = [].slice.call(document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" )); 
			if ( vals.length > 0 ) {
				for ( i=0; i < vals.length; i++) vv[i] = vals[i].innerHTML; 
			}
			//Prepare a list from the users that have been selected. 
			this.list.value = vv.join(',');
			var frm = this, xhr = new XMLHttpRequest();
			//Read that XML	
			xhr.onreadystatechange = function () {
				if ( this.readyState == 4 && this.status == 200 ) {
					try {
						console.log( this.responseText );
						parsed = JSON.parse( this.responseText );
					}
					catch (err) {
						console.log( err.message );
						console.log( this.responseText );
						return;
					}
					( parsed.status ) ? frm.submit() : onError( this.responseText );
				}
			};

			//What does the pbody look like
			payload = [
				 "staffer_id=" + this.staffer_id.value  
				,"transact_id=" + this.transact_id.value 
				,"list=" + this.list.value 
				,"this=startSession"
			].join( '&' );

			//Send a POST to the server
			xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update.cfm", true );
			xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
			xhr.send( payload );
			//console.log( payload );console.log( xhr.responseText );
			return false;
		});
	}
})
