--List employee ids and names of all teachers who are allocated 
--in more than a specific number (we chose more that 0) of course instances 
--during the current period.

SELECT
	
	e.employment_id AS "Employment ID",
	p.first_name || ' ' || p.last_name AS "Teacher's Name",
	ci.study_period AS "Period", 
	COUNT(DISTINCT ci.instance_id) AS "No of courses"
FROM 
	employee AS e
JOIN person AS p ON e.person_id = p.person_id
JOIN employee_activity AS ea ON e.employment_id = ea.employment_id
JOIN planned_activity AS pa ON ea.planned_activity_id = pa.planned_activity_id
JOIN course_instance AS ci ON pa.instance_id = ci.instance_id


WHERE
   ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
	
  -- we decided to take period time exactly how it is in KTH from KTH website 
  AND ci.study_period = (
      CASE 
          WHEN TO_CHAR(CURRENT_DATE, 'MMDD') BETWEEN '0825' AND '1024' THEN 'P1'
          WHEN TO_CHAR(CURRENT_DATE, 'MMDD') >= '1027' OR TO_CHAR(CURRENT_DATE, 'MMDD') <= '0112' THEN 'P2'
          WHEN TO_CHAR(CURRENT_DATE, 'MMDD') BETWEEN '0113' AND '0313' THEN 'P3'
          WHEN TO_CHAR(CURRENT_DATE, 'MMDD') BETWEEN '0316' AND '0601' THEN 'P4'
          ELSE NULL 
      END
  )::study_period 

GROUP BY
  e.employment_id, p.first_name, p.last_name, ci.study_period

HAVING 
    COUNT(DISTINCT ci.instance_id) > 0;
/*
Employment ID	Teacher's Name		Period		"No of courses"
1	Anna Andersson	P2	1
2	Erik Berg	P2	2
3	Karin Ekström	P2	1
4	Oskar Nilsson	P2	1
5	Lisa Karlsson	P2	1
6	Jonas Johansson	P2	1
7	Sara Persson	P2	1
9	Eva Larsson	P2	1
10	Johan Lindberg	P2	1
11	Maria Lindgren	P2	1
12	Filip Eriksson	P2	2
14	Fredrik Danielsson	P2	1
15	Emma Holm	P2	1
16	Niklas Olsson	P2	1
17	Isabel Magnusson	P2	1
18	Sven Lund	P2	1
19	Nina Nordin	P2	1
20	Axel Westin	P2	1

Result form EXPLAIN ANALYZE:

GroupAggregate  (cost=21.93..21.96 rows=1 width=1080) (actual time=1.374..1.395 rows=18.00 loops=1)
  Group Key: e.employment_id, p.first_name, p.last_name
  Filter: (count(DISTINCT ci.instance_id) > 0)
  Buffers: shared hit=197
  ->  Sort  (cost=21.93..21.93 rows=1 width=1044) (actual time=1.359..1.364 rows=26.00 loops=1)
        Sort Key: e.employment_id, p.first_name, p.last_name, ci.instance_id
        Sort Method: quicksort  Memory: 26kB
        Buffers: shared hit=197
        ->  Nested Loop  (cost=0.60..21.92 rows=1 width=1044) (actual time=0.414..1.277 rows=26.00 loops=1)
              Buffers: shared hit=197
              ->  Nested Loop  (cost=0.46..21.73 rows=1 width=16) (actual time=0.293..1.081 rows=26.00 loops=1)
                    Buffers: shared hit=145
                    ->  Nested Loop  (cost=0.31..21.08 rows=1 width=12) (actual time=0.246..0.952 rows=26.00 loops=1)
                          Buffers: shared hit=93
                          ->  Nested Loop  (cost=0.16..20.04 rows=1 width=12) (actual time=0.134..0.337 rows=26.00 loops=1)
                                Buffers: shared hit=41
                                ->  Seq Scan on planned_activity pa  (cost=0.00..2.00 rows=100 width=8) (actual time=0.034..0.051 rows=100.00 loops=1)
                                      Buffers: shared hit=1
                                ->  Memoize  (cost=0.16..0.76 rows=1 width=8) (actual time=0.002..0.002 rows=0.26 loops=100)
                                      Cache Key: pa.instance_id
                                      Cache Mode: logical
                                      Hits: 80  Misses: 20  Evictions: 0  Overflows: 0  Memory Usage: 2kB
                                      Buffers: shared hit=40
                                      ->  Index Scan using course_instance_pkey on course_instance ci  (cost=0.15..0.75 rows=1 width=8) (actual time=0.008..0.008 rows=0.20 loops=20)
                                            Index Cond: (instance_id = pa.instance_id)
                                            Filter: (((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE)) AND (study_period = (CASE WHEN ((to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) >= '0825'::text) AND (to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) <= '1024'::text)) THEN 'P1'::text WHEN ((to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) >= '1027'::text) OR (to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) <= '0112'::text)) THEN 'P2'::text WHEN ((to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) >= '0113'::text) AND (to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) <= '0313'::text)) THEN 'P3'::text WHEN ((to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) >= '0316'::text) AND (to_char((CURRENT_DATE)::timestamp with time zone, 'MMDD'::text) <= '0601'::text)) THEN 'P4'::text ELSE NULL::text END)::study_period))
                                            Rows Removed by Filter: 1
                                            Index Searches: 20
                                            Buffers: shared hit=40
                          ->  Index Only Scan using employee_activity_pkey on employee_activity ea  (cost=0.14..1.02 rows=1 width=8) (actual time=0.022..0.023 rows=1.00 loops=26)
                                Index Cond: (planned_activity_id = pa.planned_activity_id)
                                Heap Fetches: 26
                                Index Searches: 26
                                Buffers: shared hit=52
                    ->  Index Scan using employee_pkey on employee e  (cost=0.15..0.65 rows=1 width=8) (actual time=0.004..0.004 rows=1.00 loops=26)
                          Index Cond: (employment_id = ea.employment_id)
                          Index Searches: 26
                          Buffers: shared hit=52
              ->  Index Scan using person_pkey on person p  (cost=0.14..0.19 rows=1 width=1036) (actual time=0.006..0.006 rows=1.00 loops=26)
                    Index Cond: (person_id = e.person_id)
                    Index Searches: 26
                    Buffers: shared hit=52
Planning:
  Buffers: shared hit=4
Planning Time: 2.355 ms
Execution Time: 1.893 ms
*/
