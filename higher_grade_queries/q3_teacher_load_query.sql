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

/*
"QUERY PLAN"
"Incremental Sort  (cost=51.74..51.79 rows=2 width=65) (actual time=2.769..2.781 rows=1.00 loops=1)"
"  Sort Key: ci.study_year, ((((p.first_name)::text || ' '::text) || (p.last_name)::text))"
"  Presorted Key: ci.study_year"
"  Full-sort Groups: 1  Sort Method: quicksort  Average Memory: 25kB  Peak Memory: 25kB"
"  Buffers: shared hit=1076"
"  ->  GroupAggregate  (cost=51.71..51.73 rows=1 width=65) (actual time=2.441..2.453 rows=1.00 loops=1)"
"        Group Key: ci.study_year, e.employment_id"
"        Buffers: shared hit=1076"
"        ->  Sort  (cost=51.71..51.71 rows=1 width=33) (actual time=2.421..2.434 rows=20.00 loops=1)"
"              Sort Key: ci.study_year, e.employment_id"
"              Sort Method: quicksort  Memory: 26kB"
"              Buffers: shared hit=1076"
"              ->  Nested Loop  (cost=45.26..51.70 rows=1 width=33) (actual time=1.844..2.410 rows=20.00 loops=1)"
"                    Buffers: shared hit=1076"
"                    ->  Nested Loop  (cost=45.11..50.63 rows=5 width=24) (actual time=1.607..2.016 rows=248.00 loops=1)"
"                          Buffers: shared hit=580"
"                          ->  Hash Join  (cost=44.95..47.38 rows=5 width=20) (actual time=1.447..1.529 rows=248.00 loops=1)"
"                                Hash Cond: (ea.planned_activity_id = pa.planned_activity_id)"
"                                Buffers: shared hit=84"
"                                ->  Seq Scan on employee_activity ea  (cost=0.00..2.00 rows=100 width=8) (actual time=0.032..0.040 rows=100.00 loops=1)"
"                                      Buffers: shared hit=1"
"                                ->  Hash  (cost=44.89..44.89 rows=5 width=20) (actual time=1.396..1.406 rows=248.00 loops=1)"
"                                      Buckets: 1024  Batches: 1  Memory Usage: 22kB"
"                                      Buffers: shared hit=83"
"                                      ->  Nested Loop  (cost=1.76..44.89 rows=5 width=20) (actual time=0.403..1.101 rows=248.00 loops=1)"
"                                            Join Filter: (pa.instance_id = ci.instance_id)"
"                                            Buffers: shared hit=83"
"                                            ->  Hash Join  (cost=1.62..44.51 rows=1 width=24) (actual time=0.079..0.606 rows=34.00 loops=1)"
"                                                  Hash Cond: (pa_1.instance_id = ci.instance_id)"
"                                                  Buffers: shared hit=15"
"                                                  ->  Append  (cost=0.15..41.28 rows=139 width=56) (actual time=0.048..0.544 rows=140.00 loops=1)"
"                                                        Buffers: shared hit=14"
"                                                        ->  Nested Loop  (cost=0.15..8.79 rows=99 width=540) (actual time=0.046..0.149 rows=100.00 loops=1)"
"                                                              Buffers: shared hit=11"
"                                                              ->  Seq Scan on planned_activity pa_1  (cost=0.00..2.00 rows=100 width=16) (actual time=0.009..0.018 rows=100.00 loops=1)"
"                                                                    Buffers: shared hit=1"
"                                                              ->  Memoize  (cost=0.15..0.66 rows=1 width=524) (actual time=0.001..0.001 rows=1.00 loops=100)"
"                                                                    Cache Key: pa_1.teaching_activity_id"
"                                                                    Cache Mode: logical"
"                                                                    Hits: 95  Misses: 5  Evictions: 0  Overflows: 0  Memory Usage: 1kB"
"                                                                    Buffers: shared hit=10"
"                                                                    ->  Index Scan using teaching_activity_pkey on teaching_activity ta  (cost=0.14..0.65 rows=1 width=524) (actual time=0.007..0.007 rows=1.00 loops=5)"
"                                                                          Index Cond: (teaching_activity_id = pa_1.teaching_activity_id)"
"                                                                          Filter: ((activity_name)::text <> ALL ('{Examination,Administration}'::text[]))"
"                                                                          Index Searches: 5"
"                                                                          Buffers: shared hit=10"
"                                                        ->  Subquery Scan on ""*SELECT* 2""  (cost=0.00..1.60 rows=20 width=56) (actual time=0.030..0.051 rows=20.00 loops=1)"
"                                                              Buffers: shared hit=1"
"                                                              ->  Seq Scan on course_instance ci_1  (cost=0.00..1.35 rows=20 width=80) (actual time=0.020..0.031 rows=20.00 loops=1)"
"                                                                    Buffers: shared hit=1"
"                                                        ->  Subquery Scan on ""*SELECT* 3""  (cost=1.45..30.20 rows=20 width=56) (actual time=0.302..0.325 rows=20.00 loops=1)"
"                                                              Buffers: shared hit=2"
"                                                              ->  Hash Join  (cost=1.45..29.95 rows=20 width=80) (actual time=0.297..0.313 rows=20.00 loops=1)"
"                                                                    Hash Cond: (cl.course_layout_id = ci_2.course_layout_id)"
"                                                                    Buffers: shared hit=2"
"                                                                    ->  Seq Scan on course_layout cl  (cost=0.00..22.00 rows=1200 width=8) (actual time=0.008..0.011 rows=23.00 loops=1)"
"                                                                          Buffers: shared hit=1"
"                                                                    ->  Hash  (cost=1.20..1.20 rows=20 width=12) (actual time=0.175..0.177 rows=20.00 loops=1)"
"                                                                          Buckets: 1024  Batches: 1  Memory Usage: 9kB"
"                                                                          Buffers: shared hit=1"
"                                                                          ->  Seq Scan on course_instance ci_2  (cost=0.00..1.20 rows=20 width=12) (actual time=0.014..0.017 rows=20.00 loops=1)"
"                                                                                Buffers: shared hit=1"
"                                                  ->  Hash  (cost=1.45..1.45 rows=1 width=12) (actual time=0.021..0.021 rows=4.00 loops=1)"
"                                                        Buckets: 1024  Batches: 1  Memory Usage: 9kB"
"                                                        Buffers: shared hit=1"
"                                                        ->  Seq Scan on course_instance ci  (cost=0.00..1.45 rows=1 width=12) (actual time=0.011..0.016 rows=4.00 loops=1)"
"                                                              Filter: ((study_period = 'P2'::study_period) AND ((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE)))"
"                                                              Rows Removed by Filter: 16"
"                                                              Buffers: shared hit=1"
"                                            ->  Index Scan using idx_planned_activity_instance on planned_activity pa  (cost=0.14..0.32 rows=5 width=8) (actual time=0.011..0.012 rows=7.29 loops=34)"
"                                                  Index Cond: (instance_id = pa_1.instance_id)"
"                                                  Index Searches: 34"
"                                                  Buffers: shared hit=68"
"                          ->  Index Scan using employee_pkey on employee e  (cost=0.15..0.65 rows=1 width=8) (actual time=0.002..0.002 rows=1.00 loops=248)"
"                                Index Cond: (employment_id = ea.employment_id)"
"                                Index Searches: 248"
"                                Buffers: shared hit=496"
"                    ->  Index Scan using person_pkey on person p  (cost=0.15..0.20 rows=1 width=17) (actual time=0.001..0.001 rows=0.08 loops=248)"
"                          Index Cond: (person_id = e.person_id)"
"                          Filter: (((first_name)::text = 'Filip'::text) AND ((last_name)::text = 'Eriksson'::text))"
"                          Rows Removed by Filter: 1"
"                          Index Searches: 248"
"                          Buffers: shared hit=496"
"Planning:"
"  Buffers: shared hit=43 dirtied=2"
"Planning Time: 2.279 ms"
"Execution Time: 2.948 ms"
*/
