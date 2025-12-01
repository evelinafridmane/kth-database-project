
CREATE MATERIALIZED VIEW mv_teacher_allocated_hours AS
WITH teacher_counts AS (
    SELECT pa.instance_id,
           COUNT(DISTINCT ea.employment_id) AS total_teachers
    FROM planned_activity pa
    JOIN employee_activity ea ON pa.planned_activity_id = ea.planned_activity_id
    GROUP BY pa.instance_id
)
SELECT
    cl.course_code,
    ci.instance_id,
    ci.study_year, 
    cl.hp,
    p.first_name || ' ' || p.last_name AS teacher_name,
    jt.job_title,

    SUM(CASE WHEN ta.activity_name = 'Lecture' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS lecture_hours,
    SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS tutorial_hours,
    SUM(CASE WHEN ta.activity_name = 'Lab' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS lab_hours,
    SUM(CASE WHEN ta.activity_name = 'Seminar' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS seminar_hours,
    SUM(CASE WHEN ta.activity_name = 'Overhead' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS overhead_hours,
    
    MAX(2 * cl.hp + 28 + 0.2 * ci.num_students) / tc.total_teachers AS admin_hours,
    MAX(32 + 0.725 * ci.num_students) / tc.total_teachers AS exam_hours,
    
    ( SUM(pa.planned_nb_hours * ta.factor) +
      (MAX(2 * cl.hp + 28 + 0.2 * ci.num_students) / tc.total_teachers) +
      (MAX(32 + 0.725 * ci.num_students) / tc.total_teachers)
    ) AS total_hours
    
FROM 
course_instance ci
JOIN course_layout cl ON ci.course_layout_id = cl.course_layout_id
JOIN planned_activity pa ON ci.instance_id = pa.instance_id
JOIN teaching_activity ta ON pa.teaching_activity_id = ta.teaching_activity_id
JOIN employee_activity ea ON pa.planned_activity_id = ea.planned_activity_id
JOIN employee e ON ea.employment_id = e.employment_id
JOIN job_title jt ON e.job_id = jt.job_id
JOIN person p ON e.person_id = p.person_id
JOIN teacher_counts tc ON ci.instance_id = tc.instance_id

GROUP BY cl.course_code, ci.instance_id, ci.study_year, cl.hp, p.first_name, p.last_name, jt.job_title, tc.total_teachers;


CREATE INDEX idx_mv_allocated_year_instance ON mv_teacher_allocated_hours(study_year, instance_id);


SELECT *
FROM mv_teacher_allocated_hours
WHERE instance_id = 1
  AND study_year = EXTRACT(YEAR FROM CURRENT_DATE);
/*
Seq Scan on mv_teacher_allocated_hours  (cost=0.00..3.82 rows=1 width=102) (actual time=0.055..0.079 rows=8.00 loops=1)
  Filter: ((instance_id = 1) AND ((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE)))
  Rows Removed by Filter: 73
  Buffers: shared hit=2
Planning:
  Buffers: shared hit=95 dirtied=2
Planning Time: 2.416 ms
Execution Time: 0.121 ms
*/
