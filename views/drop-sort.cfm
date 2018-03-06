<cfset submit_link="#link( 'start-daily.cfm' )#">
<cfset linkish="#link( 'chosen.cfm' )#">
<style type="text/css">
.short-list { position: relative; border/*-bottom*/: 2px solid black; margin-bottom: 10px; width: 100%; }
.wash input[type=text] { display: none; }
.wash input[type=submit] { margin-top: 10px; font-size: 1.2em; background-color: #ccc; border-radius: 5px; -moz-border-radius: 5px; -gecko-border-radius: 5px; display: block; float: right; width: 100px; height: 50px; border: 0px; transition: background-color 0.2s; color 0.2s; }
.wash input[type=submit]:hover { background-color: cyan; color: white; }
.bigly input[type=search] { border: 0px; font-size: 1.5em; padding: 10px; }
.short-list ul li { width: 50px; display: inline-block; background: black; padding-left: 10px; }
.short-list ul li:hover { background: white; }

ul.part-drop-list li:hover { background-color: black; color: white; }
.part-div { overflow: hidden; }
</style>

<!--- A way to sort participants ahead of time --->
<script type="text/javascript">
//bad way to go about it, but use a global and get things done
fw = { arr:[], index:0 };

function allowDrop(ev) {
	ev.preventDefault();
}

function drag(ev) {
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

//When you click stuff--this thing should save
document.addEventListener( "DOMContentLoaded", function (ev) {
	document.getElementById( "wash-id" ).addEventListener( "submit", function (ev) {
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
					//console.log( this.responseText );
					parsed = JSON.parse( this.responseText );
					console.log( parsed );

					
					if ( parsed.status == 200 ) {
						//JS Forwards us on... but this is not super safe...
						frm.submit(); //I'm only concerned with trans_id
		
						//window.location.replace( "<cfoutput>#link('chosen.cfm')#</cfoutput>" );	

					}
					else {

					}
				}
			};

			// This is butt-ugly and should be done differently
			console.log( "opening connection to " + "<cfoutput>#submit_link#</cfoutput>" );

			//What does the pbody look like
			payload = [
				 "staffer_id=" + this.staffer_id.value  
				,"transact_id=" + this.transact_id.value 
				,"list=" + this.list.value 
			].join( '&' );

			console.log( payload );

			// tHis is made all the more ugly because I'm using GETs when I should be using POSTs
			if ( 0 ) {
				xhr.open( "POST", '<cfoutput>#submit_link#</cfoutput>', true );
				xhr.send( 
					"staffer_id=" + this.staffer_id.value +
					"&transact_id=" + this.transact_id.value +
					"&list=" + this.list.value
				);
			}
			else {
				xhr.open( "GET", '<cfoutput>#submit_link#</cfoutput>?' + payload , true );
				xhr.send( );
			}
		}
		return;	
	});
});
</script>


<cfoutput>
<div class="part-div">
	<div class="bigly">

		<!--- Search for names --->
		<input type="search">

		<!--- Or find all A's --->
		<div class="short-list">
		<!--- 
			<ul>
			<cfloop list="a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z" index="item">
			<a href="##" class="tiny-link"><li>#item#</li></a>
			</cfloop>
			</ul>
		--->
		</div>

		<!--- Drag and drop --->
		<div class="listing">
		<ul class="part-drop-list">
			<cfloop query = "part_list">
				<li draggable="true" ondragstart="drag(event)">
					<span>#participant_fname# #participant_lname#</span>
					<span>#participant_id#</span>
				</li>	
			</cfloop>
		</ul>
		</div>

	</div>

	<div class="bigly" style="float: right;" ondrop="drop(event)" ondragover="allowDrop(event)">
		<div class="listing listing-drop">
			<ul> 
			</ul>
		</div>
	</div>


	<!--- On submit, or next, do it. --->
	<form id="wash-id" method="POST" action="#linkish#" class="wash"> 
		<input type="text" name="staffer_id" value="#randnum( 8 )#"> <!--- Generate this on the fly, but maybe cf should do this...? --->
		<input type="text" name="transact_id" value="#randnum( 8 )#"> <!--- Generate this on the fly, but maybe cf should do this...? --->
		<input type="text" name="list"> <!--- make a list here --->
		<input type="submit" value="Done!">
	</form>
</div>
</cfoutput>
