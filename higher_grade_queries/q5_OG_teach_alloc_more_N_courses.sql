SELECT 
  e.employment_id,
  p.first_name || ' ' || p.last_name AS teacher_name,
  COUNT(DISTINCT ci.instance_id) AS course_count
  
FROM employee e
  JOIN person p ON e.person_id = p.person_id
  JOIN employee_activity ea ON e.employment_id = ea.employment_id
  JOIN planned_activity pa ON ea.planned_activity_id = pa.planned_activity_id
  JOIN course_instance ci ON pa.instance_id = ci.instance_id
  
WHERE ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
  AND(   (EXTRACT(MONTH FROM CURRENT_DATE) < 3 AND ci.study_period = 'P1') --really basic logic
      OR ((EXTRACT(MONTH FROM CURRENT_DATE) >= 3 AND EXTRACT(MONTH FROM CURRENT_DATE) <= 6) AND ci.study_period = 'P2')
      OR ((EXTRACT(MONTH FROM CURRENT_DATE) >= 7 AND EXTRACT(MONTH FROM CURRENT_DATE) <= 10) AND ci.study_period = 'P3')
      OR (EXTRACT(MONTH FROM CURRENT_DATE) > 11 AND ci.study_period = 'P4'))
  
GROUP BY e.employment_id, p.first_name, p.last_name
HAVING COUNT(DISTINCT ci.instance_id) > $1  -- N parameter
ORDER BY course_count DESC;

/*
"Sort  (cost=11.76..11.77 rows=2 width=57) (actual time=0.036..0.037 rows=0.00 loops=1)"
"  Sort Key: (count(DISTINCT ci.instance_id)) DESC"
"  Sort Method: quicksort  Memory: 25kB"
"  Buffers: shared hit=3"
"  ->  GroupAggregate  (cost=11.62..11.75 rows=2 width=57) (actual time=0.032..0.034 rows=0.00 loops=1)"
"        Group Key: e.employment_id, p.first_name, p.last_name"
"        Filter: (count(DISTINCT ci.instance_id) > 1)"
"        Buffers: shared hit=3"
"        ->  Sort  (cost=11.62..11.63 rows=5 width=21) (actual time=0.032..0.033 rows=0.00 loops=1)"
"              Sort Key: e.employment_id, p.first_name, p.last_name, ci.instance_id"
"              Sort Method: quicksort  Memory: 25kB"
"              Buffers: shared hit=3"
"              ->  Nested Loop  (cost=5.20..11.56 rows=5 width=21) (actual time=0.028..0.029 rows=0.00 loops=1)"
"                    Buffers: shared hit=3"
"                    ->  Nested Loop  (cost=5.05..10.57 rows=5 width=12) (actual time=0.028..0.029 rows=0.00 loops=1)"
"                          Buffers: shared hit=3"
"                          ->  Hash Join  (cost=4.89..7.32 rows=5 width=8) (actual time=0.028..0.029 rows=0.00 loops=1)"
"                                Hash Cond: (ea.planned_activity_id = pa.planned_activity_id)"
"                                Buffers: shared hit=3"
"                                ->  Seq Scan on employee_activity ea  (cost=0.00..2.00 rows=100 width=8) (actual time=0.007..0.007 rows=1.00 loops=1)"
"                                      Buffers: shared hit=1"
"                                ->  Hash  (cost=4.83..4.83 rows=5 width=8) (actual time=0.016..0.016 rows=0.00 loops=1)"
"                                      Buckets: 1024  Batches: 1  Memory Usage: 8kB"
"                                      Buffers: shared hit=2"
"                                      ->  Hash Join  (cost=2.51..4.83 rows=5 width=8) (actual time=0.016..0.016 rows=0.00 loops=1)"
"                                            Hash Cond: (pa.instance_id = ci.instance_id)"
"                                            Buffers: shared hit=2"
"                                            ->  Seq Scan on planned_activity pa  (cost=0.00..2.00 rows=100 width=8) (actual time=0.002..0.002 rows=1.00 loops=1)"
"                                                  Buffers: shared hit=1"
"                                            ->  Hash  (cost=2.50..2.50 rows=1 width=4) (actual time=0.012..0.012 rows=0.00 loops=1)"
"                                                  Buckets: 1024  Batches: 1  Memory Usage: 8kB"
"                                                  Buffers: shared hit=1"
"                                                  ->  Seq Scan on course_instance ci  (cost=0.00..2.50 rows=1 width=4) (actual time=0.011..0.011 rows=0.00 loops=1)"
"                                                        Filter: (((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE)) AND (((EXTRACT(month FROM CURRENT_DATE) < '3'::numeric) AND (study_period = 'P1'::study_period)) OR ((EXTRACT(month FROM CURRENT_DATE) >= '3'::numeric) AND (EXTRACT(month FROM CURRENT_DATE) <= '6'::numeric) AND (study_period = 'P2'::study_period)) OR ((EXTRACT(month FROM CURRENT_DATE) >= '7'::numeric) AND (EXTRACT(month FROM CURRENT_DATE) <= '10'::numeric) AND (study_period = 'P3'::study_period)) OR ((EXTRACT(month FROM CURRENT_DATE) > '11'::numeric) AND (study_period = 'P4'::study_period))))"
"                                                        Rows Removed by Filter: 20"
"                                                        Buffers: shared hit=1"
"                          ->  Index Scan using employee_pkey on employee e  (cost=0.15..0.65 rows=1 width=8) (never executed)"
"                                Index Cond: (employment_id = ea.employment_id)"
"                                Index Searches: 0"
"                    ->  Index Scan using person_pkey on person p  (cost=0.15..0.20 rows=1 width=17) (never executed)"
"                          Index Cond: (person_id = e.person_id)"
"                          Index Searches: 0"
"Planning:"
"  Buffers: shared hit=16"
"Planning Time: 0.463 ms"
"Execution Time: 0.082 ms"
*/
