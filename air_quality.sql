
-- The BeijingAir Dataset
SELECT *
FROM BeijingAir

/* Data Cleaning */

-- Make Date Column
SELECT *,
CONVERT(DATE, CAST(year AS VARCHAR(4)) + '-' +
		CAST(month AS VARCHAR(2)) + '-' +
		CAST(day AS VARCHAR(2))) AS date
FROM BeijingAir;
 
ALTER TABLE BeijingAir
Add date DATE;

UPDATE BeijingAir
SET date = CONVERT(DATE, CAST(year AS VARCHAR(4)) + '-' +
		CAST(month AS VARCHAR(2)) + '-' +
		CAST(day AS VARCHAR(2)))

-- Rename columns
sp_rename 'BeijingAir.row','row_id', 'COLUMN';

sp_rename 'BeijingAir.aqi','pm', 'COLUMN';

-- Change lower case cv to upper case
UPDATE BeijingAir
SET wind_direction = 'CV'
WHERE wind_direction='cv';

--Replace null with 0
UPDATE BeijingAir
SET pm = 0 
WHERE aqi IS NULL;

/* The cleaned dataset */
SELECT *
FROM BeijingAir;

/*
Answering Questions
*/

--1. How are the average PM 2.5 levels distributed by wind direction
SELECT wind_direction,
	AVG(pm) AS avg_pm
FROM BeijingAir
GROUP BY wind_direction
ORDER BY avg_pm DESC;
/* Calm weather conditions ranked high */ 

--2. Air Quality Index Categories
WITH CTE AS(
				SELECT pm,
				CASE
					WHEN pm BETWEEN 0 AND 12 THEN 'Good'
					WHEN pm BETWEEN 12 AND 35 THEN 'Moderate'
					WHEN pm BETWEEN 35 AND 55 THEN 'Unhealthy for Sensitive Groups'
					WHEN pm BETWEEN 55 AND 150  THEN 'Unhealthy'
					WHEN pm BETWEEN 150 AND 250 THEN 'Very Unhealthy'
					ELSE 'Hazardous'
				END AS pm_levels
			 FROM BeijingAir
			 )
SELECT pm, pm_levels
FROM CTE;


--4. Average PM 2.5 levels by year
SELECT year, 
       AVG(pm) AS average_pm_levels
 FROM BeijingAir
 GROUP BY year 
 ORDER BY average_pm_levels DESC;
/*
2013 had the highest avearge PM 2.5 levels 
and 2012 had the lowest.
*/

--4.1 Highest daily PM 2.5 level by wind direction in 2012
WITH daily_pm AS(
	SELECT
	wind_direction,  
	SUM(pm) AS daily_pm
	FROM BeijingAir
	WHERE year = 2012
	GROUP BY wind_direction
	)
	SELECT wind_direction, 
	MAX(daily_pm) max_daily_pm
	FROM daily_pm
	GROUP BY wind_direction
	ORDER BY max_daily_pm DESC;

--5. What are the average PM 2.5 levels by year and month ?
SELECT 
		year,
		month,
		AVG(pm) AS average_pm_levels
 FROM BeijingAir
 GROUP BY month,year
 ORDER BY average_pm_levels DESC;
/* 
In the month of January 2011 the average PM 2.5 were at its lowest at 40.55 
as opposed to January of 2013 with levels as high as 191.97
*/

 --6.On average, does the wind speed have any effect on the PM 2.5 level? 
 SELECT ROUND(wind_speed, 2) AS wind_speed, 
       AVG(pm) AS avg_pm
 FROM BeijingAir
 GROUP BY wind_speed 
 ORDER BY avg_pm DESC;
 /* 
 There is no correlation between average AQI and wind speed, 
 because the values have no apparent trend with each other 
 */ 

 --7. What is the most prevalent wind direction
SELECT wind_direction,
		COUNT(wind_direction) AS wind
FROM BeijingAir
GROUP BY wind_direction
ORDER BY wind DESC;
/* The commonly occuring wind direction is SouthEast(SE),
it comes as no suprise because
Beijing is located 150 km SE of the Bohai sea.
*/

--8. Which are the coldest and hottest months and what are their corresponding average PM 2.5 values ?
SELECT month,
		AVG(temperature) AS temp, 
		AVG(pm) as pm
FROM BeijingAir
GROUP BY month
ORDER BY temp,pm DESC;
/* 
On average January, December and February have the coldest temperatures, 
with February having the largest average PM 2.5 levels.
*/

--9. What are the maximum and minimum temperature
SELECT MAX(temperature) AS max_temp,
		MIN(temperature) AS min_temp
FROM BeijingAir;
/* 
Maximum tempature is 42 degrees and lowest is -19 
*/

--10. What are the daily average PM 2.5 levels from lowest to highest ?
SELECT 
	day,
	AVG(pm) AS avg_pm_levels
FROM BeijingAir
GROUP BY day
ORDER BY avg_pm_levels ASC;

-- 11. Which year had the least total PM 2.5 levels?
SELECT 
	year,
	SUM(pm) AS total_pm
FROM BeijingAir
GROUP BY year
ORDER BY total_pm ASC;
/* 2012 had the lowest total PM2.5 */

--11.1 What are the total accumulated snow hours by year?
SELECT 
	year,
	SUM(snow_hours) AS total_snow
FROM BeijingAir
GROUP BY year
HAVING SUM(snow_hours) > 0;
/* In 2012 the total snow hours were high at 631 */

-- 11.2 What are the total accumulated rain hours by year ?
SELECT year,
	SUM(rain_hours) AS total_rain
FROM BeijingAir
GROUP BY year
HAVING SUM(rain_hours) > 0;
/* For a total of 2366 hours it rained in 2012 */

--12. What are the maximum, minimum and average pm 2.5 levels
SELECT MAX(pm) as max, MIN(pm) AS min, AVG(pm) AS avg
FROM BeijingAir;
/* On average, the PM 2.5 levels were 'Unhealthy' as they fall within the 55-150 micrograms per cubic meter range.