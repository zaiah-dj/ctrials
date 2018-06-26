<!---
data.cfm

CFM based routing structure.
I can do more with this concept...

	"endurance"      = "frm_ADUEndurance"
 ,"resistance"     = "frm_ADUResistance"
 ,"participants"   = "v_ADUSessionTickler"

	"endurance"      = "ac_mtr_endurance_new"
 ,"resistance"     = "ac_mtr_resistance_new"
 ,"participants"   = "ac_mtr_participants_v2"

			,"prepare_endurance_input"
			,"prepare_resistance_input"
			,"prepare_control_input" 

			,"select_participant_check_in_data"
			,"select_participant_notes"
			,"select_failure_reasons"
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
	"endurance"      = "ac_mtr_endurance_new"
 ,"resistance"     = "ac_mtr_resistance_new"
 ,"participants"   = "ac_mtr_participants_v2"
 ,"notes"          = "ac_mtr_participant_notes"
 ,"sessionTable"   = "ac_mtr_logging_progress_tracker_v2"
 ,"sessionMembers" = "ac_mtr_participant_transaction_members_v2"
 ,"exerciseList"   = "ac_mtr_resistance_exercise_list"
 ,"checkin"        = "ac_mtr_checkinstatus_v2"
 ,"bloodpressure"  = "ac_mtr_bloodpressure_v2"
}
,"css"    = [
	 "zero.css"

	,"https://fonts.googleapis.com/css?family=Montserrat"
	,"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"

	,"c3.min.css"
	,"chart.css"
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
	,"libs/handlebars-v4.0.11.js"
	,"libs/unhide.js"
	,"libs/routex.js"
	,"proc/debug.js"
	,"proc/indy.js"
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
	 ,"model" = ["initialize_session_and_current_id","update_valid_session" ]
	 ,"view"  = [ 
			"master/head", 
			"default", 
			"master/tail" 
		] 
	}

	,"modal-results" = { 
		"hint"  =  "Results for previous weeks go here." 
	 ,"model" = ["initialize_session_and_current_id" ,"api" ]
	 ,"view"  =  "modal-results"
	 ,"content_type"  = "application/json"
	}

	,"completed-days-results" = {
		"hint" = "Results for completed days in a week go here."
	 ,"model" = [ "initialize_session_and_current_id", "api" ]
	 ,"view" = "days-results"
	}

	,"update" = { 
		"hint"  =  "This acts as the server side endpoint for values edited via AJAX." 
	 ,"model" = ["initialize_session_and_current_id","api" ]
	 ,"view"  =  "update"
	 ,"content_type"  = "application/json"
	}

	,"update-note" = {
		"hint" = "Used to update notes in place."
		,"model" = [ "initialize_session_and_current_id", "api" ]
		,"view" = "nothing"
	}

	,"recovery-done" = {
		"hint" = "Used to mark the end of a session for a user."
		,"model" = [ "initialize_session_and_current_id", "recovery-done" ]
		,"view" = "recovery-done"
	}

	,"input"  = { 
		"hint"  =  "Enter test data for a participant.  Exercise types and questions are chosen during the randomization process and should not need to be modified here."
	 ,"model" = [ "initialize_session_and_current_id", "update_valid_session", "input" ]
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
			 "initialize_session_and_current_id"
			,"update_valid_session"
			,"process_checkin_form"
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
		"model" = "destroy_session"
	 ,"view"  =  "logout"
	 ,"hint"  =  "Use this endpoint to revoke all session keys." 
	 	}

	,"login" = { 
		"model" = "session/kill"
	 ,"view"  =  "logout"
	 ,"hint"  =  "Use this endpoint to revoke all session keys." 
	 	}

	,"recovery" = { 
		"model" = [ 
			 "initialize_session_and_current_id"
			,"update_valid_session"
		]
	 ,"view"  = [ 
			"master/head"
			,"participant/list" 
			,"participant/nav"
			,"recovery"
			,"master/tail" 
		] 
	 ,"hint"  =  "Use this endpoint to revoke all session keys." 
	 	}

	,"compare"= { 
		"hint"  =  "Compare the participant's previous weeks history."
	 ,"model" = [ 
			 "initialize_session_and_current_id"
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
				"initialize_session_and_current_id"
			 ,"show_valid_session" 
			]
		 ,"view"  =  "logout"
		 ,"hint"  =  "An AJAX endpoint to tell me information about where the user is."
			}
		,"eqlog"= { 
			"model" =  [ "initialize_session_and_current_id", "eqlog" ], "view" = "eqlog"
		}
	}
}>
