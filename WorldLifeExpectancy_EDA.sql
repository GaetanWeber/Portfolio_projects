# World Life Expectancy (Exploratory data analysis)

# Looking at min and max Life Expectancy and Life_increase

select country, min(`Life expectancy`),max(`Life expectancy`),
round((max(`Life expectancy`)-min(`Life expectancy`)),2) as Life_Increase_15_years
from world_life_expectancy
group by country
having min(`Life expectancy`) != 0 and max(`Life expectancy`) !=0
order by Life_Increase_15_years desc;

#Looking at the avg per year

select year,
round(avg(`Life expectancy`),2)
from world_life_expectancy
where `Life expectancy`!= 0 and `Life expectancy`!=0
group by year
order by year;

#Looking for some coorelation between life and gdp

select 
country,
round(avg(`Life expectancy`),2) as avg_Life_expectancy, 
round(avg(gdp),2) as avg_gdp
from world_life_expectancy
group by country
having avg_Life_expectancy > 0
and avg_gdp > 0
order by avg_gdp desc;

#Calculate counts and average life expectancy for countries with high and low GDP
select 
sum(case when GDP >=1500 then 1 else 0 end) High_GDP_Count,
round(avg(case when GDP >=1500 then `Life expectancy` else null end),2) High_GDP_Life_expectancy,
sum(case when GDP <1500 then 1 else 0 end) Low_GDP_Count,
round(avg(case when GDP <1500 then `Life expectancy` else null end),2) Low_GDP_Life_expectancy
from world_life_expectancy;

select status,
round(avg(`Life expectancy`),2)
from world_life_expectancy
where `Life expectancy` !=0
group by status;

select status, 
count(distinct country),
round(avg(`Life expectancy`),2)
from world_life_expectancy
group by status;

# Calculate the average life expectancy and BMI for each country,

select 
country,
round(avg(`Life expectancy`),2) as avg_Life_expectancy, 
round(avg(BMI),2) as avg_BMI
from world_life_expectancy
group by country
having avg_Life_expectancy > 0
and avg_BMI > 0
order by avg_BMI desc;

select * 
from world_life_expectancy;

#Calculate the life expectancy, adult mortality, and cumulative adult mortality by country over the years
select country,
`Life expectancy`,
`Adult Mortality`,
sum(`Adult Mortality`) over(partition by country order by year)
from world_life_expectancy;