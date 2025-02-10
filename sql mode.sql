--Aggregate functions 
--	COUNT counts how many rows are in a particular column.
--	SUM adds together all the values in a particular column.
--	MIN and MAX return the lowest and highest values in a particular column, respectively.
--	AVG calculates the average of a group of selected values.

--Count(1) == count(*)
--Sql top 100 , otros limit 100

select count(*) from  aapl_historical_stock_price
select count(1) from  aapl_historical_stock_price

/*
Counting individual columns
Count columna cuenta solo los que no son nulos de la columna.
*/
select count(*) from aapl_historical_stock_price
select count(volume) from aapl_historical_stock_price


/* SQL SUM */
select SUM(volume) as volume from aapl_historical_stock_price

/* Min and Max
Pueden ser usados con no numerical columns,
MIN will return the lowest number, earliest date, close alphabetically to "A" as possible. 
MAX returns the highest number, the latest date, or the non-numerical value closest alphabetically to "Z."
*/ 
SELECT MIN(volume) AS min_volume,
       MAX(volume) AS max_volume
  FROM aapl_historical_stock_price

/*  AVG
it can only be used on numerical columns
Ignores nulls completely.
*/ 

SELECT AVG(high)
  FROM aapl_historical_stock_price
 WHERE high IS NOT NULL

--Es lo mismo

SELECT AVG(high)
  FROM aapl_historical_stock_price



/* group by */ 
/* allows you separate data into groups */

select year, count(*) as cantidad
from aapl_historical_stock_price
group by year
order by year

select year, month, count(*) as cantidad
from aapl_historical_stock_price
group by year, month
order by year, month

/* group by column numbers */
select year, month, count(*) as cantidad
from aapl_historical_stock_price
group by 1, 2

/* using group by with order by */
select year, month, count(*) as count
from aapl_historical_stock_price
group by year, month 
order by year, month



/* HAVING
is the 'clean' way to filter a query that has been agregated, 
but this is also commonly done using a subquery
*/
select year, month, max(high) as month_high
from aapl_historical_stock_price
group by year, month
having max(high) > 400
order by year, month 

/* CASE */ 
select player_name, year, 
case when year = 'SR' then 'yes' else null end as is_a_senior
from college_football_players



/* Adding multiple conditions to a CASE statement */
select player_name, year, 
weight,
case when weight > 250 then 'over 250'
	 when weight > 200 AND weight <= 250 then '201 - 250'
	 when weight > 175 AND weight <= 200 then '176 - 200'
	 else '175 or under' end as weight_group
from college_football_players



select player_name, year, position, 
case when year = 'FR' and position = 'WR' then 'frosh_wr'
	else null end as sample_case_statement
from college_football_players


	

/*	Write a query that selects all columns from benn.college_football_players 
and adds an additional column that displays the player's name if that player is a junior or senior. */

select full_school_name, school_name, player_name, position, 
height, weight, year, hometown, state, id, 
case when year = 'SR' or year = 'JR' then player_name	
	ELSE null end as player_name
from college_football_players


/*
Using CASE with aggregate functions
*/

-- para poder contar también los nulos
select 
case when year = 'FR' then 'FR'
	else 'NOT FR' END AS year_group,
	count(1) as count
from college_football_players
group by case when year = 'FR' then 'FR'
	else 'NOT FR' END 

select year, count(1) as count
from college_football_players
group by year



--counting multiple conditions

select case when year = 'FR' then 'FR'
			when year = 'SO' then 'SO'
			when year = 'JR' then 'JR'
			when year = 'SR' then 'SR'
		ELSE 'NO YEAR DATA' END AS year_group,
		count(1) as count
from college_football_players
group by case when year = 'FR' then 'FR'
			when year = 'SO' then 'SO'
			when year = 'JR' then 'JR'
			when year = 'SR' then 'SR'
		ELSE 'NO YEAR DATA' END


/*
Write a query that counts the number of 300lb+ players for each of the following regions: 
West Coast (CA, OR, WA), Texas, and Other (everywhere else).
*/

