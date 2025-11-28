SELECT
    cl.course_code AS "Course Code",
    ci.instance_id AS "Course Instance ID",
    cl.hp AS "HP",
    ci.study_period AS "Period",
    ci.num_students AS "# Students",
    SUM(CASE WHEN v.activity_name = 'Lecture' THEN v.total_teachers_hours ELSE 0 END) AS "Lecture Hours",
    SUM(CASE WHEN v.activity_name = 'Tutorial' THEN v.total_teachers_hours ELSE 0 END) AS "Tutorial Hours",
    SUM(CASE WHEN v.activity_name = 'Lab' THEN v.total_teachers_hours ELSE 0 END) AS "Lab Hours",
    SUM(CASE WHEN v.activity_name = 'Seminar' THEN v.total_teachers_hours ELSE 0 END) AS "Seminar Hours",
    SUM(CASE WHEN v.activity_name = 'Overhead' THEN v.total_teachers_hours ELSE 0 END) AS "Other Overhead Hours",
    SUM(CASE WHEN v.activity_name = 'Administration' THEN v.total_teachers_hours ELSE 0 END) AS "Administration Hours",
    SUM(CASE WHEN v.activity_name = 'Examination' THEN v.total_teachers_hours ELSE 0 END) AS "Examination Hours",
    SUM(v.total_teachers_hours) AS "Total Hours"
FROM course_instance ci
JOIN course_layout cl ON ci.course_layout_id = cl.course_layout_id
JOIN v_full_course_workload v ON ci.instance_id = v.instance_id
WHERE ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY
    cl.course_code, ci.instance_id, cl.hp, ci.study_period, ci.num_students
ORDER BY
    cl.course_code, ci.instance_id;
