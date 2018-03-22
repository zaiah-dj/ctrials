<!--- compare everything that's comparable --->
<div class="container-body">

	<!--- ... --->
	<script> 
	document.addEventListener( "DOMContentLoaded", function (ev) {
		var chart = c3.generate({
				bindto: '#chart',
				data: {
					columns: [
						['data1', 30, 200, 100, 400, 150, 250],
						['data2', 50, 20, 10, 40, 15, 25]
					]
				}
		});
	});
	</script>

<cfoutput>
	<ul class="inner-selection">
	<cfloop from=1 to=12 index=aa> 
		<a href="##"><li>Week #aa#</li></a>
	</cfloop>
	</ul>

	<!--- Chart --->
	<div id="chart"></div>
</cfoutput>
</div>
