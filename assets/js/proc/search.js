document.addEventListener( "DOMContentLoaded", function (ev) {
	//Basic filter search works
	if ( ip = document.getElementById( "bigly-search" ) ) { 
		ip.addEventListener( "keyup", function (ev) {
			vv = [].slice.call( document.querySelectorAll( "ul.part-drop-list li" ) );
			for ( i=0; i < vv.length; i++ ) {
				nod =         vv[i].children[0].parentElement;
				key = String( vv[i].children[0].innerHTML );
				val = ev.target.value;
				nod.style.display = ( key.toLowerCase().indexOf( val.toLowerCase() ) == -1 ) ? "none" : "block"; 
		}});
	}
}
