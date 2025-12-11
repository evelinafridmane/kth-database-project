-- This script contains all your original data, but with the
-- Foreign Key IDs (for job_title and course_layout) re-mapped
-- to match the new IDs created after "RESTART IDENTITY".

-- -------------------------------
-- ADDRESS
-- -------------------------------
TRUNCATE TABLE address RESTART IDENTITY CASCADE;
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
-- PERSON (IDs 1-20 created)
-- -------------------------------
TRUNCATE TABLE person RESTART IDENTITY CASCADE;
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
TRUNCATE TABLE phone_number RESTART IDENTITY CASCADE;
INSERT INTO phone_number (phone_nb, person_id) VALUES
('0704972835', 1), ('0701170952', 2), ('0708577626', 3), ('0707001915', 4), ('0701876138', 5),
('0701744056', 6), ('0701800121', 7), ('0704169736', 8), ('0705517867', 9), ('0703339570', 10),
('0707636931', 11), ('0703829417', 12), ('0701126724', 13), ('0702820493', 14), ('0706367444', 15),
('0701717955', 16), ('0705209512', 17), ('0705441941', 18), ('0707411053', 19), ('0708679152', 20);

-- -------------------------------
-- JOB_TITLE (IDs 1-10 created)
-- -------------------------------
TRUNCATE TABLE job_title RESTART IDENTITY CASCADE;
INSERT INTO job_title (job_title) VALUES
('Professor'), ('Lecturer'), ('Researcher'), ('Administrator'), ('Lab Assistant'),
('Course Coordinator'), ('Adjunct'), ('Technical Staff'), ('Postdoc'), ('Dean');

-- -------------------------------
-- DEPARTMENT (Must be populated *after* Employee)
-- -------------------------------
TRUNCATE TABLE department RESTART IDENTITY CASCADE;

INSERT INTO department (department_name, manager_id) VALUES
('Computer Science', NULL), ('Mathematics', NULL), ('Physics', NULL), ('Electrical Engineering', NULL), ('Mechanical Engineering', NULL),
('Civil Engineering', NULL), ('Architecture', NULL), ('Chemistry', NULL), ('Biotechnology', NULL), ('Industrial Management', NULL);

-- -------------------------------
-- EMPLOYEE (IDs 1-20 created)
-- -------------------------------
-- The job_id (3rd column) has been re-mapped:
-- Old IDs (21, 22, 23, 24, 25, 26, 27, 28, 29, 30)
-- New IDs ( 1,  2,  3,  4,  5,  6,  7,  8,  9, 10)


INSERT INTO employee (manager_id, person_id, job_id, department_id) VALUES
(NULL, 1, 5, 1),  -- Was 25
(1, 2, 10, 2), -- Was 30
(2, 3, 4, 3),  -- Was 24
(3, 4, 1, 4),  -- Was 21
(4, 5, 2, 5),  -- Was 22
(5, 6, 5, 6),  -- Was 25
(6, 7, 9, 7),  -- Was 29
(7, 8, 8, 8),  -- Was 28
(8, 9, 7, 9),  -- Was 27
(9, 10, 6, 10), -- Was 26
(10, 11, 4, 1), -- Was 24
(11, 12, 4, 2), -- Was 24
(12, 13, 3, 3), -- Was 23
(13, 14, 1, 4), -- Was 21
(14, 15, 6, 5), -- Was 26
(15, 16, 7, 6), -- Was 27
(16, 17, 7, 7), -- Was 27
(17, 18, 8, 8), -- Was 28
(18, 19, 9, 9), -- Was 29
(19, 20, 10, 10); -- Was 30

-- -------------------------------
-- DEPARTMENT (Now safe to insert)
-- -------------------------------
TRUNCATE TABLE department RESTART IDENTITY CASCADE;
INSERT INTO department (department_name, manager_id) VALUES
('Computer Science', 1), ('Mathematics', 2), ('Physics', 3), ('Electrical Engineering', 4), ('Mechanical Engineering', 5),
('Civil Engineering', 6), ('Architecture', 7), ('Chemistry', 8), ('Biotechnology', 9), ('Industrial Management', 10);

