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
