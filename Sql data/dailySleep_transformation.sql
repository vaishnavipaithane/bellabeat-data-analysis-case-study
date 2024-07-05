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









