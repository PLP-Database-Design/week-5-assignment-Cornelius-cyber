	-- USE hospital;
    USE hospital_db;
    
    
-- Basic Data Retrieval
-- 1.1 
SELECT first_name, last_name, date_of_birth FROM patients;

-- 1.2 
SELECT provider_id, first_name, provider_specialty FROM providers;

-- Pattern Based Retrieval
-- 2.1 : Patients first_name starts with "Ab"
SELECT * 
FROM patients
WHERE first_name LIKE 'Ab%';

-- 2.2: Providers specialties end with letter 'y'
SELECT *
FROM providers
WHERE provider_specialty LIKE '%y';

-- Comparison Operators
-- 3.1 
SELECT * 
FROM patients
WHERE date_of_birth > '1980-01-01';

-- 3.2
SELECT *
FROM ed_visits
WHERE acuity >= 2;

-- WHERE Clause with Logical Operators
-- 4.1
SELECT * 
FROM patients
WHERE language = 'Spanish';

-- 4.2 
SELECT *
FROM ed_visits
WHERE reason_for_visit = 'Migraine' AND ed_disposition = 'Admitted';
  
-- 4.3 
SELECT *
FROM patients
WHERE date_of_birth BETWEEN '1975-01-01' AND '1980-12-31';

-- Sorting Data
-- 5.1 
SELECT first_name, last_name
FROM patients
ORDER BY last_name ASC; 

-- 5.2 
SELECT *
FROM visits
ORDER BY date_of_visit DESC;


-- Advanced Filtering
-- 6.1
SELECT a.*
FROM admissions a
JOIN discharges d ON a.patient_id = d.patient_id
WHERE a.primary_diagnosis = 'Stroke'
  AND d.discharge_disposition = 'Home';
  
-- 6.2
SELECT *
FROM providers
WHERE date_joined > '1995-12-31'
  AND provider_specialty IN ('Pediatrics', 'Cardiology');

-- question 1.1
SELECT COUNT(*) AS total_admissions FROM admissions;
-- question 1.2
SELECT AVG(datediff(discharge_date, admission_date)) AS average_length_of_stay FROM admissions, discharges ;

-- question 2.1
SELECT primary_diagnosis, count(*) AS total_admissions FROM admissions GROUP BY primary_diagnosis;
-- question 2.2
SELECT service,avg(datediff(discharge_date, admission_date)) AS average_length_of_stay FROM admissions, discharges GROUP BY service;
-- question 2.3
SELECT discharge_disposition, count(*) AS discharge_count FROM discharges GROUP BY discharge_disposition;

-- question 3.1
SELECT service, COUNT(*) AS total_admissions 
FROM admissions 
GROUP BY service 
HAVING COUNT(*) > 5;

-- question 3.2
SELECT avg(datediff(discharge_date, admission_date)) AS average_length_of_stay FROM admissions, discharges WHERE primary_diagnosis = 'stroke';

-- question 4.1
SELECT acuity, count(*) AS total_visits FROM ed_visits GROUP BY acuity;
-- question 4.2
SELECT primary_diagnosis, service, count(*) AS total_admissions FROM admissions GROUP BY primary_diagnosis, service;

-- question 5.1
SELECT date_format(admission_date, '%Y-%M') AS admission_month,count(*) AS total_admissions FROM admissions group by admission_month;
-- question 5.2
SELECT primary_diagnosis, max(datediff(discharge_date, admission_date)) AS max_length_of_stay FROM admissions, discharges group by primary_diagnosis;

-- bonus challenge
SELECT a.service, 
       SUM(DATEDIFF(d.discharge_date, a.admission_date)) AS total_length_of_stay, 
       AVG(DATEDIFF(d.discharge_date, a.admission_date)) AS average_length_of_stay 
FROM admissions a 
JOIN discharges d ON a.patient_id = d.patient_id 
GROUP BY a.service 
ORDER BY average_length_of_stay DESC;

-- Week four 


-- Part 1: INSERT Data
INSERT INTO patients (first_name, last_name, date_of_birth, gender, language)
VALUES ('John', 'Doe', '1980-11-15', 'Male', 'English');

-- Part 2: UPDATE Data
UPDATE patients
SET language = 'Spanish'
WHERE first_name = 'John'
AND last_name = 'Doe';

-- Part 3: DELETE data
DELETE FROM patients
WHERE patient_id = 10;

-- Part 4: Handling NULL Values
-- 4.1 
SELECT first_name, last_name, 
				COALESCE(email_address, 'N/A') AS email_address
FROM providers;

-- 4.2 
SELECT first_name, last_name,
       COALESCE(phone_number, 'Missing details') AS phone_number,
       COALESCE(email_address, 'Missing details') AS email_address
FROM providers;

-- Bonus
SELECT *
FROM providers
WHERE provider_specialty = 'Pediatrics'
  AND (phone_number IS NULL OR email_address IS NULL);

