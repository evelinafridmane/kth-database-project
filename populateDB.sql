TRUNCATE TABLE address RESTART IDENTITY CASCADE;
TRUNCATE TABLE person RESTART IDENTITY CASCADE;
TRUNCATE TABLE phone_number RESTART IDENTITY CASCADE;
TRUNCATE TABLE job_title RESTART IDENTITY CASCADE;
TRUNCATE TABLE department RESTART IDENTITY CASCADE;
TRUNCATE TABLE employee RESTART IDENTITY CASCADE;
TRUNCATE TABLE skill RESTART IDENTITY CASCADE;
TRUNCATE TABLE course_layout RESTART IDENTITY CASCADE;
TRUNCATE TABLE teaching_activity RESTART IDENTITY CASCADE;
TRUNCATE TABLE course_instance RESTART IDENTITY CASCADE;
TRUNCATE TABLE planned_activity RESTART IDENTITY CASCADE;
TRUNCATE TABLE employee_activity RESTART IDENTITY CASCADE;
TRUNCATE TABLE person_address RESTART IDENTITY CASCADE;
TRUNCATE TABLE salary_history RESTART IDENTITY CASCADE;

-- -------------------------------
-- ADDRESS - all Sweden for country
-- -------------------------------
INSERT INTO address (street_name, zip, city, country) VALUES
('Lindstedtsvägen', '10010', 'Stockholm', 'Sweden'),
('Drottninggatan', '10123', 'Stockholm', 'Sweden'),
('Sveavägen', '11122', 'Stockholm', 'Sweden'),
('Kungsgatan', '11345', 'Stockholm', 'Sweden'),
('Vasagatan', '11055', 'Stockholm', 'Sweden'),
('Odengatan', '10456', 'Stockholm', 'Sweden'),
('Sturegatan', '11010', 'Stockholm', 'Sweden'),
('Birger Jarlsgatan', '10888', 'Stockholm', 'Sweden'),
('Valhallavägen', '10220', 'Stockholm', 'Sweden'),
('Roslagsvägen', '10987', 'Stockholm', 'Sweden'),
('Teknologgatan', '10500', 'Stockholm', 'Sweden'),
('Norra Stationsgatan', '10011', 'Stockholm', 'Sweden'),
('Odenplan', '10333', 'Stockholm', 'Sweden'),
('Norrtullsgatan', '10022', 'Stockholm', 'Sweden'),
('Götgatan', '11111', 'Stockholm', 'Sweden'),
('Stora Nygatan', '11234', 'Stockholm', 'Sweden'),
('Södra Stationsgatan', '11300', 'Stockholm', 'Sweden'),
('Fleminggatan', '11411', 'Stockholm', 'Sweden'),
('Hantverkargatan', '11512', 'Stockholm', 'Sweden'),
('Tegnergatan', '11613', 'Stockholm', 'Sweden');

-- -------------------------------
-- PERSON
-- -------------------------------
INSERT INTO person (personal_number, first_name, last_name) VALUES
('198005022053', 'Anna', 'Andersson'),
('198110259342', 'Erik', 'Berg'),
('198206055793', 'Karin', 'Ekström'),
('198304249785', 'Oskar', 'Nilsson'),
('198407092929', 'Lisa', 'Karlsson'),
('198506235174', 'Jonas', 'Johansson'),
('198609067993', 'Sara', 'Persson'),
('198705246050', 'Karl', 'Svensson'),
('198805226011', 'Eva', 'Larsson'),
('198911061897', 'Johan', 'Lindberg'),
('199008215442', 'Maria', 'Lindgren'),
('199102139474', 'Filip', 'Eriksson'),
('199212183383', 'Julia', 'Sandberg'),
('199312217917', 'Fredrik', 'Danielsson'),
('199405263548', 'Emma', 'Holm'),
('199505192402', 'Niklas', 'Olsson'),
('199604244765', 'Isabel', 'Magnusson'),
('199704192619', 'Sven', 'Lund'),
('199808034740', 'Nina', 'Nordin'),
('199911191526', 'Axel', 'Westin');

