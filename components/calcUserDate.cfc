/* -------------------------------------------------- * 
	calcUserDate.cfc

 	Many ways to calculate different user dates... 
 * -------------------------------------------------- */
component {
	property name="app" default="isAppDateSet";
	this.object = {};

	//Jump date in the future or the past
	function jumpDate( ) {
		//Current date
		if ( StructKeyExists( url, "resetdate" ) ) {
			StructDelete( session, "userdate" );	
			//userDateObject = session.userdate = Now();
			if ( StructKeyExists(url, "date") ) {
				try {
					userDateObject = LSParseDateTime( url.date );
					session.userdate = userDateObject;
				}
				catch (any ee) {
					userDateObject = session.userdate = Now();
				}
			}
			else {
				userDateObject = session.userdate = Now();
			}
		}
		else if ( StructKeyExists(url, "date") ) {
			try {
				userDateObject = LSParseDateTime( url.date );
	//writeoutput( "<h2>choosy</h2>" );writedump( userDateObject );
				session.userdate = userDateObject;
			}
			catch (any ee) {
				userDateObject = session.userdate = Now();
	//writeoutput( "<h2>golden</h2>" );writedump( ee );
			}
		}
		else if ( StructKeyExists( session, "userdate" ) ) {
			userDateObject = session.userdate;	
		}
		else {
			//usedDate = DateTimeFormat( Now(), "YYYY-MM-DD HH:nn:ss" );
			userDateObject = session.userdate = Now(); 
		}
	}


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
