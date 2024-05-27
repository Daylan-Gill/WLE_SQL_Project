-- World Life Expectancy Project (Data Cleaning)
SELECT *
FROM world_life_expectancy;


-- Identify duplicates by filtering Country and Year
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country,Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year))> 1;


-- Identify row numbers of duplicate entries
SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
	FROM world_life_expectancy) AS row_table
WHERE row_num > 1;


-- Delete duplicate entries
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
	SELECT Row_ID
	FROM (
		SELECT Row_ID, 
		CONCAT(Country, Year),
		ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
		FROM world_life_expectancy) AS row_table
	WHERE row_num > 1);


-- Identify blank entries in Status column
SELECT *
FROM world_life_expectancy
WHERE Status = '';


-- Identify all possible values for Status column
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status != '';


-- Identify countries classified as Developing
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';


-- If a country is listed as developing in a previous year 
-- set blank values to developing
-- ERROR
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (
	SELECT DISTINCT(Country)
	FROM world_life_expectancy
	WHERE Status = 'Developing');
    
   
-- If a country is listed as developing in a previous year 
-- set blank values to developing
UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developing';


-- If a country is listed as developed in a previous year 
-- set blank values to developed
UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developed';


-- Identify blank values in Lifeexpectancy column
SELECT Country, Year, Lifeexpectancy
FROM world_life_expectancy
WHERE Lifeexpectancy = '';


-- Identify average life expectancy between +1 and -1 years from blank year
SELECT t1.Country, t1.Year, t1.Lifeexpectancy, 
t2.Country, t2.Year, t2.Lifeexpectancy,
t3.Country, t3.Year, t3.Lifeexpectancy,
ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy) / 2, 1) AS avg_life
FROM world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy AS t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.Lifeexpectancy = '';


-- If a Lifeexpectancy value is blank update the value to
-- be equal to the average of the next and previous year
UPDATE world_life_expectancy AS t1
JOIN world_life_expectancy AS t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy AS t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy) / 2, 1)
WHERE t1.Lifeexpectancy = '';