-- -------------------------------
-- PHONE_NUMBER
-- -------------------------------
INSERT INTO phone_number (phone_nb, person_id) VALUES
('0704972835', 1), ('0701170952', 2), ('0708577626', 3), ('0707001915', 4), ('0701876138', 5),
('0701744056', 6), ('0701800121', 7), ('0704169736', 8), ('0705517867', 9), ('0703339570', 10),
('0707636931', 11), ('0703829417', 12), ('0701126724', 13), ('0702820493', 14), ('0706367444', 15),
('0701717955', 16), ('0705209512', 17), ('0705441941', 18), ('0707411053', 19), ('0708679152', 20);

-- -------------------------------
-- JOB_TITLE
-- -------------------------------
INSERT INTO job_title (job_title) VALUES
('Professor'), ('Lecturer'), ('Researcher'), ('Administrator'), ('Lab Assistant'),
('Course Coordinator'), ('Adjunct'), ('Technical Staff'), ('Postdoc'), ('Dean');

-- -------------------------------
-- DEPARTMENT (since dependant on employee populate like that first, need to remove NOT NULL constrain form mahnager_id)
-- -------------------------------
ALTER TABLE department ALTER COLUMN manager_id DROP NOT NULL; -- temporarily drop this constraint to start populating
INSERT INTO department (department_name, manager_id) VALUES
('Computer Science', NULL), ('Mathematics', NULL), ('Physics', NULL), ('Electrical Engineering', NULL), ('Mechanical Engineering', NULL),
('Civil Engineering', NULL), ('Architecture', NULL), ('Chemistry', NULL), ('Biotechnology', NULL), ('Industrial Management', NULL);

-- -------------------------------
-- EMPLOYEE
-- -------------------------------
INSERT INTO employee (manager_id, person_id, job_id, department_id) VALUES
(NULL, 1, 5, 1), (1, 2, 10, 2), (2, 3, 4, 3), (3, 4, 1, 4), (4, 5, 2, 5),
(5, 6, 5, 6), (6, 7, 9, 7), (7, 8, 8, 8), (8, 9, 7, 9), (9, 10, 6, 10),
(10, 11, 4, 1), (11, 12, 4, 2), (12, 13, 3, 3), (13, 14, 1, 4), (14, 15, 6, 5),
(15, 16, 7, 6), (16, 17, 7, 7), (17, 18, 8, 8), (18, 19, 9, 9), (19, 20, 10, 10);

-- -------------------------------
-- DEPARTMENT
-- -------------------------------
UPDATE department SET manager_id = 1 WHERE department_name = 'Computer Science';
UPDATE department SET manager_id = 2 WHERE department_name = 'Mathematics';
UPDATE department SET manager_id = 3 WHERE department_name = 'Physics';
UPDATE department SET manager_id = 4 WHERE department_name = 'Electrical Engineering';
UPDATE department SET manager_id = 5 WHERE department_name = 'Mechanical Engineering';
UPDATE department SET manager_id = 6 WHERE department_name = 'Civil Engineering';
UPDATE department SET manager_id = 7 WHERE department_name = 'Architecture';
UPDATE department SET manager_id = 8 WHERE department_name = 'Chemistry';
UPDATE department SET manager_id = 9 WHERE department_name = 'Biotechnology';
UPDATE department SET manager_id = 10 WHERE department_name = 'Industrial Management';
ALTER TABLE department ALTER COLUMN manager_id SET NOT NULL;

-- -------------------------------
-- SKILL
-- -------------------------------
INSERT INTO skill (skill_name, employment_id) VALUES
('Python', 1), ('Java', 2), ('C++', 3), ('Matlab', 4), ('R', 5), ('SQL', 6),
('Linux', 7), ('Public Speaking', 8), ('Data Analysis', 9), ('CAD', 10),
('Python', 11), ('Java', 12), ('C++', 13), ('Matlab', 14), ('R', 15), ('SQL', 16),
('Linux', 17), ('Public Speaking', 18), ('Data Analysis', 19), ('CAD', 20);