select 
case when state IN ('CA', 'OR', 'WA') THEN 'West Coast'
	 when state = 'TX' THEN 'TEXAS'
	 ELSE 'OTHER' end AS regions, 
	 count(1) count
from college_football_players
where weight >= 300 
group by case when state IN ('CA', 'OR', 'WA') THEN 'West Coast'
	 when state = 'TX' THEN 'TEXAS'
	 ELSE 'OTHER' end 


--Write a query that calculates the combined weight of all underclass players (FR/SO) in California 
--as well as the combined weight of all upperclass players (JR/SR) in California.

select 
case when year in ('FR','SO') THEN 'underclass players'
	 when year in ('JR','SR') THEN 'upperclass players'
	 else '' end as players,
	 sum(weight) combined_weight
from college_football_players 
where state = 'CA'
group by case when year in ('FR','SO') THEN 'underclass players'
	 when year in ('JR','SR') THEN 'upperclass players'
	 else '' end 



--Using CASE inside of aggregate functions
--want to show data horizontally.

SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM college_football_players
 GROUP BY CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END


--And re-orient it horizontally
select  count(case when  year = 'FR' THEN 'FR' ELSE NULL END ) as fr_count,
		count(case when  year = 'SO' THEN 'SO' ELSE NULL END ) as so_count,
		count(case when  year = 'JR' THEN 'JR' ELSE NULL END ) as jr_count,
		count(case when  year = 'SR' THEN 'SR' ELSE NULL END ) as sr_count
FROM college_football_players		




--Write a query that displays the number of players in each state, with FR, SO, JR, and SR players in separate columns 
--and another column for the total number of players. 
--Order results such that states with the most players come first.

SELECT 
state ,
COUNT(CASE WHEN year = 'FR' then 'FR' else null end) as fr_count,
COUNT(CASE WHEN year = 'SO' then 'SO' else null end) as so_count,
COUNT(CASE WHEN year = 'JR' then 'JR' else null end) as jr_count,
COUNT(CASE WHEN year = 'SR' then 'SR' else null end) as sr_count,
count(1) total_number_players
FROM college_football_players		
group by state
order by total_number_players desc


--Write a query that shows the number of players at schools with names that start with A through M, 
--and the number at schools with names starting with N - Z.

select 
count(case when school_name < 'n' then school_name ELSE NULL end) as 'A-M',
count(case when school_name >= 'n' then school_name ELSE NULL end) as 'N-Z'
FROM college_football_players


--Using SQL DISTINCT for viewing unique values
--when you want to look at only the unique values in a particular column

SELECT DISTINCT month
FROM aapl_historical_stock_price

SELECT DISTINCT year, month
FROM aapl_historical_stock_price
order by year, month


--Write a query that returns the unique values in the year column, in chronological order.
select distinct year from aapl_historical_stock_price
order by year




--Using DISTINCT in aggregations
--counts the unique values in the month

select count(distinct month) as unique_month
from aapl_historical_stock_price


SELECT month,
       AVG(volume) AS avg_trade_volume
FROM aapl_historical_stock_price
GROUP BY month
ORDER BY month DESC


--DISTINCT performance
--using DISTINCT, particularly in aggregations, can slow your queries down quite a bit.

--Write a query that counts the number of unique values in the month column for each year.
select year,
count(distinct month) as month_count
FROM aapl_historical_stock_price
group by year


--Write a query that separately counts the number of unique values in the month column and 
--the number of unique values in the `year` column.

select
count(distinct month) as month_count, 
count(distinct year) as year_count
FROM aapl_historical_stock_price


/* JOINS */ 

--Write a query that selects the school name, player name, position, and weight for every player in Georgia, 
--ordered by weight (heaviest to lightest). 
--Be sure to make an alias for the table, and to reference all column names in relation to the alias.


select school_name, player_name, position, weight
from college_football_players players
where state = 'GA'
order by weight desc 


--Write a query that displays player names, school names and conferences for schools in the "FBS (Division I-A Teams)" division.

