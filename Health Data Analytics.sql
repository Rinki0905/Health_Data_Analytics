 -- 1.Count & Pct of Female Vs Male that have OCD & -- Average Obsession Score by Gender
 with data as (
 SELECT
 
 Gender,
 count('Patient ID') as patient_count,
 avg(`Y-BOCS Score (Obsessions)`) as avg_obs_score
 
 FROM rinkdb.ocd_patient_dataset
 Group By 1
 Order by 2
 )
 
 select
	sum(case when Gender = 'Female' then patient_count else 0 end) as count_female,
	sum(case when Gender = 'Male' then patient_count else 0 end) as count_male,

	round(sum(case when Gender = 'Female' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+sum(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 as pct_female,

    round(sum(case when Gender = 'Male' then patient_count else 0 end)/
	(sum(case when Gender = 'Female' then patient_count else 0 end)+sum(case when Gender = 'Male' then patient_count else 0 end)) *100,2)
	 as pct_male

from data
;
# -- 2. Count of Patients by Ethnicity and their respective Average Obsession Score

select
	Ethnicity,
	count(`Patient ID`) as patient_count,
	avg(`Y-BOCS Score (Obsessions)`) as obs_score
From rinkdb.ocd_patient_dataset
Group by 1
Order by 2;

# -- 3. Number of people diagnosed with OCD MoM

# -- alter table health_data.ocd_patient_dataset
# -- modify `OCD Diagnosis Date` date;
select
date_format(`OCD Diagnosis Date`, '%Y-%m-01 00:00:00') as month,
-- `OCD Diagnosis Date`
count(`Patient ID`) patient_count
from rinkdb.ocd_patient_dataset
group by 1
Order by 1
;
 # -- 4. What is the most common Obsession Type (Count) & it's respective Average Obsession Score

Select
`Obsession Type`,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as obs_score
from rinkdb.ocd_patient_dataset
group by 1
Order by 2
;

# -- 5. What is the most common Compulsion type (Count) & it's respective Average Obsession Score

Select
`Compulsion Type`,
count(`Patient ID`) as patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as obs_score
from rinkdb.ocd_patient_dataset
group by 1
Order by 2
;
-- Gender Distribution
SELECT Gender, COUNT(*) AS Patient_Count
FROM rinkdb.ocd_patient_dataset
GROUP BY Gender;

-- Average OCD Symptom Duration by Gender
SELECT Gender, AVG(`Duration of Symptoms (months)`) AS Avg_Duration
FROM rinkdb.ocd_patient_dataset
GROUP BY Gender;

--  Average Y-BOCS Score (Combined)
SELECT 
  AVG(`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Avg_Total_YBOCS
FROM rinkdb.ocd_patient_dataset;
-- Severity Classification Based on Y-BOCS
SELECT
  `Patient ID`,
  (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Total_YBOCS,
  CASE
    WHEN (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) >= 24 THEN 'Severe'
    WHEN (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) BETWEEN 16 AND 23 THEN 'Moderate'
    WHEN (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) BETWEEN 8 AND 15 THEN 'Mild'
    ELSE 'Subclinical'
  END AS Severity
FROM `rinkdb`.`ocd_patient_dataset`
LIMIT 1000;
--  Count of Patients With Family History of OCD
SELECT `Family History of OCD`, COUNT(*) AS Count
FROM rinkdb.ocd_patient_dataset
GROUP BY `Family History of OCD`;

-- Most Common Obsession Types
SELECT `Obsession Type`, COUNT(*) AS Count
FROM rinkdb.ocd_patient_dataset
GROUP BY `Obsession Type`
ORDER BY Count DESC
LIMIT 5;
-- Most Common Compulsion Types
SELECT `Compulsion Type`, COUNT(*) AS Count
FROM rinkdb.ocd_pateint_dataset
GROUP BY `Compulsion Type`
ORDER BY Count DESC
LIMIT 5;
-- Correlation Insight: Average Y-BOCS Score by Education Level
SELECT `Education Level`,
  AVG(`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Avg_YBOCS
FROM rinkdb.ocd_patient_dataset
GROUP BY `Education Level`
ORDER BY Avg_YBOCS DESC;

-- Number of Patients on Medication
SELECT Medications, COUNT(*) AS Count
FROM rinkdb.ocd_patient_dataset
GROUP BY Medications
ORDER BY Count DESC;

-- Patients with Both Depression and Anxiety Diagnoses
SELECT COUNT(*) AS Count
FROM rinkdb.ocd_patient_dataset
WHERE `Depression Diagnosis` = 'Yes'
  AND `Anxiety Diagnosis` = 'Yes';
  
  -- Average Symptom Duration by Marital Status
  SELECT `Marital Status`, AVG(`Duration of Symptoms (months)`) AS Avg_Duration
FROM rinkdb.ocd_patient_dataset
GROUP BY `Marital Status`;

-- . Highest Y-BOCS Scoring Patients
SELECT `Patient ID`, 
  `Y-BOCS Score (Obsessions)`, 
  `Y-BOCS Score (Compulsions)`,
  (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Total_YBOCS
FROM rinkdb.ocd_patient_dataset
ORDER BY Total_YBOCS DESC
LIMIT 10;

--  Obsession Type vs. Average Y-BOCS Score
SELECT `Obsession Type`,
  AVG(`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Avg_YBOCS
FROM rinkdb.ocd_patient_dataset
GROUP BY `Obsession Type`
ORDER BY Avg_YBOCS DESC;

--  Average Y-BOCS by Presence of Family History
SELECT `Family History of OCD`,
  AVG(`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Avg_YBOCS
FROM rinkdb.ocd_patient_dataset
GROUP BY `Family History of OCD`;

-- Rank Patients by Total Y-BOCS Score
SELECT `Patient ID`,
  `Y-BOCS Score (Obsessions)`,
  `Y-BOCS Score (Compulsions)`,
  RANK() OVER (ORDER BY (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) DESC) AS Severity_Rank
FROM rinkdb.ocd_patient_dataset;

-- Grouping Patients by OCD Duration
SELECT
  CASE
    WHEN `Duration of Symptoms (months)` < 6 THEN 'Less than 6 months'
    WHEN `Duration of Symptoms (months)` BETWEEN 6 AND 12 THEN '6–12 months'
    WHEN `Duration of Symptoms (months)` BETWEEN 13 AND 36 THEN '1–3 years'
    ELSE 'More than 3 years'
  END AS Duration_Group,
  COUNT(*) AS Patient_Count
FROM rinkdb.ocd_patient_dataset
GROUP BY Duration_Group;

-- Ethnicity Distribution
SELECT Ethnicity, COUNT(*) AS Count
FROM rinkdb.ocd_patient_dataset
GROUP BY Ethnicity
ORDER BY Count DESC;

-- Highest Y-BOCS Scorers per Education Level
SELECT `Education Level`, MAX(`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Max_Score
FROM rinkdb.ocd_patient_dataset
GROUP BY `Education Level`;

-- Patients Without Prior Diagnoses
SELECT COUNT(*) AS FirstTime_Diagnosed
FROM rinkdb.ocd_patient_dataset
WHERE `Previous Diagnoses` = 'None' OR `Previous Diagnoses` IS NULL;


-- Y-BOCS Severity by Education Level
-- Concepts: Subqueries, Aggregation, Filtering
SELECT `Education Level`, 
       AVG(`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Avg_YBOCS
FROM rinkdb.ocd_patient_dataset
WHERE (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) > 
      (SELECT AVG(`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) FROM rinkdb.ocd_patient_dataset)
GROUP BY `Education Level`
ORDER BY Avg_YBOCS DESC;

-- Most Common Compulsion per Obsession Type
-- Concepts: GROUP BY, COUNT, RANK
SELECT t1.`Obsession Type`, t1.`Compulsion Type`, t1.cnt
FROM (
  SELECT `Obsession Type`, `Compulsion Type`, COUNT(*) AS cnt
  FROM rinkdb.ocd_patient_dataset
  GROUP BY `Obsession Type`, `Compulsion Type`
) t1
JOIN (
  SELECT `Obsession Type`, MAX(cnt) AS max_cnt
  FROM (
    SELECT `Obsession Type`, `Compulsion Type`, COUNT(*) AS cnt
    FROM rinkdb.ocd_patient_dataset
    GROUP BY `Obsession Type`, `Compulsion Type`
  ) t2
  GROUP BY `Obsession Type`
) t3
ON t1.`Obsession Type` = t3.`Obsession Type` AND t1.cnt = t3.max_cnt;


-- Time Since OCD Diagnosis in Months
-- Concepts: Date difference logic
SELECT DISTINCT `OCD Diagnosis Date` FROM rinkdb.ocd_patient_dataset;

SELECT 
  `Patient ID`, 
  TIMESTAMPDIFF(
    MONTH, 
    STR_TO_DATE(`OCD Diagnosis Date`, '%Y-%m-%d'), 
    CURDATE()
  ) AS Months_Since_Diagnosis
FROM rinkdb.ocd_patient_dataset;

-- Rank Patients by Y-BOCS within Education Level
SELECT `Patient ID`, `Education Level`,
       (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) AS Total_YBOCS,
       RANK() OVER (PARTITION BY `Education Level` ORDER BY 
                    (`Y-BOCS Score (Obsessions)` + `Y-BOCS Score (Compulsions)`) DESC) AS Rank_in_Group
FROM rinkdb.ocd_patient_dataset;