-- -------------------------------
-- COURSE_LAYOUT
-- -------------------------------
INSERT INTO course_layout (course_code, layout_version, course_name, min_students, max_students, hp) VALUES
(100, 1, 'Database Systems', 10, 30, 7), (101, 1, 'Machine Learning', 11, 31, 8),
(102, 1, 'Algorithms', 12, 32, 9), (103, 1, 'Linear Algebra', 13, 33, 10),(103, 2, 'Linear Algebra', 13, 25, 10),
(104, 1, 'Signal Processing', 10, 34, 7), (105, 1, 'Thermodynamics', 11, 35, 8),
(106, 1, 'Fluid Mechanics', 12, 36, 9), (107, 1, 'Organic Chemistry', 13, 37, 10),
(108, 1, 'Control Theory', 10, 38, 7), (109, 1, 'Design Thinking', 11, 39, 8),
(110, 1, 'Quantum Physics', 12, 30, 9), (111, 1, 'Programming', 13, 31, 10), (111, 2, 'Programming', 20, 31, 10),
(111, 3, 'Programming', 13, 25, 15),
(112, 1, 'Project Management', 10, 32, 7), (113, 1, 'Robotics', 11, 33, 8),
(114, 1, 'Bioinformatics', 12, 34, 9), (115, 1, 'Digital Communications', 13, 35, 10),
(116, 1, 'Materials Science', 10, 36, 7), (117, 1, 'Circuit Analysis', 11, 37, 8),
(118, 1, 'Statistical Physics', 12, 38, 9), (119, 1, 'Structural Engineering', 13, 39, 10);

-- -------------------------------
-- TEACHING_ACTIVITY
-- -------------------------------
INSERT INTO teaching_activity (activity_name, factor) VALUES
('Lab', 2.4), ('Lecture', 3.6), ('Seminar', 1.8), ('Tutorial', 1.8), ('Overhead', 1); -- added overhead

--other possibilities:
--('Group Work', 1.02), ('Project Supervision', 1.99),
--('Exam', 1.63), ('Demo', 1.23), ('Hackathon', 1.28), ('Workshop', 1.06), ('Guest Lecture', 0.58);

-- -------------------------------
-- COURSE_INSTANCE changed to fit query 4
-- -------------------------------
INSERT INTO course_instance (num_students, study_period, study_year, course_layout_id) VALUES
(25, 'P2', 2025, 1), (20, 'P1', 2022, 2), (40, 'P3', 2023, 13), (10, 'P4', 2024, 14),
(25, 'P2', 2025, 5), (30, 'P2', 2022, 6), (15, 'P3', 2023, 7), (20, 'P4', 2024, 18),
(20, 'P2', 2025, 9), (40, 'P2', 2022, 20), (10, 'P3', 2023, 12), (30, 'P4', 2024, 2),
(25, 'P1', 2025, 23), (10, 'P2', 2022, 14), (10, 'P3', 2023, 15), (30, 'P4', 2024, 16),
(15, 'P2', 2025, 17), (15, 'P2', 2022, 18), (30, 'P3', 2023, 9), (30, 'P4', 2024, 20);

-- -------------------------------
-- PLANNED_ACTIVITY changed to fit the query 2
-- -------------------------------
INSERT INTO planned_activity (planned_nb_hours, instance_id, teaching_activity_id) VALUES
-- lab (1–20)
(10, 1, 1), (11, 2, 1), (12, 3, 1), (13, 4, 1), (14, 5, 1),
(15, 6, 1), (16, 7, 1), (17, 8, 1), (18, 9, 1), (19, 10, 1),
(20, 11, 1), (21, 12, 1), (22, 13, 1), (23, 14, 1), (24, 15, 1),
(25, 16, 1), (26, 17, 1), (27, 18, 1), (28, 19, 1), (29, 20, 1),

-- lecture (21–40)
(15, 1, 2), (16, 7, 2), (17, 8, 2), (18, 9, 2), (19, 10, 2),
(20, 11, 2), (21, 12, 2), (22, 13, 2), (23, 14, 2), (24, 15, 2),
(25, 16, 2), (26, 17, 2), (27, 18, 2), (28, 19, 2), (29, 20, 2),
(30, 1, 2), (31, 2, 2), (32, 3, 2), (33, 4, 2), (34, 5, 2),

-- seminar (41–60)
(20, 11, 3), (21, 1, 3), (22, 13, 3), (23, 14, 3), (24, 15, 3),
(25, 16, 3), (26, 17, 3), (27, 18, 3), (28, 19, 3), (29, 20, 3),
(30, 1, 3), (31, 2, 3), (32, 3, 3), (33, 4, 3), (34, 5, 3),
(35, 6, 3), (36, 7, 3), (37, 8, 3), (38, 9, 3), (39, 10, 3),

