var subLink = "/motrpac/web/secure/dataentry/iv/update.cfm";

document.addEventListener( "DOMContentLoaded", function (ev) 
{
/*
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
*/

	//Create a ghetto router
	locarr = location.href.split( "/" ) ;
	loc = locarr[ locarr.length - 1 ];


	//input only will initialize this...
	if ( loc.indexOf( "input.cfm" ) > -1 || loc.indexOf( "check-in.cfm" ) > -1 )
	{
		//Add an event listener to these input slider
		var b = [].slice.call( document.querySelectorAll( ".slider" ) );  

		//Get that nice slider effect going
		for ( i = 0; i < b.length; i++ ) {
			b[i].addEventListener( "input", function (ev) {
				ev.target.parentElement.parentElement.childNodes[ 3 ].innerHTML = ev.target.value;
				xlogger( "Slider value changed to: " + ev.target.value );
			} );

			if (( aac = b[i].parentElement.parentElement.childNodes[7] ) ) {
				//console.log(aac.childNodes[1]);console.log(aac.childNodes[3]);

				aac.childNodes[1].addEventListener( "click", function (ev) {
					aav = ev.target.parentElement.parentElement.childNodes[3];
					ev.target.value = aav.innerHTML = ++(aav.innerHTML); //console.log( v);
				} ); 
				aac.childNodes[3].addEventListener( "click", function (ev) {
					aav = ev.target.parentElement.parentElement.childNodes[3];
					ev.target.value = aav.innerHTML=--(aav.innerHTML); //console.log( v);
				} ); 
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
	if (( ww =document.getElementById( "wash-id" ) )) 
	{
		ww.addEventListener( "submit", function (ev) {
			ev.preventDefault();

			//Serialize all the data
			vv=[];
			vals = [].slice.call(document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" )); 

			if ( vals.length > 0 ) {
				for ( i=0; i < vals.length; i++) {
					vv[i] = vals[i].innerHTML; 
				}
			}
					
			//send a list back
			this.list.value = vv.join(',');

			//I'll never really submit this, I'll AJAX it instead	
			if ( 0 )
				this.submit();
			else {
				// So, let's see if that works
				var xhr = new XMLHttpRequest();
				var frm = this;

				//Read that XML	
				xhr.onreadystatechange = function () {
					if ( this.readyState == 4 && this.status == 200 ) {
						try {
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

				console.log( payload );

				// tHis is made all the more ugly because I'm using GETs when I should be using POSTs
				if ( 1 ) {
					xhr.open( "POST", "/motrpac/web/secure/dataentry/iv/update.cfm", true );
					xhr.setRequestHeader( "Content-Type", "application/x-www-form-urlencoded" );
					xhr.send( payload );
					/* 
						"staffer_id=" + this.staffer_id.value +
						"&transact_id=" + this.transact_id.value +
						"&this=check-in-complete" +
						"&list=" + this.list.value
					);
					*/
				}
			}
			return;	
		});
	}
})
