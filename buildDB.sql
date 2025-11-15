---------------------------------------------------------------------------------------------------------------------
--run this code if you're on terminal
-- switch to postgres database
--\c postgres;
-- drop and create database
--DROP DATABASE IF EXISTS university;
--CREATE DATABASE university;
--\c university;
---------------------------------------------------------------------------------------------------------------------
-- DROP OLD TABLES
DROP TABLE IF EXISTS address CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS phone_number CASCADE;
DROP TABLE IF EXISTS person_address CASCADE;

DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS job_title CASCADE;
DROP TABLE IF EXISTS salary_history CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS skill CASCADE;
DROP TABLE IF EXISTS employee_activity CASCADE;
---------------------------------------------------------------------------------------------------------------------
-- ENUM TYPES
CREATE TYPE STUDY_PERIOD AS ENUM ('P1', 'P2', 'P3', 'P4');
CREATE TYPE COUNTRY AS ENUM ('Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Antigua and Barbuda', 'Argentina', 'Armenia', 'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi', 'Côte d''Ivoire', 'Cabo Verde', 'Cambodia', 'Cameroon', 'Canada', 'Central African Republic', 'Chad', 'Chile', 'China', 'Colombia', 'Comoros', 'Congo (Congo-Brazzaville)', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czechia (Czech Republic)', 'Democratic Republic of the Congo', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia', 'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti', 'Holy See', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kiribati', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar (formerly Burma)', 'Namibia', 'Nauru', 'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Korea', 'North Macedonia', 'Norway', 'Oman', 'Pakistan', 'Palau', 'Palestine State', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia', 'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom', 'United States of America', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Venezuela', 'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe');
---------------------------------------------------------------------------------------------------------------------
-- PERSON PART OF THE MODEL
CREATE TABLE address (
  address_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY, --syntax to comply with SQL standard instead of SERIAL
  street_name VARCHAR(300) NOT NULL,
  zip VARCHAR(300) NOT NULL,
  city VARCHAR(300) NOT NULL,
  country COUNTRY NOT NULL
);

CREATE TABLE person (
  person_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  personal_number VARCHAR(12) UNIQUE NOT NULL,
  first_name VARCHAR(300) NOT NULL,
  last_name VARCHAR(300) NOT NULL
);

CREATE TABLE person_address (
  person_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (person_id, address_id),
  FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE RESTRICT ON UPDATE RESTRICT, --force user to update the db
  FOREIGN KEY (address_id) REFERENCES address(address_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE phone_number (
  phone_nb VARCHAR(10) NOT NULL,
  person_id INT NOT NULL,
  PRIMARY KEY (phone_nb, person_id),
  FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
---------------------------------------------------------------------------------------------------------------------
--EMPLOYEE PART OF THE MODEL
CREATE TABLE employee (
	employment_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	manager_id INT, --can be NULL if you have no manager
	person_id INT NOT NULL,
	job_id INT NOT NULL,
	department_id INT NOT NULL,
	FOREIGN KEY (manager_id) REFERENCES employee(employment_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE 	RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY (job_id) REFERENCES job_title(job_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE job_title (
	job_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	job_title VARCHAR(300)
);

CREATE TABLE salary_history(
	salary_history_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	monthly_salary_amount VARCHAR(300),
	from_date TIMESTAMPTZ NOT NULL,
	to_date TIMESTAMPTZ, --can be Null
	employment_id INT NOT NULL,
	FOREIGN KEY (employment_id) REFERENCES employee(employment_id) ON DELETE RESTRICT ON UPDATE RESTRICT,

);

CREATE TABLE department(
	department_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	department_name VARCHAR(300) UNIQUE NOT NULL,
	manager_id INT NOT NULL,
	FOREIGN KEY (manager_id) REFERENCES employee(employment_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE skill(
	skill_name VARCHAR(300) NOT NULL,
	employment_id INT NOT NULL,
	PRIMARY KEY (skill_name, employment_id),
	FOREIGN KEY (employment_id) REFERENCES employee(employment_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

CREATE TABLE employee_activity (
	employment_id INT NOT NULL,
	planned_activity_id INT NOT NULL,
	PRIMARY KEY(employment_id, planned_activity_id),
	FOREIGN KEY (employment_id) REFERENCES employee(employment_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	FOREIGN KEY (planned_activity_id) REFERENCES planned_activity(planned_activity_id) ON DELETE RESTRICT ON UPDATE RESTRICT
);
