-- Total allocated hours
-- Calculate the total allocated hours (with multiplication factors) for a teacher, only for the current years’ course instances.  

-- EXPLAIN (ANALYZE)
SELECT
  cl.course_code AS "Course Code",
  ci.instance_id AS "Course Instance ID",
  cl.hp AS "HP",
  ci.study_period AS "Period",
  p.first_name || ' ' || p.last_name AS "Teacher's Name",
  SUM(CASE WHEN ta.activity_name = 'Lecture' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lecture Hours",
  SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Tutorial Hours",
  SUM(CASE WHEN ta.activity_name = 'Lab' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lab Hours",
  SUM(CASE WHEN ta.activity_name = 'Seminar' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Seminar Hours",
  SUM(CASE WHEN ta.activity_name = 'Overhead' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Other Overhead Hours",
	
  (2*cl.hp+28+0.2*ci.num_students) AS "Administration Hours",
  (32+0.725*ci.num_students) AS "Examination Hours",
  SUM(pa.planned_nb_hours*ta.factor)+(2*cl.hp+28+0.2*ci.num_students)+(32+0.725*ci.num_students) AS "Total Hours" --= all planned * factor + Admin + Exam
  
FROM
  employee AS e
JOIN person AS p ON e.person_id = p.person_id
JOIN employee_activity AS ea ON e.employment_id = ea.employment_id
JOIN planned_activity AS pa ON ea.planned_activity_id = pa.planned_activity_id
JOIN teaching_activity AS ta ON pa.teaching_activity_id = ta.teaching_activity_id
JOIN course_instance AS ci ON pa.instance_id = ci.instance_id
JOIN course_layout AS cl ON ci.course_layout_id = cl.course_layout_id
WHERE
  p.first_name = 'Filip' AND p.last_name = 'Eriksson'
  AND ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
  
GROUP BY
  cl.course_code, ci.instance_id, cl.hp, ci.study_period, p.first_name, p.last_name
ORDER BY
  cl.course_code, ci.instance_id;

/*
"Course Code"	"Course Instance ID"	"HP"	"Period"	"Teacher's Name"	"Lecture Hours"	"Tutorial Hours"	"Lab Hours"	"Seminar Hours"	"Other Overhead Hours"	"Admin"	"Exam"	"Total Hours"
100	1	7	"P2"	"Filip Eriksson"	0	0	0	0	1	0	0	1
113	17	8	"P2"	"Filip Eriksson"	93.59999752044678	0	0	0	0	0	0	93.59999752044678
*/

/*
"QUERY PLAN"
"GroupAggregate  (cost=25.00..25.14 rows=1 width=173) (actual time=2.394..2.405 rows=2.00 loops=1)"
"  Group Key: cl.course_code, ci.instance_id, cl.hp"
"  Buffers: shared hit=235"
"  ->  Sort  (cost=25.00..25.00 rows=1 width=557) (actual time=2.356..2.360 rows=2.00 loops=1)"
"        Sort Key: cl.course_code, ci.instance_id, cl.hp"
"        Sort Method: quicksort  Memory: 25kB"
"        Buffers: shared hit=235"
"        ->  Nested Loop  (cost=0.91..24.99 rows=1 width=557) (actual time=1.488..1.957 rows=2.00 loops=1)"
"              Buffers: shared hit=235"
"              ->  Nested Loop  (cost=0.76..20.81 rows=1 width=553) (actual time=1.475..1.941 rows=2.00 loops=1)"
"                    Buffers: shared hit=231"
"                    ->  Nested Loop  (cost=0.61..20.16 rows=1 width=37) (actual time=1.076..1.538 rows=2.00 loops=1)"
"                          Buffers: shared hit=227"
"                          ->  Nested Loop  (cost=0.46..19.91 rows=1 width=28) (actual time=0.716..1.450 rows=31.00 loops=1)"
"                                Buffers: shared hit=165"
"                                ->  Nested Loop  (cost=0.31..19.26 rows=1 width=28) (actual time=0.704..1.369 rows=31.00 loops=1)"
"                                      Buffers: shared hit=103"
"                                      ->  Nested Loop  (cost=0.16..18.22 rows=1 width=28) (actual time=0.066..0.323 rows=31.00 loops=1)"
"                                            Buffers: shared hit=41"
"                                            ->  Seq Scan on planned_activity pa  (cost=0.00..2.00 rows=100 width=16) (actual time=0.023..0.036 rows=100.00 loops=1)"
"                                                  Buffers: shared hit=1"
"                                            ->  Memoize  (cost=0.16..0.67 rows=1 width=16) (actual time=0.002..0.002 rows=0.31 loops=100)"
"                                                  Cache Key: pa.instance_id"
"                                                  Cache Mode: logical"
"                                                  Hits: 80  Misses: 20  Evictions: 0  Overflows: 0  Memory Usage: 2kB"
"                                                  Buffers: shared hit=40"
"                                                  ->  Index Scan using course_instance_pkey on course_instance ci  (cost=0.15..0.66 rows=1 width=16) (actual time=0.003..0.003 rows=0.25 loops=20)"
"                                                        Index Cond: (instance_id = pa.instance_id)"
"                                                        Filter: ((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE))"
"                                                        Rows Removed by Filter: 1"
"                                                        Index Searches: 20"
"                                                        Buffers: shared hit=40"
"                                      ->  Index Only Scan using employee_activity_pkey on employee_activity ea  (cost=0.14..1.02 rows=1 width=8) (actual time=0.033..0.033 rows=1.00 loops=31)"
"                                            Index Cond: (planned_activity_id = pa.planned_activity_id)"
"                                            Heap Fetches: 31"
"                                            Index Searches: 31"
"                                            Buffers: shared hit=62"
"                                ->  Index Scan using employee_pkey on employee e  (cost=0.15..0.65 rows=1 width=8) (actual time=0.002..0.002 rows=1.00 loops=31)"
"                                      Index Cond: (employment_id = ea.employment_id)"
"                                      Index Searches: 31"
"                                      Buffers: shared hit=62"
"                          ->  Index Scan using person_pkey on person p  (cost=0.15..0.20 rows=1 width=17) (actual time=0.002..0.002 rows=0.06 loops=31)"
"                                Index Cond: (person_id = e.person_id)"
"                                Filter: (((first_name)::text = 'Filip'::text) AND ((last_name)::text = 'Eriksson'::text))"
"                                Rows Removed by Filter: 1"
"                                Index Searches: 31"
"                                Buffers: shared hit=62"
"                    ->  Index Scan using teaching_activity_pkey on teaching_activity ta  (cost=0.14..0.64 rows=1 width=524) (actual time=0.199..0.199 rows=1.00 loops=2)"
"                          Index Cond: (teaching_activity_id = pa.teaching_activity_id)"
"                          Index Searches: 2"
"                          Buffers: shared hit=4"
"              ->  Index Scan using course_layout_pkey on course_layout cl  (cost=0.15..4.17 rows=1 width=12) (actual time=0.006..0.006 rows=1.00 loops=2)"
"                    Index Cond: (course_layout_id = ci.course_layout_id)"
"                    Index Searches: 2"
"                    Buffers: shared hit=4"
"Planning:"
"  Buffers: shared hit=20"
"Planning Time: 10.010 ms"
"Execution Time: 4.222 ms"
*/
