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

/*
"Course code"	"Course instance ID"	"HP"	"Study period"	"Number of students"	"Lectures"	"Tutorial Hours"	"Seminar Hours"	"Other Overhead Hours"	"Administration Hours"	"Examination Hours"	"Total Hours"
102	9	9	"P1"	20	64.79999828338623	0	0	0	50	46.5	161.29999828338623
103	1	10	"P1"	25	0	0	0	0	53	50.125	127.12500095367432
105	13	8	"P1"	25	0	0	39.59999895095825	0	49	50.125	138.72499895095825
107	5	10	"P1"	25	0	0	0	0	53	50.125	136.72500133514404
117	17	8	"P1"	15	0	46.79999876022339	0	0	47	42.875	136.6749987602234
*/
