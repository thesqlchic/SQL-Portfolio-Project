select *
from INFORMATION_SCHEMA.tables
----------------------------------------------------------------------------------------------------------------------------------------------
--- View entire data
SELECT *
from Monkey_Pox_Cases_Worldwide$_updated

--Total number of Monkey pox cases
SELECT
	SUM(confirmed_cases) as total_number_of_monkey_pox_cases
FROM
	Monkey_Pox_Cases_Worldwide$_updated

--Total number of countries affected
SELECT
	COUNT(country) as Countries_infected
FROM
	Monkey_Pox_Cases_Worldwide$_updated

--Continents affected
SELECT
	DISTINCT(Continent)
FROM 
	Monkey_Pox_Cases_Worldwide$_updated
--Most infected continent
SELECT 
	Continent,
	SUM(cast(confirmed_cases as int)) as Total_cases_per_continent
FROM
	Monkey_Pox_Cases_Worldwide$_updated
GROUP BY
	Continent
ORDER BY
	Total_cases_per_continent desc

--top 10 infectious countries
SELECT TOP(10)
	Country,
	SUM(confirmed_cases+Suspected_Cases-Travel_history_yes) as total_persons_that_got_infected_within
FROM	
	Monkey_Pox_Cases_Worldwide$_updated
GROUP BY
	Country
ORDER BY
	total_persons_that_got_infected_within desc

--most infected countries
SELECT TOP(10)
	Country,
	confirmed_cases
FROM
	Monkey_Pox_Cases_Worldwide$_updated
ORDER BY
	Confirmed_Cases desc

--Least infected countries
SELECT TOP(10)
	Country,
	Confirmed_cases
FROM
	Monkey_Pox_Cases_Worldwide$_updated
WHERE
	Confirmed_Cases >0
ORDER BY
	Confirmed_Cases asc

--Number of Hospitalized monkey pox patients
SELECT
	SUM(hospitalized) as total_number_of_Monkey_pox_patients
FROM
	Monkey_Pox_Cases_Worldwide$_updated

--Percentage of hospitalized monkey pox patients
SELECT
	Country,
	SUM(confirmed_cases*hospitalized)/100 as perctentage_of_hospitalized_patients
FROM
	Monkey_Pox_Cases_Worldwide$_updated
Group by
	Country
ORDER BY
	perctentage_of_hospitalized_patients desc

--European countries that are infected and the number of cases
SELECT
	Country,
	confirmed_cases
FROM
	Monkey_Pox_Cases_Worldwide$_updated
Order by Confirmed_Cases desc
