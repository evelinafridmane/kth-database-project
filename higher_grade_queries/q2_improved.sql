
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
GroupAggregate  (cost=93.01..93.17 rows=1 width=1716) (actual time=1.344..1.897 rows=81.00 loops=1)
  Group Key: cl.course_code, ci.instance_id, cl.hp, p.first_name, p.last_name, jt.job_title, tc.total_teachers
  Buffers: shared hit=97
  ->  Sort  (cost=93.01..93.02 rows=1 width=2100) (actual time=1.298..1.331 rows=100.00 loops=1)
        Sort Key: cl.course_code, ci.instance_id, cl.hp, p.first_name, p.last_name, jt.job_title, tc.total_teachers
        Sort Method: quicksort  Memory: 34kB
        Buffers: shared hit=97
        ->  Hash Join  (cost=51.85..93.00 rows=1 width=2100) (actual time=0.411..1.174 rows=100.00 loops=1)
              Hash Cond: (ci.instance_id = tc.instance_id)
              Buffers: shared hit=97
              ->  Hash Join  (cost=41.61..82.49 rows=100 width=2096) (actual time=0.212..0.923 rows=100.00 loops=1)
                    Hash Cond: (e.person_id = p.person_id)
                    Buffers: shared hit=95
                    ->  Hash Join  (cost=30.03..70.66 rows=100 width=1068) (actual time=0.182..0.842 rows=100.00 loops=1)
                          Hash Cond: (e.job_id = jt.job_id)
                          Buffers: shared hit=94
                          ->  Nested Loop  (cost=16.88..57.24 rows=100 width=556) (actual time=0.158..0.768 rows=100.00 loops=1)
                                Buffers: shared hit=93
                                ->  Nested Loop  (cost=16.72..41.23 rows=100 width=552) (actual time=0.145..0.618 rows=100.00 loops=1)
                                      Buffers: shared hit=53
                                      ->  Hash Join  (cost=16.56..34.95 rows=100 width=36) (actual time=0.130..0.404 rows=100.00 loops=1)
                                            Hash Cond: (ci.course_layout_id = cl.course_layout_id)
                                            Buffers: shared hit=43
                                            ->  Nested Loop  (cost=3.41..21.54 rows=100 width=32) (actual time=0.082..0.309 rows=100.00 loops=1)
                                                  Buffers: shared hit=42
                                                  ->  Hash Join  (cost=3.25..5.52 rows=100 width=16) (actual time=0.059..0.154 rows=100.00 loops=1)
                                                        Hash Cond: (ea.planned_activity_id = pa.planned_activity_id)
                                                        Buffers: shared hit=2
                                                        ->  Seq Scan on employee_activity ea  (cost=0.00..2.00 rows=100 width=8) (actual time=0.004..0.022 rows=100.00 loops=1)
                                                              Buffers: shared hit=1
                                                        ->  Hash  (cost=2.00..2.00 rows=100 width=16) (actual time=0.043..0.044 rows=100.00 loops=1)
                                                              Buckets: 1024  Batches: 1  Memory Usage: 13kB
                                                              Buffers: shared hit=1
                                                              ->  Seq Scan on planned_activity pa  (cost=0.00..2.00 rows=100 width=16) (actual time=0.005..0.021 rows=100.00 loops=1)
                                                                    Buffers: shared hit=1
                                                  ->  Memoize  (cost=0.16..0.66 rows=1 width=16) (actual time=0.001..0.001 rows=1.00 loops=100)
                                                        Cache Key: pa.instance_id
                                                        Cache Mode: logical
                                                        Hits: 80  Misses: 20  Evictions: 0  Overflows: 0  Memory Usage: 3kB
                                                        Buffers: shared hit=40
                                                        ->  Index Scan using course_instance_pkey on course_instance ci  (cost=0.15..0.65 rows=1 width=16) (actual time=0.002..0.002 rows=1.00 loops=20)
                                                              Index Cond: (instance_id = pa.instance_id)
                                                              Index Searches: 20
                                                              Buffers: shared hit=40
                                            ->  Hash  (cost=11.40..11.40 rows=140 width=12) (actual time=0.030..0.031 rows=23.00 loops=1)
                                                  Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                  Buffers: shared hit=1
                                                  ->  Seq Scan on course_layout cl  (cost=0.00..11.40 rows=140 width=12) (actual time=0.006..0.010 rows=23.00 loops=1)
                                                        Buffers: shared hit=1
                                      ->  Memoize  (cost=0.15..0.65 rows=1 width=524) (actual time=0.001..0.001 rows=1.00 loops=100)
                                            Cache Key: pa.teaching_activity_id
                                            Cache Mode: logical
                                            Hits: 95  Misses: 5  Evictions: 0  Overflows: 0  Memory Usage: 1kB
                                            Buffers: shared hit=10
                                            ->  Index Scan using teaching_activity_pkey on teaching_activity ta  (cost=0.14..0.64 rows=1 width=524) (actual time=0.005..0.005 rows=1.00 loops=5)
                                                  Index Cond: (teaching_activity_id = pa.teaching_activity_id)
                                                  Index Searches: 5
                                                  Buffers: shared hit=10
                                ->  Memoize  (cost=0.16..0.66 rows=1 width=12) (actual time=0.001..0.001 rows=1.00 loops=100)
                                      Cache Key: ea.employment_id
                                      Cache Mode: logical
                                      Hits: 80  Misses: 20  Evictions: 0  Overflows: 0  Memory Usage: 3kB
                                      Buffers: shared hit=40
                                      ->  Index Scan using employee_pkey on employee e  (cost=0.15..0.65 rows=1 width=12) (actual time=0.002..0.002 rows=1.00 loops=20)
                                            Index Cond: (employment_id = ea.employment_id)
                                            Index Searches: 20
                                            Buffers: shared hit=40
                          ->  Hash  (cost=11.40..11.40 rows=140 width=520) (actual time=0.010..0.011 rows=10.00 loops=1)
                                Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                Buffers: shared hit=1
                                ->  Seq Scan on job_title jt  (cost=0.00..11.40 rows=140 width=520) (actual time=0.005..0.007 rows=10.00 loops=1)
                                      Buffers: shared hit=1
                    ->  Hash  (cost=10.70..10.70 rows=70 width=1036) (actual time=0.018..0.018 rows=20.00 loops=1)
                          Buckets: 1024  Batches: 1  Memory Usage: 9kB
                          Buffers: shared hit=1
                          ->  Seq Scan on person p  (cost=0.00..10.70 rows=70 width=1036) (actual time=0.007..0.011 rows=20.00 loops=1)
                                Buffers: shared hit=1
              ->  Hash  (cost=10.00..10.00 rows=20 width=12) (actual time=0.193..0.196 rows=20.00 loops=1)
                    Buckets: 1024  Batches: 1  Memory Usage: 9kB
                    Buffers: shared hit=2
                    ->  Subquery Scan on tc  (cost=8.85..10.00 rows=20 width=12) (actual time=0.153..0.190 rows=20.00 loops=1)
                          Buffers: shared hit=2
                          ->  GroupAggregate  (cost=8.85..9.80 rows=20 width=12) (actual time=0.152..0.185 rows=20.00 loops=1)
                                Group Key: pa_1.instance_id
                                Buffers: shared hit=2
                                ->  Sort  (cost=8.85..9.10 rows=100 width=8) (actual time=0.143..0.154 rows=100.00 loops=1)
                                      Sort Key: pa_1.instance_id, ea_1.employment_id
                                      Sort Method: quicksort  Memory: 27kB
                                      Buffers: shared hit=2
                                      ->  Hash Join  (cost=3.25..5.52 rows=100 width=8) (actual time=0.074..0.112 rows=100.00 loops=1)
                                            Hash Cond: (ea_1.planned_activity_id = pa_1.planned_activity_id)
                                            Buffers: shared hit=2
                                            ->  Seq Scan on employee_activity ea_1  (cost=0.00..2.00 rows=100 width=8) (actual time=0.021..0.030 rows=100.00 loops=1)
                                                  Buffers: shared hit=1
                                            ->  Hash  (cost=2.00..2.00 rows=100 width=8) (actual time=0.044..0.045 rows=100.00 loops=1)
                                                  Buckets: 1024  Batches: 1  Memory Usage: 12kB
                                                  Buffers: shared hit=1
                                                  ->  Seq Scan on planned_activity pa_1  (cost=0.00..2.00 rows=100 width=8) (actual time=0.008..0.022 rows=100.00 loops=1)
                                                        Buffers: shared hit=1
Planning:
  Buffers: shared hit=8
Planning Time: 2.372 ms
Execution Time: 13.381 ms
*/
