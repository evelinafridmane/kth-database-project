
CREATE OR REPLACE VIEW v_course_variance as

WITH planned_data AS (
    SELECT
        cl.course_code,
        ci.instance_id,
        --total planned hours
        SUM(pa.planned_nb_hours * ta.factor) + 
        (2 * cl.hp + 28 + 0.2 * ci.num_students) + 
        (32 + 0.725 * ci.num_students) AS total_planned
        
    from
    course_instance AS ci
    JOIN course_layout AS cl ON ci.course_layout_id = cl.course_layout_id
    JOIN planned_activity AS pa ON ci.instance_id = pa.instance_id
    JOIN teaching_activity AS ta ON pa.teaching_activity_id = ta.teaching_activity_id
    
    WHERE ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY cl.course_code, ci.instance_id, cl.hp, ci.num_students
),
allocated_data AS (
    -- total actual hours from materialized view
    SELECT 
        instance_id, 
        SUM(total_hours) as total_allocated
    FROM mv_teacher_allocated_hours
    GROUP BY instance_id)

SELECT 
    p.course_code, 
    p.instance_id, 
    p.total_planned, 
    a.total_allocated
FROM planned_data p
JOIN allocated_data a ON p.instance_id = a.instance_id
WHERE ABS(p.total_planned - a.total_allocated) / p.total_planned > 0.15;


explain analyze 

SELECT * 
FROM v_course_variance;

/*Hash Join  (cost=26.40..26.90 rows=1 width=24) (actual time=0.523..0.528 rows=0.00 loops=1)
  Hash Cond: (mv_teacher_allocated_hours.instance_id = p.instance_id)
  Join Filter: ((abs((p.total_planned - (sum(mv_teacher_allocated_hours.total_hours)))) / p.total_planned) > '0.15'::double precision)
  Rows Removed by Join Filter: 5
  Buffers: shared hit=167
  ->  HashAggregate  (cost=3.22..3.42 rows=20 width=12) (actual time=0.076..0.082 rows=20.00 loops=1)
        Group Key: mv_teacher_allocated_hours.instance_id
        Batches: 1  Memory Usage: 32kB
        Buffers: shared hit=2
        ->  Seq Scan on mv_teacher_allocated_hours  (cost=0.00..2.81 rows=81 width=12) (actual time=0.015..0.027 rows=81.00 loops=1)
              Buffers: shared hit=2
  ->  Hash  (cost=23.17..23.17 rows=1 width=16) (actual time=0.418..0.421 rows=5.00 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 9kB
        Buffers: shared hit=165
        ->  Subquery Scan on p  (cost=23.10..23.17 rows=1 width=16) (actual time=0.393..0.416 rows=5.00 loops=1)
              Buffers: shared hit=165
              ->  GroupAggregate  (cost=23.10..23.16 rows=1 width=24) (actual time=0.392..0.413 rows=5.00 loops=1)
                    Group Key: cl.course_code, ci.instance_id, cl.hp
                    Buffers: shared hit=165
                    ->  Sort  (cost=23.10..23.11 rows=1 width=24) (actual time=0.372..0.378 rows=31.00 loops=1)
                          Sort Key: cl.course_code, ci.instance_id, cl.hp
                          Sort Method: quicksort  Memory: 26kB
                          Buffers: shared hit=165
                          ->  Nested Loop  (cost=0.45..23.09 rows=1 width=24) (actual time=0.057..0.345 rows=31.00 loops=1)
                                Buffers: shared hit=165
                                ->  Nested Loop  (cost=0.31..22.44 rows=1 width=24) (actual time=0.044..0.262 rows=31.00 loops=1)
                                      Buffers: shared hit=103
                                      ->  Nested Loop  (cost=0.16..18.22 rows=1 width=20) (actual time=0.031..0.175 rows=31.00 loops=1)
                                            Buffers: shared hit=41
                                            ->  Seq Scan on planned_activity pa  (cost=0.00..2.00 rows=100 width=12) (actual time=0.009..0.023 rows=100.00 loops=1)
                                                  Buffers: shared hit=1
                                            ->  Memoize  (cost=0.16..0.67 rows=1 width=12) (actual time=0.001..0.001 rows=0.31 loops=100)
                                                  Cache Key: pa.instance_id
                                                  Cache Mode: logical
                                                  Hits: 80  Misses: 20  Evictions: 0  Overflows: 0  Memory Usage: 2kB
                                                  Buffers: shared hit=40
                                                  ->  Index Scan using course_instance_pkey on course_instance ci  (cost=0.15..0.66 rows=1 width=12) (actual time=0.003..0.003 rows=0.25 loops=20)
                                                        Index Cond: (instance_id = pa.instance_id)
                                                        Filter: ((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE))
                                                        Rows Removed by Filter: 1
                                                        Index Searches: 20
                                                        Buffers: shared hit=40
                                      ->  Index Scan using course_layout_pkey on course_layout cl  (cost=0.14..4.16 rows=1 width=12) (actual time=0.002..0.002 rows=1.00 loops=31)
                                            Index Cond: (course_layout_id = ci.course_layout_id)
                                            Index Searches: 31
                                            Buffers: shared hit=62
                                ->  Index Scan using teaching_activity_pkey on teaching_activity ta  (cost=0.14..0.64 rows=1 width=8) (actual time=0.002..0.002 rows=1.00 loops=31)
                                      Index Cond: (teaching_activity_id = pa.teaching_activity_id)
                                      Index Searches: 31
                                      Buffers: shared hit=62
Planning:
  Buffers: shared hit=3
Planning Time: 0.683 ms
Execution Time: 0.696 ms
*/