select players.player_name, players.school_name, teams.conference
from college_football_players players 
inner join college_football_teams teams
on players.school_name = teams.school_name
where division = 'FBS (Division I-A Teams)'


/*
LEFT JOIN
*/

select * from crunchbase_acquisitions 
where company_permalink = '/company/280-north'

SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase_companies companies
  JOIN crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
where companies.permalink = '/company/280-north'


SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase_companies companies
  LEFT JOIN crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink



--Write a query that performs an inner join between the tutorial.crunchbase_acquisitions table and the tutorial.crunchbase_companies table, 
--but instead of listing individual rows, count the number of non-null rows in each table.

select count(ac.company_permalink) ac_permalink , count(co.permalink) as co_permalink
from crunchbase_acquisitions ac 
inner join crunchbase_companies co
on co.permalink = ac.company_permalink



--Modify the query above to be a LEFT JOIN. Note the difference in results.
select count(ac.company_permalink) ac_permalink , count(co.permalink) as co_permalink
from crunchbase_acquisitions ac 
left join crunchbase_companies co
on co.permalink = ac.company_permalink


--Count the number of unique companies (don't double-count companies) and unique acquired companies by state. 
--Do not include results for which there is no state data,
--and order by the number of acquired companies from highest to lowest.

select * from crunchbase_acquisitions where company_state_code <> ''
select * from crunchbase_companies where state_code <> ''

select company_state_code, count(distinct company_name) as company_name, count(distinct name) as ac_name
from crunchbase_companies co
inner join crunchbase_acquisitions ac
on co.permalink = ac.company_permalink
where company_state_code <> ''
group by company_state_code
order by ac_name desc


--Rewrite the previous practice query in which you counted total and acquired companies by state, 
--but with a RIGHT JOIN instead of a LEFT JOIN. The goal is to produce the exact same results.

select company_state_code, count(distinct company_name) as company_name, count(distinct name) as ac_name
from crunchbase_acquisitions ac
right join crunchbase_companies co 
on ac.company_permalink = co.permalink
where company_state_code <> ''
group by company_state_code
order by ac_name desc


--Filtering in the ON clause

SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase_companies companies
  LEFT JOIN crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 ORDER BY 1


 SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase_companies companies
  LEFT JOIN crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
   AND acquisitions.company_permalink != '/company/1000memories'
 ORDER BY 1


 --Filtering in the WHERE clause

 SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase_companies companies
  LEFT JOIN crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE acquisitions.company_permalink != '/company/1000memories'
    OR acquisitions.company_permalink IS NULL
 ORDER BY 1



 --Write a query that shows a company's name, "status" (found in the Companies table), 
 --and the number of unique investors in that company. 
 --Order by the number of investors from most to fewest. 
 --Limit to only companies in the state of New York.

 select * from crunchbase_investments
 select * from crunchbase_companies

 select co.name as company, co.status, count(distinct inv.investor_name) AS count_inversors
 from crunchbase_companies co 
 left join crunchbase_investments inv 
 on co.permalink = inv.company_permalink
 where co.state_code = 'NY'
 group by co.name, co.status
 order by 3 desc



-- Write a query that lists investors based on the number of companies in which they are invested. 
-- Include a row for companies with no investor, 
-- and order from most companies to least.


 select * from crunchbase_investments
 select * from crunchbase_companies


 select 
 case when investor_name  is null then 'No Inversors' else investor_name end as inversor, 
 count(distinct co.permalink) as count_companies
  from crunchbase_companies co 
 left join crunchbase_investments inv 
 on co.permalink = inv.company_permalink
 group by investor_name
order by 2 desc



--The SQL FULL JOIN command

SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NULL
                  THEN companies.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN companies.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN companies.permalink IS NULL AND acquisitions.company_permalink IS NOT NULL
                  THEN acquisitions.company_permalink ELSE NULL END) AS acquisitions_only
  FROM crunchbase_companies companies
  FULL JOIN crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink



