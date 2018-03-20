//bad way to go about it, but use a global and get things done
fw = { arr:[], index:0 };

function allowDrop(ev) {
	ev.preventDefault();
}

function drag(ev, optArg) {
	if ( optArg ) {
		alert( "swipe complete..." );
		return;
	}
	//ev.dataTransfer.setData("text", ev.target.id);
	console.log( ev.target.innerHTML );
	fw[fw.index] = { id: ev.target.children[1].innerHTML, string: ev.target.children[0].innerHTML };
	console.log( fw[ fw.index ] );
}

function drop(ev) {
	ev.preventDefault();

	//Always check against drop list and make sure the duplicate entries aren't getting in
	aa = [].slice.call( document.querySelectorAll( ".listing-drop ul li span:nth-child(2)" ) ); 

	//check what's in aa
	if ( aa.length > 0 ) {
		for ( i=0; i<aa.length; i++) {
			if ( aa[i].innerHTML == fw[fw.index].id ) {
				console.log( "Looks like this id is already here, stopping request..." );
				return;
			}
		}
	}

	//Add a new node otherwise
	node = document.createElement( "li" );
	span1 = document.createElement( "span" );
	span1.innerHTML = fw[fw.index].string;
	span2 = document.createElement( "span" );
	span2.innerHTML = fw[fw.index].id;
	node.appendChild( span1 ); 
	node.appendChild( span2 ); 
	ev.target.children[0].appendChild( node ); 
}
