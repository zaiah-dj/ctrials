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
,"debug"  =  1
,"ajaxEveryTime"  =  0
,"master-post" = false
,"data"   = {
	"endurance"  = "ac_mtr_endurance_new"
 ,"resistance" = "ac_mtr_resistance_new"
 ,"sessionTable" = "ac_mtr_logging_progress_tracker"
 ,"exerciseList" = "ac_mtr_resistance_exercise_list"
}
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
	"default"= { 
		"hint"  =  "The participant selection page as seen by the interventionists."
	 ,"model" = [
			"dependencies"
			,"check_valid_session"
			,"currentId"
			,"select_all_participants"
			,"select_chosen_participants"
			,"select_unchosen_participants" 
			,"update_valid_session"
		]
	 ,"view"  = [ 
			"master/head", 
			"default", 
			"master/tail" 
		] 
	}

	,"update" = { 
		"hint"  =  "This acts as the server side endpoint for values edited via AJAX." 
	 ,"model" = [
			"dependencies"
		 ,"ajax_test"
		 ,"check_valid_session"
		 ,"currentId"
		 ,"recall_valid_session"
		 ,"ajax_start_new_session"
		 ,"ajax_update_resistance_table"
		 ,"ajax_update_endurance_table"
		 ,"ajax_update_control_table"
		]
	 ,"view"  =  "update"
	 ,"content_type"  = "application/json"
	}

	,"input"  = { 
		"hint"  =  "Enter test data for a participant.  Exercise types and questions are chosen during the randomization process and should not need to be modified here."
	 ,"model" = [ 
			 "dependencies"
			,"check_valid_session"
			,"currentId"
			,"recall_valid_session"
			,"update_valid_session"
			,"select_chosen_participants"
			,"select_single_participant"
			,"prepare_endurance_input"
			,"prepare_resistance_input"
			,"prepare_control_input" 
		]
	 ,"view"  = [ 
			"master/head", 
			"participant/list", 
			"participant/nav", 
			"input", 
			"master/tail" 
		]
		}

	,"check-in" = { 
		"hint"  =  "Enter test data for a participant.  Exercise types and questions are chosen during the randomization process and should not need to be modified here."
	 ,"model" = [ 
			 "dependencies"
			,"check_valid_session"
			,"currentId"
			,"recall_valid_session"
			,"update_valid_session"
			,"process_checkin_form"
			,"select_chosen_participants"
			,"select_single_participant"
			,"select_participant_check_in_data"
			,"select_participant_notes"
		]
	 ,"view"  = [ 
			 "master/head"
			,"participant/list"
			,"participant/nav"
			,"check-in"
			,"master/tail" 
		]
		}

	,"logout" = { 
		"model" = "session/kill"
	 ,"view"  =  "logout"
	 ,"hint"  =  "Use this endpoint to revoke all session keys." 
	 	}

	,"login" = { 
		"model" = "session/kill"
	 ,"view"  =  "logout"
	 ,"hint"  =  "Use this endpoint to revoke all session keys." 
	 	}

	,"compare"= { 
		"hint"  =  "Compare the participant's previous weeks history."
	 ,"model" = [ 
			 "dependencies"
			,"check_valid_session"
			,"select_chosen_participants"
			,"select_single_participant"
		]
	 ,"view"  = [ 
			"master/head"
			,"participant/list" 
			,"participant/nav"
			,"compare"
			,"master/tail" 
		] 
		}

		,"log"   = { 
			"hint"  =  "See the access log."
		 ,"model" =  "dev/log"
		 ,"view"  =  "log"
		}

		,"robocop"   = { 
			"hint"  =  "Log XHR requests."
		 ,"model" =  "dev/robocop"
		 ,"view"  =  "robocop"
		}

		,"sessdata" = { 
			"model" =  [ 
				"dependencies", 
				"currentId", 
				"show_valid_session" 
			]
		 ,"view"  =  "logout"
		 ,"hint"  =  "An AJAX endpoint to tell me information about where the user is."
			}
	}
}>