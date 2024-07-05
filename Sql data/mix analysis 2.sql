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