--Write a query that joins crunchbase_companies and crunchbase_investments_part1 using a FULL JOIN. 
--Count up the number of rows that are matched/unmatched as in the example above.

SELECT COUNT(CASE WHEN co.permalink IS NOT NULL AND inv.company_permalink IS NULL
                  THEN co.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN co.permalink IS NOT NULL AND inv.company_permalink IS NOT NULL
                  THEN co.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN co.permalink IS NULL AND inv.company_permalink IS NOT NULL
                  THEN inv.company_permalink ELSE NULL END) AS investments_only
  FROM crunchbase_companies co
  FULL JOIN crunchbase_investments inv
    ON co.permalink = inv.company_permalink



--UNION

--Write a query that appends the two crunchbase_investments datasets above (including duplicate values). 
--Filter the first dataset to only companies with names that start with the letter "T", 
--and filter the second to companies with names starting with "M" (both not case-sensitive). 
--Only include the company_permalink, company_name, and investor_name columns.



 select * from crunchbase_investments
 select * from crunchbase_companies

select co.permalink, co.name, inv.investor_name
FROM crunchbase_companies co
inner JOIN crunchbase_investments inv
ON co.permalink = inv.company_permalink
and co.name >= 'M' 
and co.name < 'N' 


UNION ALL 

select co.permalink, co.name, inv.investor_name
FROM crunchbase_companies co
inner JOIN crunchbase_investments inv
ON co.permalink = inv.company_permalink
and co.name >= 'T' 
and co.name < 'U' 


--Write a query that shows 3 columns. 
--The first indicates which dataset (part 1 or 2) the data comes from, 
--the second shows company status, and 
--the third is a count of the number of investors.

--Hint: you will have to use the tutorial.crunchbase_companies table as well as 
--the investments tables. 
--And you'll want to group by status and dataset.


 select * from crunchbase_investments
 select * from crunchbase_companies

select 'DATA1' as dataset, co.status , count(distinct inv.investor_name) as count_investors
FROM crunchbase_companies co
left JOIN crunchbase_investments inv
ON co.permalink = inv.company_permalink
group by co.status

union all

select 'DATA2' as dataset, co.status , count(distinct inv.investor_name) as count_investors
FROM crunchbase_companies co
left JOIN crunchbase_investments inv
ON co.permalink = inv.company_permalink
group by co.status



--Using comparison operators with joins

--using > to join only investments that occurred more than 5 years after each company's founding year:
SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM crunchbase_companies companies
  LEFT JOIN crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5
 GROUP BY companies.permalink,
       companies.name,
       companies.status


--Joining on multiple keys

--the results of the following query will be the same with or without the last line. 
--However, it is possible to optimize the database such that the query runs more quickly with the last line included:


SELECT companies.permalink,
       companies.name,
       investments.company_name,
       investments.company_permalink
  FROM crunchbase_companies companies
  LEFT JOIN crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
   AND companies.name = investments.company_name



--Identify companies that received an investment from Great Britain following an investment from Japan.
SELECT DISTINCT japan_investments.company_name,
	   japan_investments.company_permalink
  FROM crunchbase_investments japan_investments
  JOIN crunchbase_investments gb_investments
    ON japan_investments.company_name = gb_investments.company_name
   
   AND gb_investments.investor_country_code = 'GBR'
   AND gb_investments.funded_at > japan_investments.funded_at

 WHERE japan_investments.investor_country_code = 'JPN'
 ORDER BY 1



 --Changing a column's data type
 --can use CAST or CONVERT to change the data type 


--Using SQL String Functions to Clean Data

SELECT * FROM sf_crime_incidents_2014_01


--Cleaning strings

--LEFT, RIGHT, and LENGTH
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date
FROM sf_crime_incidents_2014_01

--RIGHT 
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       RIGHT(date, 17) AS cleaned_time
  FROM sf_crime_incidents_2014_01


--The LENGTH function returns the length of a string
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       RIGHT(date, LEN(date) - 11) AS cleaned_time
  FROM sf_crime_incidents_2014_01



