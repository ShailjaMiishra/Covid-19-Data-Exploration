/*

Covid-19 Data Exploration 

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Converting Data Types

*/

Select *
From PortfolioProject..Covid_deaths
Where continent is not null
Order by 3,4

Select *
From PortfolioProject..Covid_vaccinations
Where continent is not null


Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..Covid_deaths
Order by 1,2

-- looking at Total cases vs Total deaths

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..Covid_deaths
--Where location = 'india'
Order by 1,2

--Looking at Total_cases vs Population
--shows what percentage of population got covid19

Select location,date,population,total_cases,(total_cases/population)*100 as TotalCasePercentage
From PortfolioProject..Covid_deaths
Where location = 'india'
Order by 1,2

--Showing countries with highest infection rate

Select location,population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentePopulationInfected
From PortfolioProject..Covid_deaths
--Where location = 'china'
Group by population,location
Order by PercentePopulationInfected desc

--Showing countries with highest death rate

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_deaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Deaths in each continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Covid_deaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Numbers

Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as WorldWideDeathPercentage
From PortfolioProject..Covid_deaths
--Where location = 'india'
Where continent is not null
Order by 1,2

--Looking at Total Population vs Vaccinations

With PopVsNewVac (Continent, Location, Date, Population, New_Vaccinations, RollingCountOfNewVaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingCountOfNewVaccinations
From PortfolioProject..Covid_deaths dea
join PortfolioProject..Covid_vaccinations vac
on dea.location = vac.location
 and dea.date = vac.date
Where dea.continent is not null
--order by continent,location,date
)
Select *, (RollingCountOfNewVaccinations/Population) * 100 as PercentageOfPopulationVsNewVac
From PopVsNewVac
