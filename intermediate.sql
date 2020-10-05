--Write a query to count the number of non-null rows in the low column.

SELECT COUNT(low) AS count_of_low
  FROM tutorial.aapl_historical_stock_price

--Write a query that determines counts of every single column. Which column has the most null values?

SELECT COUNT(date) AS count_of_date,
       COUNT(year) AS count_of_year,
       COUNT(month) AS count_of_month,
       COUNT(open) AS count_of_open,
       COUNT(high) AS count_of_high, --this column has the most null values
       COUNT(low) AS count_of_low,
       COUNT(close) AS count_close,
       COUNT(volume) AS count_of_volume,
       COUNT(id) AS count_of_id
  FROM tutorial.aapl_historical_stock_price

--Write a query to calculate the average opening price 
--(hint: you will need to use both COUNT and SUM, as well as some simple arithmetic.)

SELECT COUNT(open) AS count_of_open,
       SUM(open) AS sum_of_open,
       SUM(open)/COUNT(open) AS calc_avg_open_price,
       AVG(open) AS avg_of_open --to check manual avg calc
  FROM tutorial.aapl_historical_stock_price

--What was Apple's lowest stock price (at the time of this data collection)?

SELECT MIN(low) AS lowest_price
  FROM tutorial.aapl_historical_stock_price

--What was the highest single-day increase in Apple's share value?

SELECT MAX(close - open) AS max_single_day_increase
  FROM tutorial.aapl_historical_stock_price

--Write a query that calculates the average daily trade volume for Apple stock.

SELECT AVG(volume) AS avg_dly_trade_volume
  FROM tutorial.aapl_historical_stock_price

--Calculate the total number of shares traded each month. Order your results chronologically.

SELECT year,
       month,
       SUM(volume) AS monthly_volume
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month
 ORDER BY year, month

--Write a query to calculate the average daily price change in Apple stock, grouped by year.

SELECT year,
       AVG(close - open) AS avg_dly_price_change
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year
 ORDER BY year

--Write a query that calculates the lowest and highest prices that Apple stock achieved each month.

SELECT year,
       month,
       MIN(low) AS min_monthly_price,
       MAX(high) AS max_monthly_price
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month
 ORDER BY year, month

--Write a query that includes a column that is flagged "yes" when a player is from California, 
--and sort the results with those players first.

SELECT player_name,
       hometown,
       CASE WHEN state = 'CA' THEN 'yes'
            ELSE 'no' END AS from_California
  FROM benn.college_football_players
  ORDER BY from_California DESC

--Write a query that includes players' names and a column that classifies them into four categories based on height. 
--Keep in mind that the answer we provide is only one of many possible answers, since you could divide players' heights in many ways.

SELECT player_name,
       height,
       CASE WHEN height > 77 THEN 'over 6 1/2 ft'
            WHEN height > 72 AND height <= 77 THEN 'between 6 & 6 1/2 ft'
            WHEN height > 60 AND height <= 72 THEN 'between 5-6 ft'
            ELSE 'under 5 ft' END AS player_height
  FROM benn.college_football_players

--Write a query that selects all columns from benn.college_football_players and adds an additional column that displays the player's name if that player is a junior or senior.

SELECT *,
       CASE WHEN year = 'JR' OR year = 'SR' THEN player_name
            ELSE NULL END AS junior_senior
  FROM benn.college_football_players

--Write a query that counts the number of 300lb+ players for each of the following regions: West Coast (CA, OR, WA), Texas, and Other (Everywhere else).

