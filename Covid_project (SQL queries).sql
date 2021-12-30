/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select *
from Covid_deaths
where continent is not null
order by 3,4;

--select *
--from CovidVaccination$
--order by 3,4;

select Upper(location) as 'Location', date, total_cases, new_cases, total_deaths, population
from Covid_Deaths
where continent is not null
order by 1,2 asc;

--Total cases vs Total Deaths
--Shows chances of surviving covid in Nigeria
select Upper(location) as 'Location', date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'Death percentage'
from Covid_Deaths
where location like '%nigeria%'
order by 1,2 asc;

--Chances of surviving covid in United States
select Upper(location) as 'Location', date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'Death percentage'
from Covid_Deaths
where location like '%states%'
order by 1,2 asc;

--Chances of surviving Covid in United kingdom
select Upper(location) as 'Location', date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'Death percentage'
from Covid_Deaths
where location like '% united kingdom%'
order by 1,2 asc;

--Chances of surviving covid in Canada
select Upper(location) as 'Location', date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'Death percentage'
from Covid_Deaths
where location like '%canada%'
order by 1,2 asc;


--Total cases vs Population
--Shows what percentage of population got Covid
select Upper(location) as 'Location', date, population, total_cases, (total_cases/population)*100 as 'Infected Population Percent'
from Covid_Deaths
where location like '%nigeria%'
and continent is not null
order by 1,2 asc;

--Comparing countries with very high infection rates to Population
select Upper(location) as 'Location', population, max(total_cases) as 'Highest Infection Rate', max((total_cases/population))*100 as 'Percentage of infected persons'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
group by location,population
order by [Percentage of infected persons] desc;

--Showing countries with the Highest Death Count per population.
select Upper(location) as 'Location', max(cast(total_deaths as int)) as 'Total Death Count'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
group by location
order by 'Total Death Count' desc;

select Upper(location) as 'Location',date, max(cast(total_deaths as int)) as 'Total Death Count',
case
when total_deaths >100
then 'High'
else 'Low'
end Death_rate
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
group by total_deaths,location,date
order by 'Total Death Count' desc;

--Average date rates of each countries
select location, avg(cast(total_deaths as bigint)) as 'Average number of total deaths'
from Covid_deaths
where continent is not null
group by location
order by location asc;


--ANALYSIS FOR EACH CONTINENT

--Continent with the highest death count
select upper(continent) as Continent, max(cast(total_deaths as int)) as 'Total Death Count'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
group by continent
order by 'Total Death Count' desc;

--Global numbers

select sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as Total_new_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 'Death percentage'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
--group by date
order by 1,2 asc;


--Showing total population vs vaccination

select CD.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
, sum(CONVERT(bigint,cv.new_vaccinations)) over (Partition by cd.location order by CD.location,CD.date) as 'Rolling people vaccinated'
from Covid_deaths CD
join CovidVaccination$ CV
on CD.location=CV.location
and CD.date=CV.date
where cd.continent is not null
order by 2,3;

--Use CTE

with Popvsvac (continent,location,date, population,new_vaccinations,rollingpeoplevacinnated)
as
(select CD.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
, sum(CONVERT(bigint,cv.new_vaccinations)) over (Partition by cd.location order by CD.location,CD.date) as 'Rolling people vaccinated'
from Covid_deaths CD
join CovidVaccination$ CV
on CD.location=CV.location
and CD.date=CV.date
where cd.continent is not null
--order by 2,3;
)
select *, (rollingpeoplevacinnated/population)* 100 as vaccination_rate
from Popvsvac

--Temp Table

drop table if exists #percentpopulationvaccinated

create table #percentpopulationvaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rollingpeoplevaccinated numeric
);

 insert into #percentpopulationvaccinated
 select CD.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
, sum(CONVERT(bigint,cv.new_vaccinations)) over (Partition by cd.location order by CD.location,CD.date) as 'Rolling people vaccinated'
from Covid_deaths CD
join CovidVaccination$ CV
on CD.location=CV.location
and CD.date=CV.date
where cd.continent is not null
--order by 2,3;

select *, (Rollingpeoplevaccinated/population)* 100 as vaccination_rate
from #percentpopulationvaccinated;


--Creating view to store data for later visualization


create view percentpopulationvaccinated as
select CD.continent,cd.location,cd.date,cd.population,cv.new_vaccinations
, sum(CONVERT(bigint,cv.new_vaccinations)) over (Partition by cd.location order by CD.location,CD.date) as 'Rolling people vaccinated'
from Covid_deaths CD
join CovidVaccination$ CV
on CD.location=CV.location
and CD.date=CV.date
where cd.continent is not null
--order by 2,3;

Create view total_cases_vs_total_death as
--showing chances of surviving in Nigeria
select Upper(location) as 'Location', date, total_cases, total_deaths, (total_deaths/total_cases)*100 as 'Death percentage'
from Covid_Deaths
where location like '%nigeria%'
--order by 1,2 asc;

create view Total_cases_vs_Population as
--Shows what percentage of population got Covid
select Upper(location) as 'Location', date, population, total_cases, (total_cases/population)*100 as 'Infected Population Percent'
from Covid_Deaths
where location like '%nigeria%'
and continent is not null
--order by 1,2 asc;


create view countries_with_very_high_infection_rates_vs_population as
--Comparing countries with very high infection rates to Population
select Upper(location) as 'Location', population, max(total_cases) as 'Highest Infection Rate', max((total_cases/population))*100 as 'Percentage of infected persons'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
group by location,population
--order by [Percentage of infected persons] desc;

create view countries_with_the_highest_death_count_per_population as
--Showing countries with the Highest Death Count per population.
select Upper(location) as 'Location', max(cast(total_deaths as int)) as 'Total Death Count'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
group by location
--order by 'Total Death Count' desc;


create view Continent_with_the_highest_death_count as
-- Continent analysis: Continent with the highest death count
select upper(continent) as Continent, max(cast(total_deaths as int)) as 'Total Death Count'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
group by continent
--order by 'Total Death Count' desc;


create view Global_numbers as
--Global numbers
select sum(new_cases) as total_new_cases, sum(cast(new_deaths as int)) as Total_new_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 'Death percentage'
from Covid_Deaths
--where location like '%nigeria%'
where continent is not null
--group by date
--order by 1,2 asc;

create view Global_average_death_rate as
--Average date rates of each countries
select location, avg(cast(total_deaths as bigint)) as 'Average number of total deaths'
from Covid_deaths
where continent is not null
group by location
--order by location asc;
