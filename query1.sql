-- Planned hours calculations: 
-- Calculate the total hours (with the multiplication factor) along with the break-ups for each activity, for the current years’ course instances. 

SELECT
    cl.course_code AS "Course Code",
    ci.instance_id AS "Course Instance ID",
    cl.hp AS "HP",
    ci.study_period AS "Period",
    ci.num_students AS "# Students",

    SUM(CASE WHEN ta.activity_name = 'Lecture'
             THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lecture Hours",
    SUM(CASE WHEN ta.activity_name = 'Tutorial'
             THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Tutorial Hours",
    SUM(CASE WHEN ta.activity_name = 'Lab'
             THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Lab Hours",
    SUM(CASE WHEN ta.activity_name = 'Seminar'
             THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Seminar Hours",
    SUM(CASE WHEN ta.activity_name = 'Overhead'
             THEN pa.planned_nb_hours * ta.factor ELSE 0 END) AS "Other Overhead Hours",
	
    (2*cl.hp+28+0.2*ci.num_students) AS "Administration Hours",
    (32+0.725*ci.num_students) AS "Examination Hours",
    SUM(pa.planned_nb_hours*ta.factor)+(2*cl.hp+28+0.2*ci.num_students)+(32+0.725*ci.num_students) AS "Total Hours" --= all planned * factor + Admin + Exam

FROM course_instance AS ci
JOIN course_layout AS cl ON ci.course_layout_id=cl.course_layout_id
JOIN planned_activity AS pa ON ci.instance_id=pa.instance_id
JOIN teaching_activity AS ta ON pa.teaching_activity_id=ta.teaching_activity_id

WHERE
    ci.study_year = EXTRACT(YEAR FROM CURRENT_DATE)

GROUP BY
    cl.course_code, ci.instance_id,cl.hp, ci.study_period, ci.num_students

ORDER BY
    cl.course_code, ci.instance_id;

/*
"Course Code"	"Course Instance ID"	"HP"	"Period"	"# Students"	"Lecture Hours"	"Tutorial Hours"	"Lab Hours"	"Seminar Hours"	"Other Overhead Hours"	"Admin"	"Exam"	"Total Hours"
100	1	7	"P2"	25	161.99999570846558	102.5999972820282	24.000000953674316	91.7999975681305	15	47.0	50.125	492.5249915122986
103	5	10	"P2"	25	122.39999675750732	61.19999837875366	33.60000133514404	61.19999837875366	1	53.0	50.125	382.5249948501587
107	9	10	"P2"	20	64.79999828338623	68.3999981880188	43.20000171661377	68.3999981880188	1	52.0	46.500	344.2999963760376
113	17	8	"P2"	15	93.59999752044678	46.79999876022339	62.40000247955322	46.79999876022339	6	47.0	42.875	345.4749975204468
119	13	10	"P1"	25	79.1999979019165	75.59999799728394	52.800002098083496	39.59999895095825	4	53.0	50.125	354.3249969482422
*/
