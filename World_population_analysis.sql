--Total population from 2022-2010
SELECT
	SUM([2022 population])+SUM([2020 population]) + SUM([2015 population]) + SUM([2010 population]) as  Total_popultion_from_2022_to_2010
FROM
	World_Population;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*continent analysis*/
/*Population per continent between 2022-2010*/
SELECT
	Continent,
	SUM([2022 population] + [2020 population] + [2015 Population] + [2010 population]) as Continent_population_between_2022_and_2010
FROM
	World_Population
GROUP BY --Group by is essential because of the presence of the aggregate function sum
	Continent
ORDER BY
	Continent_population_between_2022_and_2010 DESC

/*Continent Population growth before Covid and after covid*/
SELECT
	Continent,
	SUM([2020 population]-[2015 population])/5 AS Continent_growth_pre_covid, --Used population growth formula which is PG=n/t where n=Current population minus Past population
	SUM([2022 population]-[2020 population])/2 AS continent_growth_post_covid
FROM 
	World_Population
GROUP BY
	Continent
ORDER BY
	Continent_growth_pre_covid DESC;

/*Continent Population growth rate before and after covid*/
SELECT
	Continent,
	SUM(ROUND(([2020 population]-[2015 Population])*100/[2015 population],1)) as Continent_Population_growth_rate_pre_covid,
	SUM(ROUND(([2022 Population] - [2020 population]) *100/[2020 population],1)) AS continent_population_growth_rate_post_covid
FROM
	World_Population
GROUP BY
	Continent
ORDER BY
	Continent_Population_growth_rate_pre_covid DESC;
	
/*TOP 10 most populous country in Africa*/
SELECT TOP(10)
	Country,
	SUM([2022 population] + [2020 population] + [2015 Population] + [2010 population]) as African_country_population
FROM
	World_Population
WHERE 
	Continent='Africa'
GROUP BY
	Country
ORDER BY
	African_country_population DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Country analysis
Top 10 most populous country from 2022 to 2010
Population for 2022*/

SELECT	Top(10) --The top function will return specified number of countries in the column
	Country,
	SUM([2022 population] + [2020 population] + [2015 Population] + [2010 population]) as "Total_population_from_2022-2010"
FROM
	World_Population
GROUP BY
	Country
ORDER BY 
	SUM([2022 population] + [2020 population] + [2015 Population] + [2010 population]) DESC;

-- Population quartile of the population
SELECT
	country,
	[2022 population] * 25/100 as  First_quartile_of_the_population,-- 25% of the a country's population
	[2022 population] * 50/100 as Second_Quartile_of_the_population, --50% (the middle data point of the population)
	[2022 population] * 75/100 AS third_quartile_of_the_population, --75% of the country's population
	[2022 population] *100/100 AS fourth_quartile_of_the_population --100% of the country's population
FROM
	World_Population;


/* Country population growth between 2020 and 2022(Post Covid) and 2020-2015(pre covid). 
(Basically and simply just getting an estimate of the people that were added to the population or reduced from the population after covid 19 and before covid 19)*/
SELECT 
	Country,
	SUM([2020 population]-[2015 population])/5 as Population_growth_Pre_covid , -- Formula is PG=n/t. Where "N" is the current population(2020) minus past population (2015)
	SUM(([2022 population] -[2020 population]))/2 as Population_growth_post_covid -- Formula is PG=n/t. Where "N" is the current population(2022) minus past population (2020)
FROM
	World_Population
GROUP BY
	Country
ORDER BY
	Population_growth_Pre_covid DESC-- Can be ordered by ASC to see the country with the reduced population growth first
;

-- The percentage growth rate before and after covid 19
SELECT
	Country,
	ROUND(([2020 Population]-[2015 Population])*100/[2015 population],1) AS Population_growth_rate_Pre_covid,
	ROUND(([2022 population] -[2020 population])*100/[2020 population],1) as Population_growth_rate_post_Covid
FROM
	World_Population
ORDER BY
	Population_growth_rate_Pre_covid DESC;

--Annual population growth rate between 2020 and 2015 (before Covid)
SELECT
	country,
	ROUND(([2020 population]-[2015 population]) * (100/[2015 population])/5,1) as Annual_population_percentage_rate_pre_covid
FROM
	World_Population
ORDER BY
	Annual_population_percentage_rate_pre_covid ASC;

--ANNUAL population growth rate between 2022 and 2020 (post covid)
SELECT
	Country,
	ROUND(([2022 population] -[2020 population])*(100/[2020 population])/2,1) AS Annual_Population_Percentage_Rate_Post_Covid --I was trying to find the percentage at which each country grow annually
	--instead of the bi anual growth of 8.4
FROM
	World_Population
ORDER BY
	Annual_Population_Percentage_Rate_Post_Covid ASC;

--Pulling out Countries with equillibrium using CTE
WITH Equilibruim_population AS(
SELECT
	Country,
	ROUND(([2020 Population]-[2015 Population])* (100/ [2015 Population])/2,1) AS Annual_population_Percentage_rate_pre_covid,
	ROUND(([2022 population] -[2020 population])*(100/[2020 population])/2,1) AS Annual_Population_Percentage_Rate_Post_Covid
FROM
	World_Population)

SELECT *
FROM
	Equilibruim_population
WHERE
	Annual_Population_Percentage_Rate_Post_Covid = 0 ;

SELECT *
FROM World_Population