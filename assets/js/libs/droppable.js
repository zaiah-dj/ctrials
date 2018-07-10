//bad way to go about it, but use a global and get things done
fw = { arr:[], index:0 };

function allowDrop(ev) {
	ev.preventDefault();
}

function drag(ev, optArg) {
	var isDebugPresent = document.getElementById( "cfdebug" );
	if ( optArg ) {
		( isDebugPresent ) ? console.log( "swipe complete..." ) : 0;
		return;
	}
	else {
		( isDebugPresent ) ? console.log( "drag complete..." ) : 0;
		//ev.dataTransfer.setData("text", ev.target.id);
		//console.log( ev.target.innerHTML );
		fw[fw.index] = { 
			id: ev.target.children[1].innerHTML
		, string: ev.target.children[0].innerHTML 
		, className: ev.target.className
		};
		//console.log( fw[ fw.index ] );
	}
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
	node.className =  fw[fw.index].className + "-dropped";//"endurance-class-dropped"; 
	divL = document.createElement( "div" );
	divL.className = "left";
	divR = document.createElement( "div" );
	divR.className = "right";
	span1 = document.createElement( "span" );
	//console.log( "'" + fw[fw.index].string.replace(/([0-9].*)/,"").replace(" (","") + "'" );
	span1.innerHTML = fw[fw.index].string.replace(/([0-9].*)/,"").replace(" (","");
	span2 = document.createElement( "span" );
	span2.innerHTML = fw[fw.index].id;
	divL.appendChild( span1 ); 
	divL.appendChild( span2 ); 
	ahref = document.createElement( "a" );
	ahref.className = "release"; 
	ahref.innerHTML = "Release"; 
	divR.appendChild( ahref );
	node.appendChild( divL );
	node.appendChild( divR );
	ev.target.children[0].appendChild( node ); 
}
