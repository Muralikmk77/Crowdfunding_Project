-- Total Number of Projects based on outcome 
select state, count(*) as total_project from projects group by state;

-- Total Number of Projects based on Locations
select l.displayable_name , 
count(p.projectid) as total_projects
from location l
left join projects p on l.id = p.location_id
group by l.displayable_name
order by total_projects desc;

-- Total Number of Projects based on  Category
select c.name, count(p.projectid) as total_projects
from category c
left join projects p on c.id = p.category_id
group by c.name
order by total_projects desc;

-- Total Number of Projects created by Year , Quarter , Month
select c.year,  c.quarter,  c.month, 
  count(p.projectid) as total_projects
from calendar c
left join projects p on c.id = p.projectid
group by c.year, c.quarter, c.month
order by c.year desc, c.quarter desc, c.month desc;

-- Successful Projects based on Amount Raised
select sum(usd_pledged) as total_amount_raised
 from projects 
where state = 'successful';

-- Successful Projects based on Number of Backers
select sum(backers_count) as total_backers 
from projects 
where state = 'successful';

-- Top Successful Projects : Based on Number of Backers
select name, 
backers_count
from projects
where state = 'successful'
order by backers_count desc limit 10;

-- Top Successful Projects : Based on Amount Raised
 select name, 
usd_pledged
from projects
where state = 'successful'
order by usd_pledged desc limit 10;

-- Percentage of Successful Projects overall
select (count(case when state = 'successful' then 1 end) * 100.0 / count(*)) as success_percentage from projects;  

-- Percentage of Successful Projects  by Category
select  c.name,
count(case when p.state = 'successful' then 1 end) * 100.0 / count(*) as success_percentage
from ks_project.projects p
join ks_project.category c on p.category_id = c.id
group by c.id, c.name;

-- Percentage of Successful Projects by Year, Quarter and Month

 select (count(case when state = 'successful' then 1 end) * 100.0 / count(*)) as success_percentage from projects; 
 
 -- percentage by year

 select year(from_unixtime(created_at)) as year,
 concat( round(count(case when state="successful" then 1 end)*100/count(*)),"%") 
 as percentage
 from projects
 group by year
 order by year ;
 
 
  -- percentage by month

 select monthname(from_unixtime(created_at)) as Month,
 concat( round(count(case when state="successful" then 1 end)*100/count(*)),"%") 
 as percentage
 from projects
 group by month;
 
 
  -- percentage by Quarter
 
 select  quarter(from_unixtime(created_at)) as QTR,
 concat( round(count(case when state="successful" then 1 end)*100/count(*)),"%") 
 as percentage
 from projects
 group by QTR ;
 
 -- Percentage of Successful projects by Goal Range ( decide the range as per your need )
 
 with goal_ranges as 
 (select case when goal between 5001 and 10000 then '5k-10k'
			  when goal between 10001 and 50000 then '10k-50k'
              else '100k+' end as goal_range,
              
count(*) as total_projects,
sum(case when state = 'successful' then 1 else 0 end) as successful_projects
from projects
group by goal_range)
select
goal_range,
total_projects,
successful_projects,
(successful_projects / total_projects) * 100 as success_percentage
from goal_ranges
order by success_percentage desc;

















