<!---
data.cfm

CFM based routing structure.
I can do more with this concept...
  --->
<cfset manifest={
 "source" = "motrpac"
,"cookie" = "3ad2d4dc34e75130c0c2f3c4bbb262481b49250261bcb8e6443728b63d24"
,"base"   = "/motrpac/web/secure/dataentry/iv/"
,"Home"   = "tmp"
,"name"   = "iv"
,"neverExpire"   = -1
,"title"  = "Motrpac Intervention Tracking"
,"debug"  =  0
,"ajaxEveryTime"  =  0
,"master-post" = false
,"data"   = {}
,"css"    = [
	 "zero.css"

	,"https://fonts.googleapis.com/css?family=Montserrat"
	,"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"

	,"c3.min.css"
	,"chart.css"
	,"debug.css"
	,"default.css"
	,"modals.css"
	,"sliders.css"
	,"checkbox-radio.css"
]
,"js"     = [
	 "https://d3js.org/d3.v3.js"
	,"https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"
	,"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"

	,"libs/c3.min.js"
	,"libs/swipesensejs.js"
	,"libs/droppable.js"
	,"libs/sliders.js"
	,"libs/modal.js"
	,"libs/touch.js"
	,"libs/debug.js"
	,"proc/debug.js"
	,"proc/index.js"
]
,"meta"   = [
  { "http-equiv"="content-type", content="text/html; charset=utf-8" }
 ,{ name="viewport", content="minimum-scale=1.0, maximum-scale=1.0, width=device-width, user-scalable=no" }
 ,{ name="apple-mobile-web-app-capable", content="yes" } 
 ,{ name="apple-mobile-web-app-status-bar-style", content="black-translucent" } 
]
,"localOverride" = {
	 "4xx"    = 0
	,"5xx"    = 0
}
,"settings" = {
	 "verboseLog" = 0
	,"addLogLine" = 0
}
,"routes" = {
	 "docs"   = { 
		"model" = "docs"
	 ,"view"  =  "docs"
	 ,"hint"  =  "This just documents this app." 
	}

	,"log"   = { 
		"hint"  =  "See the access log."
	 ,"model" =  "log"
	 ,"view"  =  "log"
	}

	,"robocop"   = { 
		"hint"  =  "Log XHR requests."
	 ,"model" =  "robocop"
	 ,"view"  =  "robocop"
	}

	,"test"   = { 
		"hint"  =  "Test how new HTML5 controls look."
	 ,"model" = [ "test", "session/check", "chosen", "participant" ]
	 ,"view"  = [ "master/head", "participant/list", "participant/nav", "tests/test", "master/tail" ] 
	}

	,"update" = { 
		"hint"  =  "This acts as the server side endpoint for values edited via AJAX." 
	 ,"model" = "update"
	 ,"content_type"  
						= "application/json"
	 ,"view"  =  "update" 
	}


	,"update2" = { 
		"hint"  =  "This will help transition from the old table to Debbie's New Table."
	 ,"model" = "update"
	 ,"content_type"  
						= "application/json"
	 ,"view"  =  "update" 
	}

	,"expired"= { 
		"hint"  =  "The thing of the thing."
	 ,"model" = [ "session/check", "default", "expired", "chosen", "reconcile" ]
	 ,"view"  = [ "master/head", "default", "master/tail" ] 
	}

	,"default"= { 
		"hint"  =  "The thing of the thing."
	 ,"model" = [ "session/check", "default", "chosen", "reconcile" ]
	 ,"view"  = [ "master/head", "default", "master/tail" ] 
	}

	,"hack"= { 
		"hint"  =  "Allows me to choose participants by either form field or url string."
	 ,"model" = [ "session/check", "hack" ]
	 ,"view"  = [ "master/head", "hack", "master/tail" ] 
	}

	,"check-in-complete"= { 
		"hint"  =  "Mark a check-in as completed."
	 ,"model" = [ "session/check", "check-in-complete" ]
	 ,"view"  = "check-in-complete"
	}

	,"chosen" = { 
		"hint"  =  "See all chosen participants in a session."
	 ,"model" = [ "session/check", "chosen" ]
	 ,"view"  = [ "master/head", "participant/list", "chosen", "master/tail" ] 
		}

	,"info"   = { 
		"hint"  =  "See all patient data (more than you ever wanted to know)."
	 ,"model" = [ "session/check", "chosen", "participant" ]
	 ,"view"  = [ "master/head", "participant/list", "participant/nav", "info", "master/tail" ] 
		}

	,"compare"= { 
		"hint"  =  "Compare the participant's previous weeks history."
	 ,"model" = [ "session/check", "chosen", "participant" ]
	 ,"view"  = [ "master/head", "participant/list", "participant/nav", "compare", "master/tail" ] 
		}

	,"check-in" = { 
		"hint"  =  "Enter test data for a participant.  Exercise types and questions are chosen during the randomization process and should not need to be modified here."
	 ,"model" = [ "session/check", "chosen", "participant", "check-in" ]
	 ,"view"  = [ "master/head", "participant/list", "participant/nav", "check-in", "master/tail" ] 
		}

	,"input"  = { 
		"hint"  =  "Enter test data for a participant.  Exercise types and questions are chosen during the randomization process and should not need to be modified here."
	 ,"model" = [ "session/check", "chosen", "participant", "input" ]
	 ,"view"  = [ "master/head", "participant/list", "participant/nav", "input", "master/tail" ] 
		}

	,"logout" = { 
		"model" = "session/kill"
	 ,"view"  =  "logout"
	 ,"hint"  =  "Use this endpoint to revoke all session keys." 
	 	}

	,"dumply" = { 
		"model" = "_none"
	 ,"view"  =  "dumply"
	 ,"hint"  =  "Use this endpoint to see all values." 
		}

	,"test-debendtab"   = { 
		"model" =  "test-debendtab"
	 ,"view"  =  "test-debendtab"
	 ,"hint"  =  "Test against Debbie's new table." 
		}

	,"save"   = { 
		"model" = "_none"
	 ,"view"  =  "save"
	 ,"hint"  =  "Use this endpoint to see all values." 
		}

	,"home"   = { }
	}
}>
