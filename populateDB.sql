TRUNCATE TABLE address RESTART IDENTITY CASCADE;
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

TRUNCATE TABLE person RESTART IDENTITY CASCADE;
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

TRUNCATE TABLE phone_number RESTART IDENTITY CASCADE;
-- -------------------------------
-- PHONE_NUMBER
-- -------------------------------
INSERT INTO phone_number (phone_nb, person_id) VALUES
('0704972835', 1), ('0701170952', 2), ('0708577626', 3), ('0707001915', 4), ('0701876138', 5),
('0701744056', 6), ('0701800121', 7), ('0704169736', 8), ('0705517867', 9), ('0703339570', 10),
('0707636931', 11), ('0703829417', 12), ('0701126724', 13), ('0702820493', 14), ('0706367444', 15),
('0701717955', 16), ('0705209512', 17), ('0705441941', 18), ('0707411053', 19), ('0708679152', 20);

TRUNCATE TABLE job_titles RESTART IDENTITY CASCADE;
-- -------------------------------
-- JOB_TITLE
-- -------------------------------
INSERT INTO job_title (job_title) VALUES
('Professor'), ('Lecturer'), ('Researcher'), ('Administrator'), ('Lab Assistant'),
('Course Coordinator'), ('Adjunct'), ('Technical Staff'), ('Postdoc'), ('Dean');

TRUNCATE TABLE employee RESTART IDENTITY CASCADE;
-- -------------------------------
-- EMPLOYEE
-- -------------------------------
INSERT INTO employee (manager_id, person_id, job_id, department_id) VALUES
(NULL, 1, 25, 1), (1, 2, 30, 2), (2, 3, 24, 3), (3, 4, 21, 4), (4, 5, 22, 5),
(5, 6, 25, 6), (6, 7, 29, 7), (7, 8, 28, 8), (8, 9, 27, 9), (9, 10, 26, 10),
(10, 11, 24, 1), (11, 12, 24, 2), (12, 13, 23, 3), (13, 14, 21, 4), (14, 15, 26, 5),
(15, 16, 27, 6), (16, 17, 27, 7), (17, 18, 28, 8), (18, 19, 29, 9), (19, 20, 30, 10);

TRUNCATE TABLE department RESTART IDENTITY CASCADE;
-- -------------------------------
-- DEPARTMENT
-- -------------------------------
INSERT INTO department (department_name, manager_id) VALUES
('Computer Science', 1), ('Mathematics', 2), ('Physics', 3), ('Electrical Engineering', 4), ('Mechanical Engineering', 5),
('Civil Engineering', 6), ('Architecture', 7), ('Chemistry', 8), ('Biotechnology', 9), ('Industrial Management', 10);

TRUNCATE TABLE skill RESTART IDENTITY CASCADE;
-- -------------------------------
-- SKILL
-- -------------------------------
INSERT INTO skill (skill_name, employment_id) VALUES
('Python', 1), ('Java', 2), ('C++', 3), ('Matlab', 4), ('R', 5), ('SQL', 6),
('Linux', 7), ('Public Speaking', 8), ('Data Analysis', 9), ('CAD', 10),
('Python', 11), ('Java', 12), ('C++', 13), ('Matlab', 14), ('R', 15), ('SQL', 16),
('Linux', 17), ('Public Speaking', 18), ('Data Analysis', 19), ('CAD', 20);

TRUNCATE TABLE course_layout RESTART IDENTITY CASCADE;
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

TRUNCATE TABLE teaching_activity RESTART IDENTITY CASCADE;
-- -------------------------------
-- TEACHING_ACTIVITY
-- -------------------------------
INSERT INTO teaching_activity (activity_name, factor) VALUES
('Lab', 2.4), ('Lecture', 3.6), ('Seminar', 1.8), ('Tutorial', 1.8);

--other possibilities:
--('Group Work', 1.02), ('Project Supervision', 1.99),
--('Exam', 1.63), ('Demo', 1.23), ('Hackathon', 1.28), ('Workshop', 1.06), ('Guest Lecture', 0.58);

TRUNCATE TABLE course_instance RESTART IDENTITY CASCADE;
-- -------------------------------
-- COURSE_INSTANCE
-- -------------------------------
INSERT INTO course_instance (num_students, study_period, study_year, course_layout_id) VALUES
(25, 'P1', 2021, 51), (20, 'P2', 2022, 62), (40, 'P3', 2023, 63), (10, 'P4', 2024, 54),
(25, 'P1', 2021, 55), (30, 'P2', 2022, 56), (15, 'P3', 2023, 57), (20, 'P4', 2024, 48),
(20, 'P1', 2021, 49), (40, 'P2', 2022, 60), (10, 'P3', 2023, 61), (30, 'P4', 2024, 62),
(25, 'P1', 2021, 53), (10, 'P2', 2022, 54), (10, 'P3', 2023, 55), (30, 'P4', 2024, 56),
(15, 'P1', 2021, 67), (15, 'P2', 2022, 48), (30, 'P3', 2023, 59), (30, 'P4', 2024, 50);

TRUNCATE TABLE planned_activity RESTART IDENTITY CASCADE;
-- -------------------------------
-- PLANNED_ACTIVITY
-- -------------------------------
INSERT INTO planned_activity (planned_nb_hours, instance_id, teaching_activity_id) VALUES
(10, 1, 1), (11, 2, 1), (12, 3, 1), (13, 4, 1), (14, 5, 1),
(15, 6, 2), (16, 7, 2), (17, 8, 2), (18, 9, 2), (19, 10, 2),
(20, 11, 3), (21, 12, 3), (22, 13, 3), (23, 14, 3), (24, 15, 3),
(25, 16, 4), (26, 17, 4), (27, 18, 4), (28, 19, 4), (29, 20, 4);

TRUNCATE TABLE employee_activity RESTART IDENTITY CASCADE;
-- -------------------------------
-- EMPLOYEE_ACTIVITY
-- -------------------------------
INSERT INTO employee_activity (employment_id, planned_activity_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);

TRUNCATE TABLE person_address RESTART IDENTITY CASCADE;
-- -------------------------------
-- PERSON_ADDRESS
-- -------------------------------
INSERT INTO person_address (person_id, address_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);
