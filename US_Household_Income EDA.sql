# US_Household_ Income project Exploratory analysis

select * from us_household_income;

select * from ushouseholdincome_statistics;
# Top 10 largest states Aland 
select 
state_name,sum(Aland),sum(awater)
from us_household_income
group by State_Name
order by 2 desc 
limit 10;

select u.state_name,county,type,`primary`,mean,median
from us_household_income u
join ushouseholdincome_statistics us
on u.id = us.id
where mean != 0;
# Top 5 lowest average income household per states
select u.state_name,round(avg(mean),2),round(avg(median),2)
from us_household_income u
	join ushouseholdincome_statistics us
	on u.id = us.id
where mean != 0
group by u.state_name
order by 2 
limit 5;

 #Top 5 higest average income household per states
select u.state_name,round(avg(mean),2),round(avg(median),2)
from us_household_income u
	join ushouseholdincome_statistics us
	on u.id = us.id
where mean != 0
group by u.state_name
order by 2 desc 
limit 5;

select type,count(type),round(avg(mean),2),round(avg(median),2)
from us_household_income u
	join ushouseholdincome_statistics us
	on u.id = us.id
where mean != 0
group by type
having count(type) > 100
order by 4 desc 
limit 10;
# Looking for the highest income household per city	
select u.state_name,city,round(avg(mean),2)
from us_household_income u
join ushouseholdincome_statistics us
on u.id = us.id
where mean != 0
group by u.state_name,city
order by round(avg(mean),2) desc ;