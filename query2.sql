-- Calculate actual allocated hours for a course: 
--Calculate the total allocated hours with the multiplication factor along with the break-ups 
--for each activity and for each teacher, for a current years’ course instance. 



-- counting the number of techers doing specific course to then allocate equal
-- amount of admin and exam hours of the course to each teacher
WITH teacher_counts AS (
    SELECT pa.instance_id, 
        COUNT(DISTINCT ea.employment_id) AS total_teachers
    FROM planned_activity pa
    JOIN employee_activity ea ON pa.planned_activity_id = ea.planned_activity_id
    GROUP BY pa.instance_id
)


SELECT
	cl.course_code AS "Course code",
	ci.instance_id AS "Course instance ID",
	cl.hp AS "HP",
	p.first_name || ' ' || p.last_name AS "Teacher's Name",
	jt.job_title as "Designation",
	SUM(CASE WHEN ta.activity_name = 'Lecture' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lecture Hours",
  	SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Tutorial Hours",
  	SUM(CASE WHEN ta.activity_name = 'Lab' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lab Hours",
  	SUM(CASE WHEN ta.activity_name = 'Seminar' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Seminar Hours",
 	SUM(CASE WHEN ta.activity_name = 'Overhead' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Other Overhead Hours",
  	MAX(2 * cl.hp + 28 + 0.2 * ci.num_students) / tc.total_teachers AS "Admin ",
    MAX(32 + 0.725 * ci.num_students) / tc.total_teachers AS "Exam ",
    
    ( SUM(pa.planned_nb_hours * ta.factor) + 
      (MAX(2 * cl.hp + 28 + 0.2 * ci.num_students) / tc.total_teachers) + 
      (MAX(32 + 0.725 * ci.num_students) / tc.total_teachers)
    ) AS "Total Hours"
FROM
  course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.course_layout_id
JOIN planned_activity AS pa ON ci.instance_id = pa.instance_id
JOIN teaching_activity AS ta ON pa.teaching_activity_id = ta.teaching_activity_id
JOIN employee_activity AS ea ON pa.planned_activity_id = ea.planned_activity_id 
JOIN employee AS e ON ea.employment_id = e.employment_id 
JOIN job_title AS jt ON  e.job_id = jt.job_id 
JOIN person AS p ON  e.person_id = p.person_id 
JOIN teacher_counts AS tc ON ci.instance_id = tc.instance_id
WHERE
  ci.instance_id = 1
  AND ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
  
GROUP BY
  cl.course_code, ci.instance_id, cl.hp, p.first_name, p.last_name, jt.job_title, tc.total_teachers;

Course code	Course instance ID	HP	Teacher's Name	Designation	Lecture Hours		Tutorial Hours		Lab Hours		Seminar Hours		Other Overhead Hours	Admin			Exam			Total Hours
103		1			10	Anna Andersson	Lab Assistant	0.0			0.0			24.000000953674316	0.0			0.0			13.2500000000000000	12.5312500000000000	49.781250953674316
103		1			10	Filip Eriksson	Administrator	0.0			0.0			0.0			37.79999899864197	0.0			13.2500000000000000	12.5312500000000000	63.58124899864197
103		1			10	Jonas Johansson	Lab Assistant	53.999998569488525	0.0			0.0			0.0			0.0			13.2500000000000000	12.5312500000000000	79.78124856948853
103		1			10	Sven Lund	Technical Staff	0.0			48.59999871253967	0.0			0.0			0.0			13.2500000000000000	12.5312500000000000	74.38124871253967
