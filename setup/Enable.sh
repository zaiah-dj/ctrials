#!/bin/bash -
# A shell script to enable (or disable) participants on the command line
# Run SQL Server commands from here 
function sqcmd() {
	#echo sqlcmd -Q "$1" -U SA -P 'GKbAt68!'
	sqlcmd -Q "$1" -U SA -P 'GKbAt68!'
}

# Do some crude binding to allow for dynamic queries
function sqwrp() {
	echo "$1" | sed "s/:$2/$3/g"
}

# SQL code can go here in heredocs

# Get all participant data
sqlSelectAll=$(cat << 'GET_SQL'
USE localmotrpac;
SELECT * FROM v_ADUSessionTickler;
GO
GET_SQL
)

# Get participant data for one person
sqlGetOneParticipant=$(cat << 'GET_SQL'
USE localmotrpac;
SELECT * FROM v_ADUSessionTickler WHERE p_id = :pid;
GO
GET_SQL
)

# Get participant GUID for one person
sqlGetOneParticipantGUID=$(cat << 'GET_SQL'
USE localmotrpac;
SELECT participantGUID FROM v_ADUSessionTickler WHERE p_id = :pid;
GO
GET_SQL
)

# Update participant data for one person
sqlUpdateParticipantDOV=$(cat << 'GET_SQL'
USE localmotrpac;
UPDATE frm_RETL SET dateOfVisit = :dtOfvisit WHERE participantGUID = :pid
GO
GET_SQL
)
# A usage function
usage()
{
	STATUS=${2:-0}

#-t, --test              Test out data.json with parameters.
#  --maintenance       Put a site in maintenance mode.
	cat <<USAGES
$0:
-i \$1	  - Get info about a partiicpnat by numeric ID (or name)
-e \$1  	- Enable a participant for today
-d \$1  	- Disable a participant for today
-t \$1    - Are they RE or EE?
USAGES

	exit $STATUS
}



# Catch blank arguments
[ $# -eq 0 ] && usage 0 


# ...
GET_INFO=0
ENABLE=0
DISABLE=0
while [ $# -gt 0 ]
do
	case "$1" in
		-i)
			GET_INFO=1
			shift
			PARTICIPANT_ID="$1"	
		;;

		-e)
			ENABLE=1
			shift
			PARTICIPANT_ID="$1"	
		;;

		-d)
			DISABLE=1
			shift
			PARTICIPANT_ID="$1"	
		;;

		-t)
			shift
			PARTICIPANT_TYPE="$1"	
		;;

		--help)	
			usage 0
		;;

		--)	break
		;;

		-*)	printf "$PROGRAM_NAME: Unknown argument received: $1\n" > /dev/stderr; usage 1
		;;
	esac
shift
done



# Initialize Participant
# ...
if [ $GET_INFO -eq 1 ]
then
	sqcmd "$(sqwrp "$sqlGetOneParticipant" pid 2)"
fi


# Enable a participant for the day
if [ $ENABLE -eq 1 ]
then
	# Get GUID
	sqcmd "$(sqwrp "$sqlGetOneParticipantGUID" pid 2)"
exit
	# Then enable the guy
	CMD="$(sqwrp "$sqlGetOneParticipant" dtOfVisit $(date +%F) )"
	CMD="$(sqwrp "$CMD" pid 2)"
	echo $CMD 
fi


# Disable a partiicpant for the day 
if [ $DISABLE -eq 1 ]
then
	sqcmd "$(sqwrp "$sqlGetOneParticipant" pid 2)"
fi
