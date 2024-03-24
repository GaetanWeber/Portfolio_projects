# World_Life_Expentancy  Project (Data cleaning)
# check duplicates
SELECT country,
	year,
    CONCAT(country, year),
    COUNT(CONCAT(country, year))
FROM
    world_life_expectancy
GROUP BY country , year , CONCAT(country, year)
HAVING COUNT(CONCAT(country, year)) > 1;

select *
 from 
  (select 
		row_id,CONCAT(country, year),
		row_number() over (partition by CONCAT(country, year) order by CONCAT(country, year) asc) as Row_num
	FROM
    world_life_expectancy) temp_table
    where Row_num > 1
 ;
 
 delete from world_life_expectancy
 where row_id in(
 select row_id
 from 
  (select 
	row_id,CONCAT(country, year),
	row_number() over (partition by CONCAT(country, year) order by CONCAT(country, year) asc) as Row_num
	FROM
    world_life_expectancy) temp_table
    where Row_num > 1);
    
  #  Fill the blank field in Status column 
SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE status != '';
    
SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE status = 'Developing';
    
update world_life_expectancy
set status = 'Developing'
where country in(select distinct(country)
from world_life_expectancy
where status = 'Developing');
    
update world_life_expectancy t1
join world_life_expectancy t2
on t1.country = t2.country
set t1.status = 'Developing'
where t1.status =''
and t2.status != ''
and t2.status = 'Developing';
    
update world_life_expectancy t1
join world_life_expectancy t2
on t1.country = t2.country
set t1.status = 'Developed'
where t1.status =''
and t2.status != ''
and t2.status = 'Developed';

select *
from world_life_expectancy
where country  ='United States of America'; 

# Fill the blank in Life expentancy column

select *
from world_life_expectancy
where `Life expectancy`  ='';

select t1.country,t1. year,t1.`Life expectancy`,
 t2.country,t2. year,t2.`Life expectancy`,
 t3.country,t3. year,t3.`Life expectancy`,
 round((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1) 
from world_life_expectancy t1
join world_life_expectancy t2
on t1.country = t2.country
and t1.year = t2.year-1
join world_life_expectancy t3
on t1.country = t3.country
and t1.year = t3.year+1
where t1.`Life expectancy` = '';

update world_life_expectancy t1
join world_life_expectancy t2
on t1.country = t2.country
and t1.year = t2.year-1
join world_life_expectancy t3
on t1.country = t3.country
and t1.year = t3.year+1
set t1.`Life expectancy` =  round((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = '';