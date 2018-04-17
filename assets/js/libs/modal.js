/*modal.js - Add everything with this modal class*/
/*
 * cycle through things with .modal class
 * on click (or maybe some other event), open the next member on the DOM as a pop-up
 * within this element should be a span tag that can trigger close
 */

function makeModal( ev ) {
	//console.log( ev.target.nextElementSibling );
	ev.preventDefault();
	//The thing pressed	
	var b = ev.target;
	//The actual window
	var m = ev.target.nextElementSibling;
	//The thing to close
	var c = ev.target.nextElementSibling.querySelector( ".close" );
	//Select an onclick
	b.onclick = function() {
		m.style.display = "block";
	}
	c.onclick = function() {
		m.style.display = "none";
	}
}

/*
document.addEventListener( "DOMContentLoaded", function (ev) {
	// Get the modal
	var modal = document.getElementById('myModal');

	// Get the button that opens the modal
	var btn = document.getElementById("myBtn");

	// Get the <span> element that closes the modal
	var span = document.getElementsByClassName("close")[0];

	// When the user clicks on the button, open the modal 
	btn.onclick = function() {
			modal.style.display = "block";
	}

	// When the user clicks on <span> (x), close the modal
	span.onclick = function() {
			modal.style.display = "none";
	}
});
*/
