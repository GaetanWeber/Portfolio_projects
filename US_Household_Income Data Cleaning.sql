# US_Household_ Income project Data Cleaning

select * from us_household_income;

select * from ushouseholdincome_statistics;
# changing  first column name of ushouseholdincome_statistics table

alter table ushouseholdincome_statistics
rename column `ï»¿id` to id;

select count(*)
from us_household_income;
select count(*) from ushouseholdincome_statistics;

# Looking for the duplicate

select id, 
count(id)
from us_household_income
group by id
having count(id) >1 ;

delete from us_household_income
where row_id in (
	select row_id
	from
		(select 
		row_id,
		id,
		row_number() over (partition by id order by id) as row_num
		from us_household_income) tble
	where row_num > 1); 

select id, 
count(id)
from ushouseholdincome_statistics
group by id
having count(id) >1 ;

select distinct State_Name
from us_household_income;

select State_name,
count(State_name)
from us_household_income
group by State_name
order by State_name;

update us_household_income
set State_name = 'Georgia'
where State_name = 'georia';

update us_household_income
set State_name = 'Alabama'
where State_name = 'alabama';  

select State_ab,
count(State_ab)
from us_household_income
group by State_ab
order by count(State_ab);

select *
from us_household_income
where city = 'Vinemont';

update us_household_income
set place = 'Autaugaville'
where place ='';

select type,
count(type)
from us_household_income
group by type
order by count(type);

update us_household_income
set type = 'Borough'
where type = 'Boroughs';