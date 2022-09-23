# Project for my Portfolio SQL
SELECT 
    *
FROM
    covidvaccinations
WHERE continent is not null
    ORDER BY 3,4;
    
SELECT * FROM coviddeaths
ORDER BY 3,4;


#Selecting the data that we will use
SELECT location, date, total_cases, new_cases, total_deaths,
population
FROM coviddeaths
ORDER BY 1,2;

#Looking at total cases vs total deaths
# Shows likelihood of dying from COVID-19
SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
ORDER BY 1,2;

# Looking at total cases vs population in China
SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE location like '%China%'
ORDER BY 1,2;

# Looking at Countries with Highest Infection Rates compared to population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM coviddeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;

# Countries with highest death count by population
SELECT location, MAX(cast(total_deaths as SIGNED)) as TotalDeathCount
FROM coviddeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc;

# looking at total deaths by continent
SELECT continent, MAX(cast(total_deaths as SIGNED)) as TotalDeathCount
FROM coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;


# Global Numbers
SELECT date, SUM(new_cases)as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM coviddeaths
wHERE continent is not null
GROUP BY date
ORDER BY 1,2;


# Total population vs vaccinations
WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingTotalVaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingTotalVaccinations
FROM coviddeaths dea
JOIN covidvaccinations vac
On dea.location = vac.location
and dea.date = vac.date
)
SELECT *, (RollingTotalVaccinations/Population)*100 as PercentageVaccinated 
FROM PopvsVac;


# Creating the view for visualisations
CREATE VIEW PercentagePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingTotalVaccinations
FROM coviddeaths dea
JOIN covidvaccinations vac
On dea.location = vac.location
and dea.date = vac.date;


