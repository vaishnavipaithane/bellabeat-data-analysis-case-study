SELECT
  Id,
  day_of_week,
  AVG(TotalSteps) AS avg_total_steps,
  AVG(Calories) AS avg_calories_burned,
  CASE
    WHEN AVG(TotalSteps) < 5000 THEN 'Sedentary'
    WHEN AVG(TotalSteps) BETWEEN 5000 AND 7499 THEN 'Lightly Active'
    WHEN AVG(TotalSteps) BETWEEN 7500 AND 9999 THEN 'Moderately Active'
    WHEN AVG(TotalSteps) BETWEEN 10000 AND 12499 THEN 'Fairly Active'
    WHEN AVG(TotalSteps) > 12500 THEN 'Highly Active'
  END AS activity_level
FROM `fast-lattice-419716.bellabeat.dailyActivity`
GROUP BY Id, day_of_week;










