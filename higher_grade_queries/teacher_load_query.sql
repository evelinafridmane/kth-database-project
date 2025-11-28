CREATE INDEX IF NOT EXISTS idx_course_instance_year_period ON course_instance (study_year, study_period);

SELECT
    e.employment_id AS "Employment ID",
    p.first_name || ' ' || p.last_name AS "Teacher's Name",
    ci.study_period AS "Period",
    ci.study_year AS "Year",
    SUM(v.total_teachers_hours) AS "Total Hours"
  
FROM employee AS e
JOIN person AS p ON e.person_id = p.person_id
JOIN employee_activity AS ea ON e.employment_id = ea.employment_id
JOIN planned_activity AS pa ON ea.planned_activity_id = pa.planned_activity_id
JOIN course_instance AS ci ON pa.instance_id = ci.instance_id
JOIN v_full_course_workload AS v ON ci.instance_id = v.instance_id

WHERE
      p.first_name = 'Filip'        -- argumen
  AND p.last_name  = 'Eriksson'     -- argument
  AND ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
  AND ci.study_period = 'P2'  -- argument
  
GROUP BY
    e.employment_id,
    p.first_name,
    p.last_name,
    ci.study_period,
    ci.study_year
  
ORDER BY
    ci.study_year,
    ci.study_period,
    "Teacher's Name";
