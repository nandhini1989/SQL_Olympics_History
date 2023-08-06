SELECT * FROM athlete_events;

-- count of distinct games in olympics
select count(distinct games) from athlete_events

-- list the games in olypics
select distinct games from athlete_events

-- countries participated in olympics
select distinct region from noc_regions

-- count of countries participated in olympics
select count(distinct region) from noc_regions

-- Get the year where countries had highest participation
with cte as (select a.year,n.region,count(a.name) as total_participants from athlete_events a join
noc_regions n on a.noc = n.noc
group by a.year,n.region
)
select year,count(total_participants)  as countries from cte
group by year 
order by countries desc

-- get oldest athletes to win gold medal
select * from athlete_events 
where medal = "gold" 
order by age desc
limit 2

-- get top 5 athletes with highest gold medals
with ct as 
(select name,team,count(medal) as medal_count from athlete_events
where medal = "gold"
group by name,Team
order by medal_count desc),
ct1 as (select *,dense_rank() over(order by medal_count desc) as rnk 
from ct)
select name,team,medal_count from ct1
where rnk <= 5

-- top 5 athlete with highest total medals
with ct as 
(select name,team,count(medal) as medal_count from athlete_events
where medal in ('gold','silver','bronze')
group by name,Team
order by medal_count desc),
ct1 as (select *,dense_rank() over(order by medal_count desc) as rnk 
from ct)
select name,team,medal_count from ct1
where rnk <= 5

-- top 5 countries with highest medals
with t as (select n.region ,count(medal) as total_count from athlete_events a
join noc_regions n on a.noc = n.noc
where a.medal <> "NA"
group by n.region
order by total_count desc),
t1 as (select *,dense_rank() over(order by total_count desc) as rnk
from t)
select * from t1 where rnk <= 5

-- count of gold, silver,bronze medals by each country
select n.region ,
count(case when a.medal = "gold" then medal end)as Gold,
count(case when a.medal = "silver" then medal end) as Silver,
count(case when a.medal = "bronze" then medal  end) as Bronze
from athlete_events a
join noc_regions n on a.noc = n.noc
where a.medal <> "NA"
group by n.region
order by gold desc


-- count of gold, silver,bronze medals by each country
select n.region ,a.games,
count(case when a.medal = "gold" then medal end)as Gold,
count(case when a.medal = "silver" then medal end) as Silver,
count(case when a.medal = "bronze" then medal  end) as Bronze
from athlete_events a
join noc_regions n on a.noc = n.noc
where a.medal <> "NA"
group by n.region,a.games
order by a.games

-- top 3 sports where India has won highest medals
with t as (select a.sport,n.region,count(a.medal) as medal_count from athlete_events a
join noc_regions n on a.noc = n.noc
where n.region = "India"
group by a.sport)
select * , dense_rank() over(order by medal_count desc) as rnk from t
limit 3 

-- total medals won by India in sport Hockey in each olypics 
select a.sport,n.region,a.games,count(a.medal) as medal_count from athlete_events a
join noc_regions n on a.noc = n.noc
where n.region = "India" and sport = "hockey"
group by a.sport,a.games
order by a.games