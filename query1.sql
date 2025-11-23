-- Planned hours calculations: 
-- Calculate the total hours (with the multiplication factor) along with the break-ups for each activity, for the current years’ course instances. 

-- EXPLAIN (ANALYZE)
SELECT
	cl.course_code AS "Course code",
	ci.instance_id AS "Course instance ID",
	cl.hp AS "HP",
	ci.study_period AS "Study period",
	ci.num_students AS "Number of students",
	SUM(CASE WHEN fcw.activity_name = 'Lecture' THEN fcw.total_teachers_hours ELSE 0 END) AS "Lectures",
	SUM(CASE WHEN fcw.activity_name = 'Tutorial' THEN fcw.total_teachers_hours ELSE 0 END) AS "Tutorial Hours",
	SUM(CASE WHEN fcw.activity_name = 'Seminar' THEN fcw.total_teachers_hours ELSE 0 END) AS "Seminar Hours",
	SUM(CASE WHEN fcw.activity_name = 'Overhead' THEN fcw.total_teachers_hours ELSE 0 END) AS "Other Overhead Hours",
	SUM(CASE WHEN fcw.activity_name = 'Administration' THEN fcw.total_teachers_hours ELSE 0 END) AS "Administration Hours",
	SUM(CASE WHEN fcw.activity_name = 'Examination' THEN fcw.total_teachers_hours ELSE 0 END) AS "Examination Hours",
	SUM(fcw.total_teachers_hours) AS "Total Hours"

FROM v_full_course_workload AS fcw
JOIN course_instance AS ci ON fcw.instance_id = ci.instance_id
JOIN course_layout AS cl ON cl.course_layout_id = ci.course_layout_id

WHERE ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY
	cl.course_code,
	ci.instance_id,
	cl.hp,
	ci.study_period,
	ci.num_students