-- -------------------------------
-- SKILL
-- -------------------------------
TRUNCATE TABLE skill RESTART IDENTITY CASCADE;
INSERT INTO skill (skill_name, employment_id) VALUES
('Python', 1), ('Java', 2), ('C++', 3), ('Matlab', 4), ('R', 5), ('SQL', 6),
('Linux', 7), ('Public Speaking', 8), ('Data Analysis', 9), ('CAD', 10),
('Python', 11), ('Java', 12), ('C++', 13), ('Matlab', 14), ('R', 15), ('SQL', 16),
('Linux', 17), ('Public Speaking', 18), ('Data Analysis', 19), ('CAD', 20);

-- -------------------------------
-- COURSE_LAYOUT (IDs 1-23 created)
-- -------------------------------
TRUNCATE TABLE course_layout RESTART IDENTITY CASCADE;
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
-- TEACHING_ACTIVITY (IDs 1-4 created)
-- -------------------------------
TRUNCATE TABLE teaching_activity RESTART IDENTITY CASCADE;
INSERT INTO teaching_activity (activity_name, factor) VALUES
('Lab', 2.4), ('Lecture', 3.6), ('Seminar', 1.8), ('Tutorial', 1.8);

-- -------------------------------
-- COURSE_INSTANCE (IDs 1-20 created)
-- -------------------------------
-- The course_layout_id (4th column) has been re-mapped.
-- Old IDs (48, 49, 50, 51, 53, 54, 55, 56, 57, 59, 60, 61, 62, 63, 67)
-- New IDs ( 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15)
TRUNCATE TABLE course_instance RESTART IDENTITY CASCADE;
INSERT INTO course_instance (num_students, study_period, study_year, course_layout_id) VALUES
(25, 'P2', 2025, 4),  -- Was 51
(20, 'P1', 2022, 13), -- Was 62
(40, 'P3', 2023, 14), -- Was 63
(10, 'P4', 2024, 6),  -- Was 54
(25, 'P2', 2025, 7),  -- Was 55
(30, 'P2', 2022, 8),  -- Was 56
(15, 'P3', 2023, 9),  -- Was 57
(20, 'P4', 2024, 1),  -- Was 48
(20, 'P2', 2025, 2),  -- Was 49
(40, 'P2', 2022, 11), -- Was 60
(10, 'P3', 2023, 12), -- Was 61
(30, 'P4', 2024, 13), -- Was 62
(25, 'P1', 2025, 5),  -- Was 53
(10, 'P2', 2022, 6),  -- Was 54
(10, 'P3', 2023, 7),  -- Was 55
(30, 'P4', 2024, 8),  -- Was 56
(15, 'P2', 2025, 15), -- Was 67
(15, 'P2', 2022, 1),  -- Was 48
(30, 'P3', 2023, 10), -- Was 59
(30, 'P4', 2024, 3);  -- Was 50

-- -------------------------------
-- PLANNED_ACTIVITY (IDs 1-20 created)
-- -------------------------------
TRUNCATE TABLE planned_activity RESTART IDENTITY CASCADE;
INSERT INTO planned_activity (planned_nb_hours, instance_id, teaching_activity_id) VALUES
(10, 1, 1), (11, 2, 1), (12, 3, 1), (13, 4, 1), (14, 5, 1),
(15, 1, 2), (16, 7, 2), (17, 8, 2), (18, 9, 2), (19, 10, 2),
(20, 11, 3), (21, 1, 3), (22, 13, 3), (23, 14, 3), (24, 15, 3),
(25, 16, 4), (26, 17, 4), (27, 1, 4), (28, 19, 4), (29, 20, 4),(20, 1, 1) ;

-- -------------------------------
-- EMPLOYEE_ACTIVITY
-- -------------------------------
TRUNCATE TABLE employee_activity RESTART IDENTITY CASCADE;
INSERT INTO employee_activity (employment_id, planned_activity_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);

-- -------------------------------
-- PERSON_ADDRESS
-- -------------------------------
TRUNCATE TABLE person_address RESTART IDENTITY CASCADE;
INSERT INTO person_address (person_id, address_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);

TRUNCATE TABLE salary_history RESTART IDENTITY CASCADE;
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

