--Average activity of users
SELECT Id,
  AVG(VeryActiveMinutes) AS avg_very_active_mins,
  AVG(FairlyActiveMinutes) AS avg_fairly_active_mins,
  AVG(LightlyActiveMinutes) AS avg_lightly_active_mins,
  AVG(SedentaryMinutes) AS avg_sedentary_mins
FROM `fast-lattice-419716.bellabeat.dailyActivity`
GROUP BY Id;

--Average steps of users
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
GROUP BY Id;

--Average total/tracked distance of users
SELECT
  Id,
  AVG(TotalDistance) AS avg_total_distance
FROM `fast-lattice-419716.bellabeat.dailyActivity`
GROUP BY Id;

--Average caloried burned by users
SELECT
  Id,
  AVG(Calories) AS avg_calories_burned
FROM `fast-lattice-419716.bellabeat.dailyActivity`
GROUP BY Id;

--Average steps per day of week
SELECT
  day_of_week,
  AVG(TotalSteps) AS avg_total_steps,
  AVG(Calories) AS avg_calories_burned
FROM `fast-lattice-419716.bellabeat.dailyActivity`
GROUP BY day_of_week;
