WITH avg_activity AS (
  -- Average daily activity of users
  SELECT 
    Id,
    AVG(VeryActiveMinutes) AS avg_very_active_mins,
    AVG(FairlyActiveMinutes) AS avg_fairly_active_mins,
    AVG(LightlyActiveMinutes) AS avg_lightly_active_mins,
    AVG(SedentaryMinutes) AS avg_sedentary_mins
  FROM `fast-lattice-419716.bellabeat.dailyActivity`
  GROUP BY Id
),
avg_steps AS (
  -- Average daily steps of users
  SELECT
    Id,
    AVG(TotalSteps) AS avg_total_steps,
    CASE
      WHEN AVG(TotalSteps) < 5000 THEN 'Sedentary'
      WHEN AVG(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Lightly Active'
      WHEN AVG(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Moderately Active'
      WHEN AVG(TotalSteps) BETWEEN 10000 AND 12499 THEN 'Fairly Active'
      WHEN AVG(TotalSteps) > 12500 THEN 'Highly Active'
    END AS activity_level
  FROM `fast-lattice-419716.bellabeat.dailyActivity`
  GROUP BY Id
),
avg_calories AS(
  --Average caloried burned by users
  SELECT
    Id,
    AVG(Calories) AS avg_calories_burned
  FROM fast-lattice-419716.bellabeat.dailyActivity
  GROUP BY Id
)

-- Join the four CTEs based on Id
SELECT 
  a.Id,
  a.avg_very_active_mins,
  a.avg_fairly_active_mins,
  a.avg_lightly_active_mins,
  a.avg_sedentary_mins,
  s.avg_total_steps,
  s.activity_level,
  c.avg_calories_burned
FROM avg_activity a
JOIN avg_steps s ON a.Id = s.Id
JOIN avg_calories c ON a.Id = c.Id;


