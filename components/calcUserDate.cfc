/* -------------------------------------------------- * 
	calcUserDate.cfc

 	Many ways to calculate different user dates... 
 * -------------------------------------------------- */
component {
	property name="app" default="isAppDateSet";
	this.object = {};

	//Return user date object
	function init ( Required dtArg ) {
		userDateObject = session.userdate = dtArg; 
		this.object = {
			 userDate = DateTimeFormat( userDateObject, "YYYY-MM-DD HH:nn:ss" )
			,dateObject = userDateObject
			,currentDayOfWeek = ((DayOfWeek(userDateObject) - 1) == 0) ? 7 : DayOfWeek(userDateObject) - 1
			,currentDayOfWeekName = DateTimeFormat( userDateObject, "EEE" )
			,currentDayOfMonth = DateTimeFormat( userDateObject, "d" )
			,currentMonth = DateTimeFormat( userDateObject, "m" )
			,currentYear = DateTimeFormat( userDateObject, "YYYY" )
			,currentWeekOfYear = DateTimeFormat( userDateObject, "w" )
		};
		return this;
	}


	//Simply check if the session was set?
	function isDateSessionSet ( t ) {
		return ( StructKeyExists( session, "isAppDateSet" ) );
	}


	//Set session things
	function setSessionKeys ( t ) {
		session.isAppDateSet = 1;
		session.currentDayOfWeek = this.object.currentDayOfWeek;
		session.currentDayOfWeekName = this.object.currentDayOfWeekName;
		session.currentDayOfMonth = this.object.currentDayOfMonth;
		session.currentMonth = this.object.currentMonth;
		session.currentYear = this.object.currentYear;
		session.currentWeekOfYear = this.object.currentWeekOfYear;
	}
}
