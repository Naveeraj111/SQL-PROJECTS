                                  --  INDIAN CENSUS ANALYSIS BY USING SQL 

drop database if exists Indian_census;
create database if not exists Indian_census;

select * from india_census_db1;
select * from india_census_db2;

-- NUMBER OF ROWS IN DATASET

select count(*) from india_census_db1;             -- containing 43 rows
select count(*) from india_census_db2;              -- containing 640 rows

-- DATASET FOR BIHAR & JHARKHAND

select * from india_census_db1 where state in ('Jharkhand' ,'Bihar');

-- POPULATION OF INDIA

select sum(population) as Population from india_census_db1;   

-- AVERAGE GROWTH

select state,avg(growth)*100 avg_growth from india_census_db2 group by state;       -- 

-- AVERAGE SEX RATIO

select state,round(avg(sex_ratio),0) avg_sex_ratio from india_census_db2 group by state order by avg_sex_ratio desc;

-- AVERAGE LITERACY RATE 
 
select state,round(avg(literacy),0) avg_literacy_ratio
from india_census_db2
group by state having round(avg(literacy),0)>90 
order by avg_literacy_ratio desc ;          -- MAXIMUM LITERACY RATE 
																					-- STATE IS KERALA & LAKSHSDWEEP
  -- TOP 3 STATE SHOWING HIGHEST GROWTH RATE

select state,avg(growth)*100 avg_growth 
from india_census_db2
 group by state 
 order by avg_growth desc limit 3;

-- BOTTOM 3 STATE SHOWING LOWEST SEX RATIO

select state,round(avg(sex_ratio),0) avg_sex_ratio from india_census_db2 group by state order by avg_sex_ratio asc;


-- BOTH TOP & BOTTOM 3 STATE IN LITERACY

drop table if exists topstates;

-- CREATE A TABLE TOPSTATES

create table topstates
( state nvarchar(255),
  topstate float);
  
 --  INSERT INTO TOPSTATES
 
select state,round(avg(literacy),0) avg_literacy_ratio from india_census_db2
group by state order by avg_literacy_ratio desc;

select * from topstates order by topstate desc;

drop table if exists bottomstates;

-- CREATE TABLE BOTTOMSTATES

create table bottomstates
( state nvarchar(255),
  bottomstate float);

insert into bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from india_census_db2 
group by state order by avg_literacy_ratio desc;

select  * from bottomstates order by bottomstate asc;

-- USING UNION FUNCTION

select * from (
select  * from topstates order by topstate desc) a

union

select * from (
select  * from bottomstates order by bottomstate asc) b;

-- STATES STARTING WITH THE LETTER A 

select distinct state from india_census_db1
where lower(state) like 'a%' or lower(state) like 'b%';              -- BIHAR, AP, ASSAM 

select distinct state from india_census_db2 
Where lower(state) like 'a%' and lower(state) like '%m';                  -- ONLY ASSAM

-- JOINING THE BOTH TABLES

-- TOTAL MALES  FEMALES

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males,
 round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females FROM
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from india_census_db2 a 
inner join india_census_db1 on a.district=b.district ) c) d
group by d.state;                                               -- BOTH TABLES ARE INNER JOINED...


-- TOTAL LITERACY RATE

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from india_census_db1 a 
inner join india_census_db2 on a.district=b.district) d) c
group by c.state;

-- POPULATION IN PREVIOUS CENSUS

select sum(m.previous_census_population) previous_census_population,
sum(m.current_census_population) current_census_population 
from(select e.state,sum(e.previous_census_population) previous_census_population,
sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from india_census_db2 inner join india_census_db1 b on a.district=b.district) d) e
group by e.state);

-- POPULATION VS AREA

select (g.total_area/g.previous_census_population)  as previous_census_population_vs_area, 
(g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) previous_census_population,
sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,
sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from india_census_db2 a inner join india_census_db1 b on a.district=b.district) d) e
group by e.state)m) n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from india_census_db1)z) r on q.keyy=r.keyy)g;

-- BY USING WINDOW FUNCTION

-- output districts from each state with highest literacy rate


select a.* from
(select district,state,literacy,rank() 
over(partition by state order by literacy desc) rnk from india_census_db2) a
where a.rnk in (1,2,3) order by state;
