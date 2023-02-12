# Impact of Weather Conditions on Air Quality

## Overview

The aim of this analysis is to use SQL to determine the factors that have an influence on air pollution.
For this study, we worked on on the Beijing PM 2.5 public dataset from https://archive.ics.uci.edu/ml/datasets/Beijing+PM2.5+Data#

The data set contains hourly PM 2.5 data of US Embassy in Beijing from Jan 1st, 2010 to Dec 31st, 2014.

## Problem Definition

The air quality index in Beijing has increased over time. This may negatively impact not just the general populace but also the ecosystem as a whole and all species that live there.

## Solution

With the PM 2.5 pollutant as our primary emphasis, we will analyze and quantify the effect on the increase in the Air Quality Index. It has been discoverd that when levels of the air pollutant fine particulate matter (PM 2.5) are excessive, it poses a risk to people's health.
PM 2.5 are extremely small, inhalable particles that typically have a diameter of 2.5 micrometers or less and come from a variety of sources.

The data was cleaned and explored using SQL Server and the resulting clean SQL file linked and displayed in Power BI to generate a dashboard of the findings.
The SQL script can be found [here](/air_quality.sql)

## Answering Questions

The first five records excluding the first 24, where PM 2.5 values = 0 

![beijing_file](images/sql_full.png)

1. How are the average PM 2.5 levels distributed by wind direction ?

	SELECT wind_direction,
		AVG(pm) AS avg_pm
	FROM BeijingAir
	GROUP BY wind_direction
	ORDER BY avg_pm DESC;
	
![beijing_file](images/sql_1.png)

> On average, weather conditions are calm 

2. Air Quality Index Categories 

	WITH CTE AS(
			SELECT row_id, pm,
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
	SELECT TOP 5 row_id, pm, pm_levels
	FROM CTE
	WHERE pm > 0;
	
![beijing_file](images/sql_2.png)

> The selected rows show that the PM 2.5 levels vary.

3. What is the average PM 2.5 levels by year ?
 
	SELECT year, 
	       AVG(pm) AS average_pm_levels
	 FROM BeijingAir
	 GROUP BY year 
	 ORDER BY average_pm_levels DESC;
	 
![beijing_file](images/sql_3.png)

> 2013 had the highest average PM 2.5 levels and 2012 had the lowest.
