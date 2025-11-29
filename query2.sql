-- Calculate actual allocated hours for a course: 
--Calculate the total allocated hours with the multiplication factor along with the break-ups 
--for each activity and for each teacher, for a current years’ course instance. 



-- counting the number of techers doing specific course to then allocate equal
-- amount of admin and exam hours of the course to each teacher
WITH teacher_counts AS (
    SELECT pa.instance_id, 
        COUNT(DISTINCT ea.employment_id) AS total_teachers
    FROM planned_activity pa
    JOIN employee_activity ea ON pa.planned_activity_id = ea.planned_activity_id
    GROUP BY pa.instance_id
)


SELECT
	cl.course_code AS "Course code",
	ci.instance_id AS "Course instance ID",
	cl.hp AS "HP",
	p.first_name || ' ' || p.last_name AS "Teacher's Name",
	jt.job_title as "Designation",
	SUM(CASE WHEN ta.activity_name = 'Lecture' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lecture Hours",
  	SUM(CASE WHEN ta.activity_name = 'Tutorial' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Tutorial Hours",
  	SUM(CASE WHEN ta.activity_name = 'Lab' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lab Hours",
  	SUM(CASE WHEN ta.activity_name = 'Seminar' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Seminar Hours",
 	SUM(CASE WHEN ta.activity_name = 'Overhead' THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Other Overhead Hours",
  	MAX(2 * cl.hp + 28 + 0.2 * ci.num_students) / tc.total_teachers AS "Admin ",
    MAX(32 + 0.725 * ci.num_students) / tc.total_teachers AS "Exam ",
    
    ( SUM(pa.planned_nb_hours * ta.factor) + 
      (MAX(2 * cl.hp + 28 + 0.2 * ci.num_students) / tc.total_teachers) + 
      (MAX(32 + 0.725 * ci.num_students) / tc.total_teachers)
    ) AS "Total Hours"
FROM
  course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id = cl.course_layout_id
JOIN planned_activity AS pa ON ci.instance_id = pa.instance_id
JOIN teaching_activity AS ta ON pa.teaching_activity_id = ta.teaching_activity_id
JOIN employee_activity AS ea ON pa.planned_activity_id = ea.planned_activity_id 
JOIN employee AS e ON ea.employment_id = e.employment_id 
JOIN job_title AS jt ON  e.job_id = jt.job_id 
JOIN person AS p ON  e.person_id = p.person_id 
JOIN teacher_counts AS tc ON ci.instance_id = tc.instance_id
WHERE
  ci.instance_id = 1
  AND ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)
  
GROUP BY
  cl.course_code, ci.instance_id, cl.hp, p.first_name, p.last_name, jt.job_title, tc.total_teachers;
/*
Course code	Course instance ID	HP	Teacher's Name	Designation	Lecture Hours		Tutorial Hours		Lab Hours		Seminar Hours		Other Overhead Hours	Admin			Exam			Total Hours
100	1	7	Anna Andersson	Lab Assistant	53.999998569488525	0.0	24.000000953674316	0.0	2.0	5.8750000000000000	6.2656250000000000	92.14062452316284
100	1	7	Erik Berg	Dean	0.0	0.0	0.0	37.79999899864197	0.0	5.8750000000000000	6.2656250000000000	49.94062399864197
100	1	7	Filip Eriksson	Administrator	0.0	0.0	0.0	0.0	1.0	5.8750000000000000	6.2656250000000000	13.140625
100	1	7	Jonas Johansson	Lab Assistant	0.0	53.999998569488525	0.0	0.0	5.0	5.8750000000000000	6.2656250000000000	71.14062356948853
100	1	7	Karin Ekström	Administrator	0.0	48.59999871253967	0.0	0.0	0.0	5.8750000000000000	6.2656250000000000	60.74062371253967
100	1	7	Maria Lindgren	Administrator	0.0	0.0	0.0	53.999998569488525	0.0	5.8750000000000000	6.2656250000000000	66.14062356948853
100	1	7	Niklas Olsson	Adjunct	107.99999713897705	0.0	0.0	0.0	0.0	5.8750000000000000	6.2656250000000000	120.14062213897705
100	1	7	Sven Lund	Technical Staff	0.0	0.0	0.0	0.0	7.0	5.8750000000000000	6.2656250000000000	19.140625

Result EXPLAIN ANALYZE:
GroupAggregate  (cost=50.95..52.58 rows=11 width=1712) (actual time=0.743..0.777 rows=8.00 loops=1)
  Group Key: cl.course_code, cl.hp, p.first_name, p.last_name, jt.job_title, (count(DISTINCT ea_1.employment_id))
  Buffers: shared hit=75
  ->  Sort  (cost=50.95..50.98 rows=11 width=2096) (actual time=0.711..0.719 rows=11.00 loops=1)
        Sort Key: cl.course_code, cl.hp, p.first_name, p.last_name, jt.job_title, (count(DISTINCT ea_1.employment_id))
        Sort Method: quicksort  Memory: 25kB
        Buffers: shared hit=75
        ->  Nested Loop  (cost=21.13..50.76 rows=11 width=2096) (actual time=0.557..0.657 rows=11.00 loops=1)
              Buffers: shared hit=75
              ->  GroupAggregate  (cost=4.85..4.92 rows=1 width=12) (actual time=0.193..0.195 rows=1.00 loops=1)
                    Buffers: shared hit=2
                    ->  Sort  (cost=4.85..4.88 rows=11 width=8) (actual time=0.185..0.188 rows=11.00 loops=1)
                          Sort Key: ea_1.employment_id
                          Sort Method: quicksort  Memory: 25kB
                          Buffers: shared hit=2
                          ->  Hash Join  (cost=2.39..4.66 rows=11 width=8) (actual time=0.138..0.163 rows=11.00 loops=1)
                                Hash Cond: (ea_1.planned_activity_id = pa_1.planned_activity_id)
                                Buffers: shared hit=2
                                ->  Seq Scan on employee_activity ea_1  (cost=0.00..2.00 rows=100 width=8) (actual time=0.026..0.035 rows=100.00 loops=1)
                                      Buffers: shared hit=1
                                ->  Hash  (cost=2.25..2.25 rows=11 width=8) (actual time=0.043..0.044 rows=11.00 loops=1)
                                      Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                      Buffers: shared hit=1
                                      ->  Seq Scan on planned_activity pa_1  (cost=0.00..2.25 rows=11 width=8) (actual time=0.013..0.022 rows=11.00 loops=1)
                                            Filter: (instance_id = 1)
                                            Rows Removed by Filter: 89
                                            Buffers: shared hit=1
              ->  Nested Loop  (cost=16.27..45.73 rows=11 width=2088) (actual time=0.361..0.456 rows=11.00 loops=1)
                    Buffers: shared hit=73
                    ->  Nested Loop  (cost=16.13..43.66 rows=11 width=1060) (actual time=0.346..0.422 rows=11.00 loops=1)
                          Buffers: shared hit=51
                          ->  Nested Loop  (cost=15.99..41.56 rows=11 width=548) (actual time=0.302..0.361 rows=11.00 loops=1)
                                Buffers: shared hit=29
                                ->  Hash Join  (cost=15.84..34.41 rows=11 width=544) (actual time=0.284..0.322 rows=11.00 loops=1)
                                      Hash Cond: (pa.teaching_activity_id = ta.teaching_activity_id)
                                      Buffers: shared hit=7
                                      ->  Nested Loop  (cost=2.69..21.23 rows=11 width=28) (actual time=0.183..0.216 rows=11.00 loops=1)
                                            Buffers: shared hit=6
                                            ->  Nested Loop  (cost=0.30..16.46 rows=1 width=16) (actual time=0.068..0.070 rows=1.00 loops=1)
                                                  Buffers: shared hit=4
                                                  ->  Index Scan using course_instance_pkey on course_instance ci  (cost=0.15..8.18 rows=1 width=12) (actual time=0.027..0.028 rows=1.00 loops=1)
                                                        Index Cond: (instance_id = 1)
                                                        Filter: ((study_year)::numeric = EXTRACT(year FROM CURRENT_DATE))
                                                        Index Searches: 1
                                                        Buffers: shared hit=2
                                                  ->  Index Scan using course_layout_pkey on course_layout cl  (cost=0.14..8.16 rows=1 width=12) (actual time=0.039..0.039 rows=1.00 loops=1)
                                                        Index Cond: (course_layout_id = ci.course_layout_id)
                                                        Index Searches: 1
                                                        Buffers: shared hit=2
                                            ->  Hash Join  (cost=2.39..4.66 rows=11 width=16) (actual time=0.113..0.141 rows=11.00 loops=1)
                                                  Hash Cond: (ea.planned_activity_id = pa.planned_activity_id)
                                                  Buffers: shared hit=2
                                                  ->  Seq Scan on employee_activity ea  (cost=0.00..2.00 rows=100 width=8) (actual time=0.010..0.020 rows=100.00 loops=1)
                                                        Buffers: shared hit=1
                                                  ->  Hash  (cost=2.25..2.25 rows=11 width=16) (actual time=0.030..0.031 rows=11.00 loops=1)
                                                        Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                        Buffers: shared hit=1
                                                        ->  Seq Scan on planned_activity pa  (cost=0.00..2.25 rows=11 width=16) (actual time=0.007..0.015 rows=11.00 loops=1)
                                                              Filter: (instance_id = 1)
                                                              Rows Removed by Filter: 89
                                                              Buffers: shared hit=1
                                      ->  Hash  (cost=11.40..11.40 rows=140 width=524) (actual time=0.056..0.057 rows=5.00 loops=1)
                                            Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                            Buffers: shared hit=1
                                            ->  Seq Scan on teaching_activity ta  (cost=0.00..11.40 rows=140 width=524) (actual time=0.039..0.040 rows=5.00 loops=1)
                                                  Buffers: shared hit=1
                                ->  Index Scan using employee_pkey on employee e  (cost=0.15..0.65 rows=1 width=12) (actual time=0.003..0.003 rows=1.00 loops=11)
                                      Index Cond: (employment_id = ea.employment_id)
                                      Index Searches: 11
                                      Buffers: shared hit=22
                          ->  Index Scan using job_title_pkey on job_title jt  (cost=0.14..0.19 rows=1 width=520) (actual time=0.005..0.005 rows=1.00 loops=11)
                                Index Cond: (job_id = e.job_id)
                                Index Searches: 11
                                Buffers: shared hit=22
                    ->  Index Scan using person_pkey on person p  (cost=0.14..0.19 rows=1 width=1036) (actual time=0.002..0.002 rows=1.00 loops=11)
                          Index Cond: (person_id = e.person_id)
                          Index Searches: 11
                          Buffers: shared hit=22
Planning:
  Buffers: shared hit=8
Planning Time: 3.211 ms
Execution Time: 1.234 ms
*/
