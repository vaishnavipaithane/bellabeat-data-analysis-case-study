SELECT
  Id,
  AVG(TotalMinutesAsleep)/60 AS avg_asleep_hours
FROM `fast-lattice-419716.bellabeat.sleepDay`
GROUP BY Id;

--Average sleep and calories burned by users
WITH avg_sleep AS (
  --Average asleep hours of users
  SELECT
    Id,
    AVG(TotalMinutesAsleep)/60 AS avg_asleep_hours
    FROM `fast-lattice-419716.bellabeat.sleepDay`
  GROUP BY Id
),
avg_calories AS (
  --Average calories burned by users
  SELECT
    Id,
    AVG(Calories) AS avg_calories_burned
  FROM `fast-lattice-419716.bellabeat.dailyActivity`
  GROUP BY Id
)
SELECT
  s.Id,
  s.avg_asleep_hours,
  c.avg_calories_burned
FROM avg_sleep s
INNER JOIN avg_calories c
ON s.Id = c.Id;