SELECT CASE WHEN state in ('CA','OR','WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS region,
            COUNT(1) AS count
  FROM benn.college_football_players
WHERE weight >= 300
GROUP BY 1

--Write a query that calculates the combined weight of all underclass players (FR/SO) in California as well as the combined weight of all upperclass players (JR/SR) in California.

SELECT CASE WHEN year in ('FR','SO') THEN 'ca_underclass'
            WHEN year in ('JR','SR') THEN 'ca_upperclass'
            ELSE NULL END AS class_group,
            SUM(weight) AS total_weight
  FROM benn.college_football_players
WHERE state = 'CA'
GROUP BY 1

--Write a query that displays the number of players in each state, with FR, SO, JR, and SR players in separate columns and another column for the total number of players. Order results such that states with the most players come first.

SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(player_name) AS total_players
  FROM benn.college_football_players
  GROUP BY state
  ORDER BY 6 DESC

--Write a query that shows the number of players at schools with names that start with A through M, and the number at schools with names starting with N - Z.

SELECT CASE WHEN school_name < 'N' THEN 'A-M'
       ELSE 'N-Z' END AS name,
       COUNT(1) AS player_count
  FROM benn.college_football_players
  GROUP BY 1

--Write a query that returns the unique values in the year column, in chronological order.

SELECT DISTINCT year
  FROM tutorial.aapl_historical_stock_price
  ORDER BY year

--Write a query that counts the number of unique values in the month column for each year.

SELECT year, COUNT (DISTINCT month) AS month_count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year

--Write a query that separately counts the number of unique values in the month column and the number of unique values in the `year` column

SELECT COUNT(DISTINCT year) AS year_count, COUNT (DISTINCT month) AS month_count
  FROM tutorial.aapl_historical_stock_price

--Write a query that selects the school name, player name, position, and weight for every player in Georgia, ordered by weight (heaviest to lightest). 
--Be sure to make an alias for the table, and to reference all column names in relation to the alias.

SELECT players.school_name AS school,
       players.player_name AS name,
       players.position AS position,
       players.weight AS weight
  FROM benn.college_football_players players
  WHERE players.state = 'GA'
 ORDER BY players.weight DESC

--Write a query that displays player names, school names and conferences for schools in the "FBS (Division I-A Teams)" division.

SELECT p.player_name, p.school_name, t.conference
  FROM benn.college_football_players p
  JOIN benn.college_football_teams t
    ON t.school_name = p.school_name
  WHERE t.division LIKE 'FBS%'

--Write a query that performs an inner join between the tutorial.crunchbase_acquisitions table and the tutorial.crunchbase_companies table, 
--but instead of listing individual rows, count the number of non-null rows in each table.

SELECT COUNT(companies.permalink) AS company_count,
       COUNT(acquisitions.company_permalink) AS acquisition_count
  FROM tutorial.crunchbase_companies companies
  JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink

--Modify the query above to be a LEFT JOIN. Note the difference in results.

SELECT COUNT(companies.permalink) AS company_count,
       COUNT(acquisitions.company_permalink) AS acquisition_count
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
--contains all the rows in tutorial.crunchbase_companies instead of just the ones that are in the acquisitions table

--Count the number of unique companies (don't double-count companies) and unique acquired companies by state. Do not include results 
--for which there is no state data, and order by the number of acquired companies from highest to lowest.

SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_company_count,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_acquisition_count
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
  WHERE companies.state_code IS NOT NULL
  GROUP BY companies.state_code
  ORDER BY 3 DESC

--Rewrite the previous practice query in which you counted total and acquired companies by state, 
--but with a RIGHT JOIN instead of a LEFT JOIN. The goal is to produce the exact same results.

SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_company_count,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_acquisition_count
  FROM tutorial.crunchbase_acquisitions acquisitions
  RIGHT JOIN tutorial.crunchbase_companies companies
    ON companies.permalink = acquisitions.company_permalink
  WHERE companies.state_code IS NOT NULL
  GROUP BY companies.state_code
  ORDER BY 3 DESC

--Write a query that shows a company's name, "status" (found in the Companies table), and the 
--number of unique investors in that company. Order by the number of investors from most to fewest. 
--Limit to only companies in the state of New York.

SELECT c.name, c.status, COUNT(DISTINCT i.investor_name) AS unique_investors
  FROM tutorial.crunchbase_companies c
  LEFT JOIN tutorial.crunchbase_investments i
    ON c.permalink = i.company_permalink
  WHERE c.state_code = 'NY'
  GROUP BY 1, 2
 ORDER BY 3 DESC

--Write a query that lists investors based on the number of companies in which they are invested. 
--Include a row for companies with no investor, and order from most companies to least.

SELECT i.investor_name, COUNT(DISTINCT c.name) AS company_count
  FROM tutorial.crunchbase_companies c
  LEFT JOIN tutorial.crunchbase_investments i
    ON c.permalink = i.company_permalink
  GROUP BY 1
 ORDER BY 2 DESC

--Write a query that joins tutorial.crunchbase_companies and tutorial.crunchbase_investments_part1 using a FULL JOIN. 
--Count up the number of rows that are matched/unmatched as in the example above.

SELECT COUNT(CASE WHEN c.permalink IS NOT NULL AND i.company_permalink IS NULL
                  THEN c.permalink ELSE NULL END) AS companies_only,
       COUNT(CASE WHEN c.permalink IS NOT NULL AND i.company_permalink IS NOT NULL
                  THEN c.permalink ELSE NULL END) AS both_tables,
       COUNT(CASE WHEN c.permalink IS NULL AND i.company_permalink IS NOT NULL
                  THEN i.company_permalink ELSE NULL END) AS investments_only
  FROM tutorial.crunchbase_companies c
  FULL JOIN tutorial.crunchbase_investments_part1 i
    ON c.permalink = i.company_permalink

--Write a query that appends the two crunchbase_investments datasets above (including duplicate values). 
--Filter the first dataset to only companies with names that start with the letter "T", and filter the 
--second to companies with names starting with "M" (both not case-sensitive). Only include the company_permalink, company_name, and investor_name columns.

SELECT company_permalink, company_name, investor_name
  FROM tutorial.crunchbase_investments_part1
  WHERE company_name ILIKE 'T%'

 UNION ALL

 SELECT company_permalink, company_name, investor_name
   FROM tutorial.crunchbase_investments_part2
  WHERE company_name ILIKE 'M%'

--Write a query that shows 3 columns. The first indicates which dataset (part 1 or 2) the data comes from, 
--the second shows company status, and the third is a count of the number of investors.

SELECT 'investments_part1' AS dataset_name,
       c.status,
       COUNT(DISTINCT i.investor_permalink) AS investor_count
  FROM tutorial.crunchbase_companies c
  LEFT JOIN tutorial.crunchbase_investments_part1 i
    ON c.permalink = i.company_permalink
  GROUP BY 1,2

 UNION ALL

 SELECT 'investments_part2' AS dataset_name,
       c.status,
       COUNT(DISTINCT i.investor_permalink) AS investor_count
   FROM tutorial.crunchbase_companies c
   LEFT JOIN tutorial.crunchbase_investments_part2 i
    ON c.permalink = i.company_permalink
  GROUP BY 1,2











