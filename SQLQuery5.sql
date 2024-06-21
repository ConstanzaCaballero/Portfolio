--select *
--from PortfolioProject..CovidDeaths
--order by 3, 4


--select location, date, total_cases, new_cases, total_deaths, population
--from PortfolioProject..CovidDeaths
--order by 1,2


----Looking at Total Cases vs Total Deaths
----Shows likelihood of dying if you contract covid in yout country
--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where location like'%spain%'
--order by 1,2

----Looking at total cases vs Population
--select location, date,Population, total_cases, (total_cases/population)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where location like'%spain%'
--order by 1,2

----Looking at Countries with Highest Infection Rate compared to Population
--select location, population,  max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentPopulationInfected
--from PortfolioProject..CovidDeaths
----where location like'%spain%'
--group by location, population
--order by PercentPopulationInfected desc

----Showing Countries with the Highest Death Count per Population
--Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is not null
--Group by Location
--Order by TotalDeathCount desc


----Let's break things by continent
--Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
--from PortfolioProject..CovidDeaths
--where continent is not null
--Group by location
--Order by TotalDeathCount desc


----GLOBAL NUMBERS
--select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent is not null
--group by date
--order by 1,2

----GLOBAL data
--select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where continent is not null
----group by date
--order by 1,2


--Looking at Total Population vs Vaccinations
Select  dea.continent, vac.continent, dea.location, vac.location, dea.date, vac.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as porpais
from portfolioproject..coviddeaths dea
join portfolioproject..CovidVaccinations vac
on dea.location=vac.location and
cast(dea.date as date)=cast(vac.date as date)
where dea.continent is not null and dea.location='Albania'
order by 2, 3

--Parece que el problema viene de covid deaths. Hay counts de 5 para misma fecha

SELECT location, date, COUNT(*)
FROM portfolioProject..coviddeaths
GROUP BY location, date
HAVING COUNT(*) > 1
order by location,  date desc


select *
from portfolioProject..coviddeaths
where location='Albania'

select *
from portfolioProject..coviddeathsnew
where location='Albania' and date= '2020-02-25'



  SELECT location, date, COUNT(*)
FROM portfolioProject..CovidVaccinations
GROUP BY location, date
HAVING COUNT(*) >= 1
order by location,  date desc

--use cte

with popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated) 
as
(
Select  dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as porpais
from portfolioproject..coviddeaths dea
join portfolioproject..CovidVaccinations vac
on dea.location=vac.location and
cast(dea.date as date)=cast(vac.date as date)
where dea.continent is not null and dea.location='Albania'
--order by 2, 3
)
select *, (Rollingpeoplevaccinated/population)*100
from popvsvac


--TEMP TABLE
drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255), 
location nvarchar(255), 
date datetime, 
population numeric, 
new_vaccinations numeric, 
Rollingpeoplevaccinated numeric)

insert into #percentpopulationvaccinated
Select  dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as Rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..CovidVaccinations vac
on dea.location=vac.location and
cast(dea.date as date)=cast(vac.date as date)
--where dea.continent is not null and dea.location='Albania'
--order by 2, 3

select *, (Rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated


--Create View to store data for later visualization
create view dbo.percentpopulationvaccinatedview3 as
Select  dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as Rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..CovidVaccinations vac
on dea.location=vac.location and
dea.date= vac.date
where dea.continent is not null


SELECT * 
FROM information_schema.views 
WHERE table_name = 'percentpopulationvaccinatedview3';


SELECT * FROM dbo.percentpopulationvaccinatedview3;