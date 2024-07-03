# bellabeat-data-analysis-case-study

## Introduction

Welcome to my capstone project for the Google Data Analytics Certificate course.

Bellabeat, a high-tech manufacturer of health-focused products for women, is a successful small company with the potential to become a larger player in the global smart device market. Urška Sršen, cofounder and Chief Creative Officer of Bellabeat, believes that analyzing smart device fitness data could unlock new growth opportunities for the company.

As a junior data analyst, my task is to focus on one of Bellabeat’s products and analyze smart device data to gain insights into how consumers are using their smart devices. These insights will then help guide the company’s marketing strategy. I will present my analysis to the Bellabeat executive team, along with high-level recommendations for their marketing strategy.

## Ask

Sršen asks you to analyze smart device usage data to gain insight into how consumers use non-Bellabeat smart devices. She then wants you to select one Bellabeat product to apply these insights to in your presentation. 

These questions will guide your analysis:
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?

Stakeholders:
- Urška Sršen - Bellabeat cofounder and Chief Creative Officer
- Sando Mur - Bellabeat cofounder and key member of Bellabeat executive team
- Bellabeat Marketing Analytics team

## Prepare

The dataset used for this case study is [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) The dataset is stored in Kaggle and made available through [Mobius](https://www.kaggle.com/arashnic) This Kaggle data set contains personal fitness tracker from thirty fitbit users. Thirty eligible Fitbit users consented to the submission of personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes information about daily activity, steps, and heart rate that can be used to explore users’ habits.

- The Fitbit Fitness Tracker data was collected in 2016, making it outdated for current trend analysis.
- The data was collected over only a 31-day period (April 12, 2016, to May 12, 2016).
- The data source includes information from only 33 Fitbit tracker users, which is a small sample size and less representative for our analysis.
- Bellabeat products are targeted at women, but the dataset does not provide information about gender or other demographic details.

I have used BigQuery offered by Google Cloud to process and analyze the data. For visualizations, I have used Tableau Public. To address this business task, only 2 out of the 18 provided datasets were used. Data was provided in csv format.

- dailyActivity_merged which contains data on Activity, Distance, Calories, Steps (combined from 3 separate files named dailyIntensities, dailyCalories and dailySteps)
- sleepDay_merged which contains data on sleep

## Process

Before we start analyzing, it is necessary to ensure the data is clean, error-free, and in the right format. In the BigQuery console, I created a new dataset named 'bellabeat' and imported the CSV files.

1. Processing data from dailyActivity table

```sql
--check the number of rows, number of users, start and end date in dailyActivity
SELECT
  COUNT(*) AS Number_of_rows,
  COUNT(DISTINCT Id) AS Number_of_users,
  MIN(ActivityDate) AS start_date,
  MAX(ActivityDate) AS end_date
FROM `fast-lattice-419716.bellabeat.dailyActivity`;

--check for duplicates in dailyActivity
SELECT Id, ActivityDate, TotalSteps, 
COUNT(*)
FROM `fast-lattice-419716.bellabeat.dailyActivity`
GROUP BY id, ActivityDate, TotalSteps
HAVING COUNT(*) > 1;

--Check if total steps are less than 2000 in dailyActivity
SELECT
  Id,
  COUNT(*) as number_of_steps_less_than_2000
FROM `fast-lattice-419716.bellabeat.dailyActivity`
WHERE 
TotalSteps <= 2000
GROUP BY Id
ORDER BY number_of_steps_less_than_2000 DESC;

-- Delete all rows that contain less than 2000 total steps
DELETE FROM `fast-lattice-419716.bellabeat.dailyActivity`
WHERE TotalSteps <= 2000;
```

2. Processing data from sleepDay table

```sql
--check the number of rows, number of users, start and end date in sleepDay
SELECT
  COUNT(*) AS Number_of_rows,
  COUNT(DISTINCT Id) AS Number_of_users,
  MIN(SleepDay) AS start_date,
  MAX(SleepDay) AS end_date
FROM `fast-lattice-419716.bellabeat.sleepDay`;

--check for duplicates in sleepDay
SELECT Id, SleepDay, 
COUNT(*) AS number_of_id
FROM `fast-lattice-419716.bellabeat.sleepDay`
GROUP BY id, SleepDay
HAVING Count(*) > 1; --there are 3 duplicate rows in the dataset

--remove duplicates in sleepDay
CREATE OR REPLACE TABLE `fast-lattice-419716.bellabeat.sleepDay` AS
SELECT DISTINCT Id, SleepDay, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
FROM `fast-lattice-419716.bellabeat.sleepDay`;

--Verify the number of rows
SELECT COUNT(*) AS row_count FROM `fast-lattice-419716.bellabeat.sleepDay`; --duplicates removed (410 rows)
```

- The 'Id' column represents the number of unique users. The dailyActivity table contains 33 distinct IDs, whereas the sleepDay table has only 24 distinct IDs, which is not a sufficient sample size.
- Both tables record data for 31 days. They have the same start and end date: start 2016-04-12 and end 2016-05-12.
- The dailyActivity table has 940 records, while the sleepDay table has only 413 records.
- In the dailyActivity table, steps below 2000 were removed, as this likely indicates that the user did not wear the device for the entire day or the battery died.
- Duplicates were removed from the sleepDat table (410 records).

## Data Analysis and Visualization

The datasets contain multiple parameters that will assist in identifying patterns and drawing conclusions.

**1. Percentage of users that use smart device**

We calculate the percentage of users who use their smart device on a daily basis for both activities and sleep. Users are classified into three usage categories:

- Active: Users who use their device between 25 and 31 days.
- Moderate: Users who use their device between 15 and 24 days.
- Light: Users who use their device less than 15 days.

```sql
--Merge datasets
WITH merged_data AS (
  SELECT
    a.Id,
    a.ActivityDate AS date
  FROM `fast-lattice-419716.bellabeat.dailyActivity` a
  INNER JOIN `fast-lattice-419716.bellabeat.sleepDay` s
  ON a.Id = s.Id AND a.ActivityDate = s.SleepDay
),
--number of days per user
days_per_user AS (
  SELECT
    Id,
    COUNT(DISTINCT date) AS days_count
  FROM merged_data
  GROUP BY Id
),
--classify users into usage range
usage AS (
  SELECT
    Id,
    days_count,
    CASE
      WHEN days_count BETWEEN 25 AND 31 THEN 'active'
      WHEN days_count BETWEEN 15 AND 24 THEN 'moderate'
      ELSE 'light'
    END AS user_type
  FROM days_per_user
)
--percentage of users in each range
SELECT
  user_type,
  COUNT(*) * 100 / (SELECT COUNT(*) FROM usage) AS percentage_of_users
FROM usage
GROUP BY user_type;
```






  










