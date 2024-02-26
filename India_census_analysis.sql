-- Data Analysis on India Census data 2011

select * from census..data1
select * from census..data2

-- Number of rows into our datasets

select count(*) total_rows from census..data1
select count(*) total_rows from census..data2

-- dataset for jharkand and bihar

select * from census..data1

select * from census..data1 where state in ('Jharkhand','bihar') order by state asc

-- States starting with letter 'a'

select * from census..data1 where state like ('a%')

-- district  with letter 'aeiou'

select * from census..data1 where district like '[A,E,I,O,U]%[A,E,I,O,U]'

select * from census..data1 where district like 'a%a'

select * from census..data1 where district like '%ab%'

select * from census..data1 where district like '%[x,y,z]'


-- population in India

select * from census..data2

select sum(population) total_population from census..data2

-- avg growth by state

select * from census..data1

select state, round(AVG(growth)*100,2) as avggrowth from census..data1
group by  state order by state asc


-- avg sex_ratio by state

select * from census..data1

select state, round(AVG(Sex_Ratio),0) as avg_sexratio from census..data1
group by  state  order by avg_sexratio desc

-- which state has the  literacy rate greater than 90?

select * from census..data1

select state, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  state having round(AVG(Literacy),2) > 90 order by avg_literacy desc

-- which district has the  literacy rate greater than 90?

select * from census..data1

select district, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  district having round(AVG(Literacy),2) > 90 order by avg_literacy desc


-- Top 5 states which has highest literacy

select * from census..data1

select top 5 a.state, a.avg_literacy from (
select state, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  state ) a
order by a.avg_literacy desc

-- Top 10 district which has the highest literacy 

select * from census..data1

select top 10 *from (
select district,state, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  district, state ) a
order by a.avg_literacy desc


-- Top 5 State which has the lowest literacy

select * from census..data1

select top 5 a.state, a.avg_literacy from (
select state, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  state ) a
order by a.avg_literacy asc

-- Top 10 district which has the lowest literacy 

select * from census..data1

select top 10 *from (
select district,state, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  district, state ) a
order by a.avg_literacy asc

-- Top 3 state showing highest growth ratio

select * from census..data1

select top 3 state, AVG(growth)*100 as avg_growth from census..data1
group by state order by avg_growth desc

-- Top 10 district showing highest growth ratio

select * from census..data1

select top 10 * from (
select district, state, AVG(growth)*100 as avg_growth from census..data1
group by district,state ) a
order by a.avg_growth desc

-- Top 3 state showing lowest growth ratio

select * from census..data1

select top 3 state, AVG(growth)*100 as avg_growth from census..data1
group by state order by avg_growth asc

-- Top 10 district showing lowest growth ratio

select * from census..data1

select top 10 * from (
select district, state, AVG(growth)*100 as avg_growth from census..data1
group by district,state ) a
order by a.avg_growth asc

-- Top 3 state showing highest sex ratio

select * from census..data1

select top 3 state, round(AVG(sex_ratio),0) as avg_sex_ratio from census..data1
group by state order by avg_sex_ratio desc

-- Top 10 district showing highest sex ratio

select top 10 * from (
select district,state, round(AVG(sex_ratio),0) as avg_sex_ratio from census..data1
group by district,state ) a
order by avg_sex_ratio desc


-- Top 3 state showing lowest sex ratio

select * from census..data1

select top 3 state, round(AVG(sex_ratio),0) as avg_sex_ratio from census..data1
group by state order by avg_sex_ratio asc

-- Top 10 district showing highest sex ratio

select * from census..data1

select top 10 * from (
select district,state, round(AVG(sex_ratio),0) as avg_sex_ratio from census..data1
group by district,state ) a
order by avg_sex_ratio asc


-- Top and bottom 3 states in literacy rates

drop table if exists #bottomstates

create table #topstates (
state varchar(100),
topstates float
)

create table #bottomstates (
state varchar(100),
bottomstates float
)


Insert into #topstates
select a.state, a.avg_literacy from (
select state, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  state ) a
order by a.avg_literacy desc

select top 3 * from #topstates order by topstates desc


insert into #bottomstates
select a.state, a.avg_literacy from (
select state, round(AVG(Literacy),2) as avg_literacy from census..data1
group by  state ) a
order by a.avg_literacy asc

select top 3 * from #bottomstates order by bottomstates asc

-- Using union to join above select queries 

select * from (
select  top 3 * from #topstates order by topstates desc) a
union
select * from (
select top 3 * from #bottomstates order by bottomstates asc) b

-- joining table

select * from census..data1
select * from census..data2

select a.district, a.state,a.sex_ratio, b.population from
data1 a inner join data2 b
on a.District = b.District
order by a.State asc

-- Total males and females in  each state

select d.State, sum(d.males) males, sum(d.females) females, SUM(d.population) total_population from (
select c.district,c.state, round(c.Population/(c.Sex_Ratio +1),0) males,round(c.Sex_Ratio * c.Population/(c.Sex_Ratio +1),0) females,
c.sex_ratio, c.Population    from (
select a.district, a.state,a.sex_ratio/1000 sex_ratio, b.population from
data1 a inner join data2 b
on a.District = b.District) c) d 
group by d.state


--total literate and illiterate in each state

select d.state, sum(d.literate_people) literate_people,sum(d.illiterate_people) illiterate_people from(
select c.District, c.State, round(c.literacy_ratio * c.Population,0) literate_people, 
 round((1-c.literacy_ratio )* c.Population,0) illiterate_people,
c.Population from (
select a.district, a.state,a.Literacy/100 literacy_ratio, b.population from
data1 a inner join data2 b
on a.District = b.District) c) d
group by d.state

-- population in previous census


select d.State, SUM(d.previous_census_population) from (
select c.district,c.State, round(c.Population/(1+c.District),0) previous_census_population,c.Population current_census_population from (
select a.district, a.state,a.Growth growth, b.population from
data1 a inner join data2 b
on a.District = b.District) c) d
group by d.state


-- Top 3 district which has highest literacy in each state

select * from
(select  district, state,Literacy,
DENSE_RANK() over(partition by state order by literacy desc) as rnk
from census..data1) a
where a.rnk <=3

