<div class="container-body">
	<form name="" action="#link( '' )#">
		<input type="hidden" name="pid" value="#url.id#">

		<table class="table table-striped participant-entry">
			<!--- Only show if the participant is resistance based --->
			<tr>
				<td>Recovery / Stretching Completed</td>
				<td>
					<div class="clabel">
						Yes	
						<input type=radio name=recovery value="0"></input>
						<span class="checkmark"></span>
					</div>
					<div class="clabel">
						No	
						<input type=radio name=recovery value="1"></input>
						<span class="checkmark"></span>
					</div>
					<div class="clabel">
						Not Done	
						<input type=radio name=recovery value="1"></input>
						<span class="checkmark"></span>
					</div>
				</td>
			</tr>

			<tr>
				<td>How many breaks were taken during exercise?</td>
				<td>
					<div class="clabel">
						0
						<input type=radio name=breaksTaken value="0"></input>
						<span class="checkmark"></span>
					</div>
					<div class="clabel">
						1
						<input type=radio name=breaksTaken value="1"></input>
						<span class="checkmark"></span>
					</div>
					<div class="clabel">
						More than 1
						<input type=radio name=breaksTaken value=">1"></input>
						<span class="checkmark"></span>
					</div>
				</td>
			</tr>

			<cfif ListContains(ENDURANCE, part_list.results.randomGroupCode)>
			<tr>
				<td>Was the session stopped early?</td>
				<td>
					<div class="clabel">
						No	
						<input type=radio name=breaksTaken value="0"></input>
						<span class="checkmark"></span>
					</div>
					<div class="clabel">
						Yes	
						<input type=radio name=breaksTaken value="1"></input>
						<span class="checkmark"></span>
					</div>
				</td>
			</tr>
			<tr>
				<td>Specify reason stopped early:</td>
				<td>
					<button class="modal-activate">Add Reason</a>
					<div id="myModal" class="modal">
						<div class="modal-content">
							<span class="close">&times;</span>
							<p>Equipment Log</p>
							<textarea name="reasonStoppedEarly"></textarea>
							<!--- 
								<button class="inc-button" id="el_reason_save">Save</button>
								--->
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>Record the Heart Rate, RPE and Affect here if stopped early</td>
				<td>
					<style type="text/css">
					table.innard { width: 100%; }
					table.innard tr { height: 70px; }
					table.innard td.thin { width: 10%; }
					</style>
					<table class="innard"> 
					<tr>
						<td class="thin">HR:</td>
						<td>
							<div class="row">
								<div class="cc col-sm-7">
									<input type="range" min="0" max="100" class="slider" value="50" name="recoveryHR">
								</div>
								<div class="catch cc col-sm-1">0</div>
								<div class="col-sm-1">(uom)</div>
								<div class="col-sm-1">
									<button class="inc-button">+</button>
									<button class="inc-button">-</button>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="thin">RPE:</td>
						<td>
							<div class="row">
								<div class="cc col-sm-7">
									<input type="range" min="0" max="100" class="slider" value="50" name="recoveryRPE">
								</div>
								<div class="catch cc col-sm-1">0</div>
								<div class="col-sm-1">(uom)</div>
								<div class="col-sm-1">
									<button class="inc-button">+</button>
									<button class="inc-button">-</button>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td class="thin">Affect:</td>
						<td>
							<div class="row">
								<div class="cc col-sm-7">
									<input type="range" min="0" max="100" class="slider" value="50" name="recoveryAffect">
								</div>
								<div class="catch cc col-sm-1">0</div>
								<div class="col-sm-1">(uom)</div>
								<div class="col-sm-1">
									<button class="inc-button">+</button>
									<button class="inc-button">-</button>
								</div>
							</div>
						</td>
					</tr>
					</table>
				</td>
			</tr>
			</cfif>
		</table>
		<input id="sendPageVals" type="submit" value="Finish!" style="width: 200px;color:white;"></input>
	</form>
</div>
