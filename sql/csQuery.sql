SELECT 
	sm_sessdayid as sid 
 ,sm_datetimestarted as sdate 
FROM 
	ac_mtr_session_metadata	
WHERE 
	sm_dayofweek = :dow
AND 
	sm_dayofmonth  = :dom
AND 
	sm_month = :mon
AND 
	sm_year = :year
AND 
	sm_siteid = :siteid	
