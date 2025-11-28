-- Total allocated hours
-- Calculate the total allocated hours (with multiplication factors) for a teacher, only for the current years’ course instances.  

-- EXPLAIN (ANALYZE)
SELECT
  cl.course_code AS "Course Code",
  ci.instance_id AS "Course Instance ID",
  cl.hp AS "HP",
  ci.study_period AS "Period",
  p.first_name || ' ' || p.last_name AS "Teacher's Name",
  SUM(CASE WHEN ta.activity_name = 'Lecture' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lecture Hours",
  SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Tutorial Hours",
  SUM(CASE WHEN ta.activity_name = 'Lab' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lab Hours",
  SUM(CASE WHEN ta.activity_name = 'Seminar' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Seminar Hours",
  SUM(CASE WHEN ta.activity_name = 'Overhead' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Other Overhead Hours",
  SUM(CASE WHEN ta.activity_name = 'Administration' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Admin",
  SUM(CASE WHEN ta.activity_name = 'Examination' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Exam",
  SUM(pa.planned_nb_hours * ta.factor) AS "Total Hours"
  
FROM
  employee AS e
JOIN person AS p ON e.person_id = p.person_id
JOIN employee_activity AS ea ON e.employment_id = ea.employment_id
JOIN planned_activity AS pa ON ea.planned_activity_id = pa.planned_activity_id
JOIN teaching_activity AS ta ON pa.teaching_activity_id = ta.teaching_activity_id
JOIN course_instance AS ci ON pa.instance_id = ci.instance_id
JOIN course_layout AS cl ON ci.course_layout_id = cl.course_layout_id
WHERE
  p.first_name = 'Filip' AND p.last_name = 'Eriksson'
  AND ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
  
GROUP BY
  cl.course_code, ci.instance_id, cl.hp, ci.study_period, p.first_name, p.last_name
ORDER BY
  cl.course_code, ci.instance_id;

/*
"Course Code"	"Course Instance ID"	"HP"	"Period"	"Teacher's Name"	"Lecture Hours"	"Tutorial Hours"	"Lab Hours"	"Seminar Hours"	"Other Overhead Hours"	"Admin"	"Exam"	"Total Hours"
100	1	7	"P2"	"Filip Eriksson"	0	0	0	0	1	0	0	1
113	17	8	"P2"	"Filip Eriksson"	93.59999752044678	0	0	0	0	0	0	93.59999752044678
*/
