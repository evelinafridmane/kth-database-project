-- use a matview instad:
CREATE MATERIALIZED VIEW mv_teacher_course_counts AS
SELECT 
    e.employment_id,
    p.first_name || ' ' || p.last_name AS teacher_name,
    ci.study_period,
    ci.study_year,
    COUNT(DISTINCT ci.instance_id) AS course_count
FROM employee e
  JOIN person p ON e.person_id = p.person_id
  JOIN employee_activity ea ON e.employment_id = ea.employment_id
  JOIN planned_activity pa ON ea.planned_activity_id = pa.planned_activity_id
  JOIN course_instance ci ON pa.instance_id = ci.instance_id
GROUP BY e.employment_id, p.first_name, p.last_name, ci.study_period, ci.study_year;

CREATE INDEX idx_mv_teacher_counts_period_year ON mv_teacher_course_counts (study_year, study_period);--faster filter

--teachers allocated to more than N courses in current period
SELECT 
    employment_id,
    teacher_name,
    course_count
FROM mv_teacher_course_counts
WHERE study_year = EXTRACT(YEAR FROM CURRENT_DATE)
  AND study_period = (
      CASE 
          WHEN EXTRACT(MONTH FROM CURRENT_DATE) < 3 THEN 'P1'
          WHEN EXTRACT(MONTH FROM CURRENT_DATE) <= 6 THEN 'P2' 
          WHEN EXTRACT(MONTH FROM CURRENT_DATE) <= 10 THEN 'P3'
          ELSE 'P4'
      END
  )
  AND course_count > 1 --argument
ORDER BY course_count DESC;

/*"Sort  (cost=5.16..5.16 rows=1 width=25) (actual time=0.025..0.025 rows=0.00 loops=1)"
"  Sort Key: course_count DESC"
"  Sort Method: quicksort  Memory: 25kB"
"  Buffers: shared hit=1"
"  ->  Seq Scan on mv_teacher_course_counts  (cost=0.00..5.15 rows=1 width=25) (actual time=0.021..0.021 rows=0.00 loops=1)"
"        Filter: ((course_count > 1) AND ((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE)) AND (study_period = (CASE WHEN (EXTRACT(month FROM CURRENT_DATE) < '3'::numeric) THEN 'P1'::text WHEN (EXTRACT(month FROM CURRENT_DATE) <= '6'::numeric) THEN 'P2'::text WHEN (EXTRACT(month FROM CURRENT_DATE) <= '10'::numeric) THEN 'P3'::text ELSE 'P4'::text END)::study_period))"
"        Rows Removed by Filter: 79"
"        Buffers: shared hit=1"
"Planning Time: 0.118 ms"
"Execution Time: 0.041 ms"
*/