-- TRIM
SELECT location,
       TRIM(both '()' FROM location)
  FROM sf_crime_incidents_2014_01

SELECT TRIM('#! ' FROM '    #SQL Tutorial!    ') AS TrimmedString;


--TRIM( \\[ [{LEADING | TRAILING | BOTH}\\] [removal_character] 
--FROM ] target_string )

--LEADING, TRAILING, or BOTH defines whether to remove the removal_character at the beginning, end, 
--or on both sides of target_string, respectively. 
--If omitted, this defaults to BOTH.


--CHARINDEX -- EN VEZ DE POSITION and STRPOS

--  SELECT POSITION( 'DELHI' IN 'NEW DELHI') AS POSITION_DELHI;  
  SELECT CHARINDEX('a', 'database' ) AS position



--SUBSTRING EN VEZ DE SUBSTR
SELECT SUBSTRING('database', 2, 3) as subcadena;


--Write a query that separates the `location` field into separate fields for latitude and longitude. 
--You can compare your results against the actual `lat` and `lon` fields in the table.

select location, 
substring(location, 2, CHARINDEX(',', location)-2) as latitude,
lat,
substring(location, CHARINDEX(',', location)+1, len(location)-(CHARINDEX(',', location)+1)  ) as longitud,
lon
FROM sf_crime_incidents_2014_01


--CONCAT
SELECT CONCAT('W3Schools', '.com');


--Concatenate the lat and lon fields to form a field that is equivalent to the location field. (Note that the answer will have a different decimal precision.)
select lon, lat, location,
concat('(',lat, ',', lon, ')') as new_location
FROM sf_crime_incidents_2014_01


--Write a query that creates a date column formatted YYYY-MM-DD.
select date, 
substring(date, 1,2) as day,
substring(date, 4,2) as month,
substring(date, 7,4) as year,
concat(substring(date, 7,4), '-', substring(date, 1,2), '-', substring(date, 4,2)) as new_date
FROM sf_crime_incidents_2014_01


-- upper adn lower
SELECT incidnt_num,
       address,
       UPPER(address) AS address_upper,
       LOWER(address) AS address_lower
  FROM sf_crime_incidents_2014_01



--  COALESCE
-- replace the nulls values 
SELECT incidnt_num,
       descript,
       COALESCE(descript, 'No Description')
  FROM tutorial.sf_crime_incidents_cleandate
 ORDER BY descript DESC


 --The COALESCE() function returns the first non-null value in a list.
 SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');

 SELECT 
  first_name,
  last_name,
  COALESCE(marital_status,'Unknown')
FROM persons


--Subquery basics

--Write a query that selects all Warrant Arrests from the sf_crime_incidents_2014_01 dataset, 
--then wrap it in an outer query that only displays unresolved incidents.

select arrests.* 
from (
	select * from sf_crime_incidents_2014_01
	where descript = 'WARRANT ARREST'
	) as arrests
where arrests.resolution = 'NONE'



--Write a query that displays the average number of monthly incidents for each category. 
--Hint: use tutorial.sf_crime_incidents_cleandate to make your life a little easier.

select incidents.category, AVG(incidents.cantidad) as average
from (
		select category, substring(date, 1, 2) as month, count(*) as cantidad
		from sf_crime_incidents_cleandate 
		group by category, substring(date, 1, 2) 

	) as incidents
group by incidents.category


select * from sf_crime_incidents_cleandate 



--Subqueries in conditional logic


--all of the entries from the earliest date
select * 
from sf_crime_incidents_2014_01
where date = ( select min(date) from sf_crime_incidents_2014_01)


--Most conditional logic will work with subqueries containing one-cell results

select * 
from sf_crime_incidents_2014_01
where date in (
		select top 5 date 
		from sf_crime_incidents_2014_01
		order by date
		)
		


--Joining subqueries

select *
from sf_crime_incidents_2014_01 incidents
join (
		select top 5 date 
		from sf_crime_incidents_2014_01
		order by date 		
	)sub
on incidents.date = sub.date


