--Planned hours per course instance (8x/day)
CREATE INDEX IF NOT EXISTS idx_planned_activity_instance ON planned_activity (instance_id);
EXPLAIN ANALYZE
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

/*
"QUERY PLAN"
"GroupAggregate  (cost=326.96..327.88 rows=16 width=84) (actual time=1.790..1.815 rows=5.00 loops=1)"
"  Group Key: cl.course_code, ci.instance_id, cl.hp"
"  Buffers: shared hit=25"
"  ->  Sort  (cost=326.96..327.00 rows=16 width=60) (actual time=1.768..1.775 rows=41.00 loops=1)"
"        Sort Key: cl.course_code, ci.instance_id, cl.hp"
"        Sort Method: quicksort  Memory: 27kB"
"        Buffers: shared hit=25"
"        ->  Nested Loop  (cost=44.42..326.64 rows=16 width=60) (actual time=1.511..1.739 rows=41.00 loops=1)"
"              Buffers: shared hit=25"
"              ->  Hash Join  (cost=44.26..290.80 rows=16 width=56) (actual time=1.493..1.692 rows=41.00 loops=1)"
"                    Hash Cond: (pa.instance_id = ci.instance_id)"
"                    Buffers: shared hit=15"
"                    ->  Append  (cost=0.15..202.51 rows=3499 width=56) (actual time=1.274..1.449 rows=140.00 loops=1)"
"                          Buffers: shared hit=14"
"                          ->  Nested Loop  (cost=0.15..8.79 rows=99 width=540) (actual time=1.272..1.351 rows=100.00 loops=1)"
"                                Buffers: shared hit=11"
"                                ->  Seq Scan on planned_activity pa  (cost=0.00..2.00 rows=100 width=16) (actual time=0.013..0.021 rows=100.00 loops=1)"
"                                      Buffers: shared hit=1"
"                                ->  Memoize  (cost=0.15..0.66 rows=1 width=524) (actual time=0.013..0.013 rows=1.00 loops=100)"
"                                      Cache Key: pa.teaching_activity_id"
"                                      Cache Mode: logical"
"                                      Hits: 95  Misses: 5  Evictions: 0  Overflows: 0  Memory Usage: 1kB"
"                                      Buffers: shared hit=10"
"                                      ->  Index Scan using teaching_activity_pkey on teaching_activity ta  (cost=0.14..0.65 rows=1 width=524) (actual time=0.251..0.251 rows=1.00 loops=5)"
"                                            Index Cond: (teaching_activity_id = pa.teaching_activity_id)"
"                                            Filter: ((activity_name)::text <> ALL ('{Examination,Administration}'::text[]))"
"                                            Index Searches: 5"
"                                            Buffers: shared hit=10"
"                          ->  Subquery Scan on ""*SELECT* 2""  (cost=0.00..61.00 rows=1700 width=56) (actual time=0.018..0.035 rows=20.00 loops=1)"
"                                Buffers: shared hit=1"
"                                ->  Seq Scan on course_instance ci_1  (cost=0.00..39.75 rows=1700 width=80) (actual time=0.008..0.016 rows=20.00 loops=1)"
"                                      Buffers: shared hit=1"
"                          ->  Subquery Scan on ""*SELECT* 3""  (cost=37.00..115.22 rows=1700 width=56) (actual time=0.026..0.047 rows=20.00 loops=1)"
"                                Buffers: shared hit=2"
"                                ->  Hash Join  (cost=37.00..93.97 rows=1700 width=80) (actual time=0.024..0.038 rows=20.00 loops=1)"
"                                      Hash Cond: (ci_2.course_layout_id = cl_1.course_layout_id)"
"                                      Buffers: shared hit=2"
"                                      ->  Seq Scan on course_instance ci_2  (cost=0.00..27.00 rows=1700 width=12) (actual time=0.003..0.004 rows=20.00 loops=1)"
"                                            Buffers: shared hit=1"
"                                      ->  Hash  (cost=22.00..22.00 rows=1200 width=8) (actual time=0.014..0.015 rows=23.00 loops=1)"
"                                            Buckets: 2048  Batches: 1  Memory Usage: 17kB"
"                                            Buffers: shared hit=1"
"                                            ->  Seq Scan on course_layout cl_1  (cost=0.00..22.00 rows=1200 width=8) (actual time=0.005..0.009 rows=23.00 loops=1)"
"                                                  Buffers: shared hit=1"
"                    ->  Hash  (cost=44.00..44.00 rows=8 width=16) (actual time=0.035..0.035 rows=5.00 loops=1)"
"                          Buckets: 1024  Batches: 1  Memory Usage: 9kB"
"                          Buffers: shared hit=1"
"                          ->  Seq Scan on course_instance ci  (cost=0.00..44.00 rows=8 width=16) (actual time=0.022..0.030 rows=5.00 loops=1)"
"                                Filter: ((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE))"
"                                Rows Removed by Filter: 15"
"                                Buffers: shared hit=1"
"              ->  Memoize  (cost=0.16..4.18 rows=1 width=12) (actual time=0.001..0.001 rows=1.00 loops=41)"
"                    Cache Key: ci.course_layout_id"
"                    Cache Mode: logical"
"                    Hits: 36  Misses: 5  Evictions: 0  Overflows: 0  Memory Usage: 1kB"
"                    Buffers: shared hit=10"
"                    ->  Index Scan using course_layout_pkey on course_layout cl  (cost=0.15..4.17 rows=1 width=12) (actual time=0.003..0.003 rows=1.00 loops=5)"
"                          Index Cond: (course_layout_id = ci.course_layout_id)"
"                          Index Searches: 5"
"                          Buffers: shared hit=10"
"Planning:"
"  Buffers: shared hit=8"
"Planning Time: 0.741 ms"
"Execution Time: 1.945 ms"
*/
