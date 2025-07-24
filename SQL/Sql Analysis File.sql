create database healthlens;
use healthlens;

# Remove Safe mode
SET SQL_SAFE_UPDATES = 0;

#Rename column name to meaningful Column Name and change datatype
ALTER TABLE heart_cleveland_upload
MODIFY sex VARCHAR(10); 

Alter table heart_cleveland_upload
Change cp Chest_Pain_Type Varchar(20);

Alter table heart_cleveland_upload
Change trestbps Resting_BP int;

Alter table heart_cleveland_upload
Change fbs Fasting_Blood_Sugar Varchar(10);

Alter Table heart_cleveland_upload
Change restecg resting_electrocardiographic_results Varchar(20);

Alter table heart_cleveland_upload
Change thalach Max_Heart_Rate int;

Alter table heart_cleveland_upload
Change exang exercise_induced_angina varchar(5);

Alter table heart_cleveland_upload
Modify slope varchar(20);

Alter table heart_cleveland_upload
Modify thal varchar(10);

Alter table heart_cleveland_upload
Modify `condition` varchar(10);

# Update sex column
Update heart_cleveland_upload
set sex = 'Male'
where sex = '1';

Update heart_cleveland_upload
set sex = 'Female'
where sex = '0';

# Update cp column 
Update heart_cleveland_upload
set Chest_Pain_Type = 'Typical Angina'
where Chest_Pain_Type = '0';

Update heart_cleveland_upload
set Chest_Pain_Type = 'Atypical Angina'
where Chest_Pain_Type = '1';

Update heart_cleveland_upload
set Chest_Pain_Type = 'Non-Anginal Pain'
where Chest_Pain_Type = '2';

Update heart_cleveland_upload
set Chest_Pain_Type = 'Asymptomatic'
where Chest_Pain_Type = '3';

# Update fbs Column
Update heart_cleveland_upload
Set Fasting_Blood_Sugar = 'True'
where Fasting_Blood_Sugar = '1';

Update heart_cleveland_upload
Set Fasting_Blood_Sugar = 'False'
where Fasting_Blood_Sugar = '0';

# Update restecg column
Update heart_cleveland_upload
Set resting_electrocardiographic_results = 'Normal'
where resting_electrocardiographic_results = '0';

Update heart_cleveland_upload
Set resting_electrocardiographic_results = 'ST-T wave'
where resting_electrocardiographic_results = '1';

Update heart_cleveland_upload
Set resting_electrocardiographic_results = 'LVH-positive'
where resting_electrocardiographic_results = '2';

# Update exang column
Update heart_cleveland_upload
set exercise_induced_angina = 'Yes'
where exercise_induced_angina = '1';

Update heart_cleveland_upload
set exercise_induced_angina = 'No'
where exercise_induced_angina = '0';

# Update Slope column
Update heart_cleveland_upload
set slope = 'upslopping'
where slope = '0';

Update heart_cleveland_upload
set slope = 'flat'
where slope = '1';

Update heart_cleveland_upload
set slope = 'downsloping'
where slope = '2';

# update thal Column
Update heart_cleveland_upload
set thal = 'Normal'
where thal = '0';

Update heart_cleveland_upload
set thal = 'Fixed defect'
where thal = '1';

Update heart_cleveland_upload
set thal = 'Reversable'
where thal = '2';

# Update Condition Column
Update heart_cleveland_upload
set `condition` = 'no disease'
where `condition` = '0';

Update heart_cleveland_upload
set `condition` = 'disease'
where `condition` = '1';

select * from heart_cleveland_upload;

# What factors (age, gender, cholesterol, etc.) are associated with heart disease?
SELECT
	sex,
  `condition`,
  AVG(age) AS avg_age,
  AVG(Resting_BP) AS avg_resting_bp,
  AVG(chol) AS avg_cholesterol,
  AVG(Max_Heart_Rate) AS avg_max_heart_rate,
  AVG(oldpeak) AS avg_st_depression
FROM heart_cleveland_upload
GROUP BY sex, `condition`;

# Is there a significant difference in heart disease presence between male and female patients?
SELECT 
  sex,
  `condition`,
  COUNT(*) AS count
FROM heart_cleveland_upload
GROUP BY sex, `condition`
ORDER BY sex, `condition`;

# Does maximum heart rate (thalach) differ by age group or disease status?
SELECT
  CASE
    WHEN age < 40 THEN '<40'
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    WHEN age BETWEEN 50 AND 59 THEN '50-59'
    WHEN age BETWEEN 60 AND 69 THEN '60-69'
    ELSE '70+'
  END AS age_group,
  `condition`,
  COUNT(*) AS count,
  ROUND(AVG(Max_Heart_Rate), 1) AS avg_thalach
FROM heart_cleveland_upload
GROUP BY age_group, `condition`
ORDER BY age_group, `condition`;

# Is fasting blood sugar related to heart condition?
SELECT 
  Fasting_Blood_Sugar,
  COUNT(*) AS total,
  SUM(CASE WHEN `condition` = 'disease' THEN 1 ELSE 0 END) AS with_disease,
  ROUND(SUM(CASE WHEN `condition` = 'disease' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_with_disease
FROM heart_cleveland_upload
GROUP BY Fasting_Blood_Sugar;

# What is the relationship between chest pain type and heart disease risk?
SELECT 
  Chest_Pain_Type,
  COUNT(*) AS total,
  SUM(CASE WHEN `condition` = 'disease' THEN 1 ELSE 0 END) AS with_disease,
  ROUND(SUM(CASE WHEN `condition` = 'disease' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_with_disease
FROM heart_cleveland_upload
GROUP BY Chest_Pain_Type
ORDER BY Chest_Pain_Type;

# Is there a relationship between exercise-induced angina (exang) and heart disease?
SELECT 
  exercise_induced_angina,
  `condition`,
  COUNT(*) AS count
FROM heart_cleveland_upload
GROUP BY exercise_induced_angina, `condition`
ORDER BY exercise_induced_angina, `condition`;

# How does ST depression (oldpeak) differ between people with and without heart disease?
SELECT 
  `condition`,
  ROUND(AVG(oldpeak), 2) AS avg_oldpeak,
  COUNT(*) AS count
FROM heart_cleveland_upload
GROUP BY `condition`;