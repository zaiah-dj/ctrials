SELECT TOP(15)
	noteDate
 ,noteText	
 ,insertedby
FROM 
	ParticipantNotes	
WHERE 
	participantGUID = :pid
AND
	noteDate > :dateLimit
ORDER BY 
	noteDate DESC