-- tutorial (61–80)
(25, 16, 4), (26, 17, 4), (27, 1, 4), (28, 19, 4), (29, 20, 4),
(30, 1, 4), (31, 2, 4), (32, 3, 4), (33, 4, 4), (34, 5, 4),
(35, 6, 4), (36, 7, 4), (37, 8, 4), (38, 9, 4), (39, 10, 4),
(40, 11, 4), (41, 12, 4), (42, 13, 4), (43, 14, 4), (44, 15, 4),

-- overhead (81–100)
( 2, 1, 5), (1, 2, 5), (4, 3, 5), (1, 4, 5), (1, 5, 5),
( 5, 1, 5), (6, 7, 5), (7, 8, 5), (1, 9, 5), (1, 10, 5),
( 3, 11, 5), (1, 1, 5), (4, 13, 5), (3, 14, 5), (2, 15, 5),
( 6, 16, 5), (6, 17, 5), (7, 1, 5), (8, 19, 5), (2, 20, 5);

-- -------------------------------
-- EMPLOYEE_ACTIVITY
-- -------------------------------
INSERT INTO employee_activity (employment_id, planned_activity_id) VALUES
INSERT INTO employee_activity (employment_id, planned_activity_id) VALUES
-- lab 1–20
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15),
(16, 16), (17, 17), (18, 18), (19, 19), (20, 20),

-- lecture 21–40
(1, 21), (2, 22), (3, 23), (4, 24), (5, 25),
(6, 26), (7, 27), (8, 28), (9, 29), (10, 30),
(11, 31), (12, 32), (13, 33), (14, 34), (15, 35),
(16, 36), (17, 37), (18, 38), (19, 39), (20, 40),

-- seminar 41–60
(1, 41), (2, 42), (3, 43), (4, 44), (5, 45),
(6, 46), (7, 47), (8, 48), (9, 49), (10, 50),
(11, 51), (12, 52), (13, 53), (14, 54), (15, 55),
(16, 56), (17, 57), (18, 58), (19, 59), (20, 60),

-- tutorial 61–80
(1, 61), (2, 62), (3, 63), (4, 64), (5, 65),
(6, 66), (7, 67), (8, 68), (9, 69), (10, 70),
(11, 71), (12, 72), (13, 73), (14, 74), (15, 75),
(16, 76), (17, 77), (18, 78), (19, 79), (20, 80),

-- overhead 81–100
(1, 81), (2, 82), (3, 83), (4, 84), (5, 85),
(6, 86), (7, 87), (8, 88), (9, 89), (10, 90),
(11, 91), (12, 92), (13, 93), (14, 94), (15, 95),
(16, 96), (17, 97), (18, 98), (19, 99), (20, 100);
-- -------------------------------
-- PERSON_ADDRESS
-- -------------------------------
INSERT INTO person_address (person_id, address_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);

-- -------------------------------
-- SALARY_HISTORY
-- -------------------------------
INSERT INTO salary_history (monthly_salary_amount, from_date, to_date, employment_id) VALUES
-- Employees with a salary history (2 entries)
('65000', '2020-01-01', '2021-12-31', 1), 
('70000', '2022-01-01', NULL, 1),         
('70000', '2019-06-01', '2021-05-31', 2),
('75000', '2021-06-01', NULL, 2),         
('50000', '2019-01-01', '2020-12-31', 5),
('55000', '2021-01-01', NULL, 5),        
('58000', '2020-03-01', '2023-02-28', 10),
('62000', '2023-03-01', NULL, 10),        
('66000', '2021-01-01', '2022-12-31', 11),
('69000', '2023-01-01', NULL, 11),        
('48000', '2023-01-01', NULL, 3), 
('68000', '2022-01-01', NULL, 4),  
('56000', '2022-01-01', NULL, 6),  
('51000', '2022-01-01', NULL, 7),  
('45000', '2022-01-01', NULL, 8),  
('53000', '2022-01-01', NULL, 9), 
('50000', '2022-01-01', NULL, 12), 
('49000', '2022-01-01', NULL, 13), 
('67000', '2022-01-01', NULL, 14), 
('60000', '2022-01-01', NULL, 15),
('52000', '2022-01-01', NULL, 16), 
('51500', '2022-01-01', NULL, 17), 
('46000', '2022-01-01', NULL, 18),
('54000', '2022-01-01', NULL, 19),
('72000', '2022-01-01', NULL, 20); 