select incidents.*, 
sub.incidents as incidents_that_day
from sf_crime_incidents_2014_01 incidents
join (
	select date, 
	count(incidnt_num) as incidents
	from sf_crime_incidents_2014_01
	group by date
	) sub
on incidents.date = sub.date 
order by sub.incidents desc, time



--Write a query that displays all rows from the three categories with the fewest incidents reported.
select inc.*, sub.incident_number
from sf_crime_incidents_2014_01 as inc
join (
	select top 3 category, count(incidnt_num) as incident_number
	from sf_crime_incidents_2014_01
	group by category
	order by count(incidnt_num) 
)sub
on inc.category = sub.category


--Write a query that counts the number of companies founded and acquired by quarter starting in Q1 2012. 
--Create the aggregations in two separate queries, then join them.
	
	select coalesce(com.founded_quarter,ac.acquired_quarter) as quarter, com.count_founded_quarter,  ac.count_acq_quarter
	from 
		(				
			select founded_quarter, count(founded_quarter) as count_founded_quarter
			from crunchbase_companies 
			where founded_quarter >= '2012-Q1'
			group by founded_quarter
		) as com	

		join (
			select acquired_quarter, count(acquired_quarter) as count_acq_quarter
			from crunchbase_acquisitions
			where acquired_quarter >= '2012-Q1'
			group by acquired_quarter
		) AS ac
		on ac.acquired_quarter = com.founded_quarter
	order by 1 
			



--Write a query that ranks investors from the combined dataset above by the total number of investments they have made.

select investor_name, count(investor_name) as total_number_investments
from (

	select  *
	from crunchbase_investments
	
	union all 

	select *
	from crunchbase_investments_part2


	)as inv
group by investor_name
order by investor_name




--Write a query that does the same thing as in the previous problem, 
--except only for companies that are still operating. 
--Hint: operating status is in tutorial.crunchbase_companies.

		
select investor_name, count(investor_name) as total_number_investments
from (
	select  investor_name
	from crunchbase_investments inv
	inner join crunchbase_companies co
	on co.permalink = inv.company_permalink
	where status = 'operating'
	
	union all 

	select investor_name 
	from crunchbase_investments_part2 inv2
	inner join crunchbase_companies com
	on com.permalink = inv2.company_permalink
	where status = 'operating'

	) as invest
group by investor_name
order by 2 desc
	


--Windows Function

SELECT duration_seconds, 
       SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
  FROM dc_bikeshare_q1_2012

  select * from dc_bikeshare_q1_2012
  order by start_time

  --suma los segundos agrupados por terminal y ordenados por start_time
select start_terminal, start_time, duration_seconds,
sum(duration_seconds) over
	(partition by start_terminal order by start_time)  as running_total
from dc_bikeshare_q1_2012
where start_time < '2012-01-08'
order by start_time


-- you can't include window functions in a GROUP BY clause.


--Write a query modification of the above example query that 
--shows the duration of each ride as a percentage of the total time accrued by riders 
--from each start_terminal

  select start_terminal, duration_seconds, 
  sum(duration_seconds) over(partition by start_terminal) as suma, 
  (duration_seconds / sum(duration_seconds) over(partition by start_terminal ) ) *100 as promedio
  from dc_bikeshare_q1_2012
  order by 1,4



SELECT start_terminal, 
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_total,
       COUNT(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_count,
       AVG(duration_seconds) OVER
         (PARTITION BY start_terminal) AS running_avg
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'


 -- with order by
 SELECT start_terminal, 
		start_time,
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time)
         AS running_total,
       COUNT(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time)
         AS running_count,
       AVG(duration_seconds) OVER
         (PARTITION BY start_terminal ORDER BY start_time)
         AS running_avg
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 order by 1, 2


