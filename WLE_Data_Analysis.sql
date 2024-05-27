-- World Life Expectancy Project (Exploratory Data Analysis)
SELECT *
FROM world_life_expectancy;


-- Calculate the increase in life expectancy over a period of 15 years
SELECT Country, 
MIN(Lifeexpectancy), 
MAX(Lifeexpectancy),
ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy), 1) AS Life_Exp_Incr_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) != 0
AND MAX(Lifeexpectancy) != 0
ORDER BY Life_Exp_Incr_15_Years DESC;


-- Calculate the average life expectancy for the entire world by year
SELECT Year, ROUND(AVG(Lifeexpectancy), 1) AS Avg_Life_Exp
FROM world_life_expectancy
GROUP BY Year
ORDER BY Year;


-- Calculate average life expectancy and average GDP by country
SELECT Country, 
ROUND(AVG(Lifeexpectancy), 1) AS Avg_Life_Exp, 
ROUND(AVG(GDP), 1) AS Avg_GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_GDP > 0
ORDER BY Avg_GDP DESC;


-- Calculate number of countries where GDP is higher than 1500 (High GDP)
-- Calculate High GDP countries life expectancy
-- Calculate number of countries where GDP is lower than 1500 (Low GDP)
-- Calculate low GDP countries life expectancy
SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END), 1) AS High_GDP_Life_Exp,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END), 1) AS Low_GDP_Life_Exp
FROM world_life_expectancy;


-- Calculate average life expectancy for Country Status
SELECT Status, ROUND(AVG(Lifeexpectancy), 1) AS Avg_Life
FROM world_life_expectancy
GROUP BY Status;


-- Calculate number of distinct countries
SELECT Status, COUNT(DISTINCT Country) AS Country
FROM world_life_expectancy
GROUP BY Status;

-- Combine previous queries to show how average for Developed 
-- or Developing Country could be skewed due to sample size
SELECT Status, 
COUNT(DISTINCT Country) AS Country,
ROUND(AVG(Lifeexpectancy), 1) AS Avg_Life
FROM world_life_expectancy
GROUP BY Status;


-- Calculate average life expectancy and average BMI by country
SELECT Country, 
ROUND(AVG(Lifeexpectancy), 1) AS Avg_Life_Exp, 
ROUND(AVG(BMI), 1) AS Avg_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Avg_Life_Exp > 0
AND Avg_BMI > 0
ORDER BY Avg_BMI DESC;


-- Create a rolling total of number of adult deaths per year by country
SELECT Country,
Year,
Lifeexpectancy,
AdultMortality,
SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy;