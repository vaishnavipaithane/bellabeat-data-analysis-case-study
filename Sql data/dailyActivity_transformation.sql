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

--Check if total steps are less 2000 in dailyActivity
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

SELECT
  FORMAT('%.2f', TotalDistance) AS Total_Distance,
  FORMAT('%.2f', TrackerDistance) AS Tracker_Distance,
  FORMAT('%.2f', VeryActiveDistance) AS VeryActive_Distance,
  FORMAT('%.2f', ModeratelyActiveDistance) AS ModerateltyActive_Distance,
  FORMAT('%.2f', LightActiveDistance) AS LightlyActive_Distance,
  FORMAT('%.2f', SedentaryActiveDistance) AS SedentaryActive_Distance
FROM `fast-lattice-419716.bellabeat.dailyActivity`; 

CREATE OR REPLACE TABLE `fast-lattice-419716.bellabeat.dailyActivity` AS
SELECT *,
    CASE EXTRACT(DAYOFWEEK FROM ActivityDate)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
        ELSE NULL
    END AS day_of_week
FROM `fast-lattice-419716.bellabeat.dailyActivity`;