-- Write a query that shows a running total of the duration of bike rides (similar to the last example), 
--but grouped by end_terminal, 
--and with ride duration sorted in descending order.

 SELECT end_terminal, 		
       duration_seconds,
       SUM(duration_seconds) OVER
         (PARTITION BY end_terminal ORDER BY duration_seconds desc)
         AS running_total
 FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'



 --ROW_NUMBER()

 Select 
	 start_terminal,
	 start_time,
	 duration_seconds,
	 row_number() over (order by start_time) as row_number
 FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'



 Select 
	 start_terminal,
	 start_time,
	 duration_seconds,
	 row_number() over (partition by start_terminal order by start_time) as row_number
 FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'


 --RANK() and DENSE_RANK()

 Select 
	 start_terminal,
	 start_time,
	 duration_seconds,
	 rank() over (partition by start_terminal order by start_time) as rank
 FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'


 Select 
	 start_terminal,
	 start_time,
	 duration_seconds,
	 dense_rank() over (partition by start_terminal order by start_time) as dense_rank
 FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'



 --Write a query that shows the 5 longest rides from each starting terminal, 
 --ordered by terminal, 
 --and longest to shortest rides within each terminal. 
 --Limit to rides that occurred before Jan. 8, 2012.

 select *
 from 
	(
	 select start_terminal,
		duration_seconds,
		rank() over (partition by start_terminal order by duration_seconds desc ) as rank
	 FROM dc_bikeshare_q1_2012
	 WHERE start_time < '2012-01-08'
	 ) sub
 where sub.rank <= 5


 --NTILE
 -- divide la partición en el número que tiene entre parentesis.

 SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
          AS quartile,
       NTILE(5) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS quintile,
       NTILE(100) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS percentile
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds



-- Write a query that shows only the duration of the trip and 
--the percentile into which that duration falls (across the entire dataset—not partitioned by terminal).

select duration_seconds, 
	NTILE(100) over(order by duration_seconds) as percentile
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 order by 1 desc


-- LAG and LEAD
-- lag pone el registro anterior y lead el registro posterior.

SELECT start_terminal,
       duration_seconds,
       LAG(duration_seconds, 1) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag,
       LEAD(duration_seconds, 1) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds




 --This is especially useful if you want to calculate differences between rows:

 SELECT start_terminal,
       duration_seconds,
       duration_seconds -
			LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS difference
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds


 --Defining a window alias

 
 SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER ntile_window AS quartile,
       NTILE(5) OVER ntile_window AS quintile,
       NTILE(100) OVER ntile_window AS percentile
  FROM dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
WINDOW ntile_window AS
         (PARTITION BY start_terminal ORDER BY duration_seconds)
 ORDER BY start_terminal, duration_seconds




 --Pivoting rows to columns

 SELECT teams.conference AS conference,
       players.year,
       COUNT(1) AS players
  FROM college_football_players players
  JOIN college_football_teams teams
    ON teams.school_name = players.school_name
 GROUP BY teams.conference, players.year
 ORDER BY 1,2


SELECT *
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
          FROM college_football_players players
          JOIN college_football_teams teams
            ON teams.school_name = players.school_name
         GROUP BY teams.conference, players.year
       ) sub



SELECT conference,
       SUM(CASE WHEN year = 'FR' THEN players ELSE 0 END) AS fr,
       SUM(CASE WHEN year = 'SO' THEN players ELSE 0 END) AS so,
       SUM(CASE WHEN year = 'JR' THEN players ELSE 0 END) AS jr,
       SUM(CASE WHEN year = 'SR' THEN players ELSE 0 END) AS sr
  FROM (
        SELECT teams.conference,
               players.year,
               COUNT(1) AS players
          FROM college_football_players players
          JOIN college_football_teams teams
            ON teams.school_name = players.school_name
         GROUP BY teams.conference,players.year
       ) sub
 GROUP BY conference
 ORDER BY 1


SELECT conference, [FR] , [SO], [JR], [SR]
FROM
    (        
          SELECT teams.conference,
               players.year,
               COUNT(1) AS players
          FROM college_football_players players
          JOIN college_football_teams teams
            ON teams.school_name = players.school_name
         GROUP BY teams.conference,players.year
    ) AS source
PIVOT
(    
    SUM(players)
    FOR year IN([FR], [SO], [JR], [SR])
) AS pivot_table;














