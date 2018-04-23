/*modal.js - Add everything with this modal class*/
/*
 * cycle through things with .modal class
 * on click (or maybe some other event), open the next member on the DOM as a pop-up
 * within this element should be a span tag that can trigger close
 */
function makeModal( ev ) {
	//console.log( ev.target.nextElementSibling );
	//console.log( "..." );
	ev.preventDefault();
	//The thing pressed	
	var b = ev.target;
	//The actual window
	var m = ev.target.nextElementSibling;
	//The thing to close
	var c = ev.target.nextElementSibling.querySelector( ".close" );
	//console.log( b, m, c );
	//Select an onclick
	b.onclick = function() {
		m.style.display = "block";
	}
	c.onclick = function() {
		m.style.display = "none";
	}
}
