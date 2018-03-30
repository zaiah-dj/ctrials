UPDATE ac_mtr_exercise_log_ee 
SET 
	el_ee_equipment = :eq,
	el_ee_timeblock = :tb,
	el_ee_rpm = :rpm,
	el_ee_watts_resistance = :wr,
	el_ee_speed = :speed,
	el_ee_grade = :grade,
	el_ee_perceived_exertion = :pe,
	el_ee_datetime = :dt
WHERE
	el_ee_ex_session_id = :sid 
AND
	el_ee_pid = :pid
