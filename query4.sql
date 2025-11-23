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


