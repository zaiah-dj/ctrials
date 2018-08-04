/*patient data*/
SELECT * FROM
(
	SELECT * FROM
		( SELECT * FROM 
			#data.data.bloodpressure# 
		WHERE 
			bp_pid = :pid ) as bpp 
		RIGHT JOIN
		( SELECT 
			participantGUID as _pid	
		 ,weight
		 ,#iif(isEnd,DE('trgthr1'),DE('0'))# as targetHR
		FROM 
			#iif(isEnd,DE('#data.data.endurance#'),DE('#data.data.resistance#'))# 
		WHERE 
			participantGUID = :pid ) as frmVal
	ON bpp.bp_pid = frmVal._pid
) AS SingleData

LEFT JOIN

(
SELECT * FROM
	(
		SELECT
			noteDate
		 ,noteText	
		 ,insertedby
		 ,participantGUID as nPid
		FROM 
			#data.data.notes#	
		WHERE participantGUID = :pid
	) AS Notes
	RIGHT JOIN
	(
		SELECT 	
			dayofwk 
		 ,participantGUID as ppid		
		FROM 
			#iif(isEnd,DE('#data.data.endurance#'),DE('#data.data.resistance#'))# 
		WHERE participantGUID = :pid 
		AND stdywk = :wk
	) As Meg
	ON Notes.nPid = Meg.ppid
) As Mult

ON Mult.nPid = SingleData._pid
