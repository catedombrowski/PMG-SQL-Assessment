create table marketing_data (
 "date" date,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);

create table website_revenue (
 "date" date,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);

create table campaign_info (
 id int not null primary key,
 name varchar(50),
 status varchar(50),
 last_updated_date timestamp
);

-------------------------
-- Question 1

SELECT
    "date",
    SUM(impressions) as total_impressions
FROM marketing_data
GROUP BY
    "date"
ORDER BY total_impressions DESC
;

--------------------------------
--Question 2

SELECT
    SUM(revenue) as total_revenue,
    state
FROM
    website_revenue
GROUP BY
    state
ORDER BY 
    total_revenue DESC
FETCH FIRST 3 ROWS ONLY;

---------------------------------
--Question 3

SELECT
    SUM(mark.cost),
    SUM(mark.impressions),
    SUM(mark.clicks),
    SUM(rev.revenue),
    camp.name
FROM
    marketing_data mark
    INNER JOIN
    website_revenue rev
    ON
    mark.campaign_id = rev.campaign_id
    INNER JOIN
    campaign_info camp
    ON
    mark.campaign_id = camp.id
GROUP BY
    camp.name
ORDER BY
    camp.name
;
---------------------------------------
--Question 4

SELECT 
    SUM(mark.conversions) as total_conversions,
    rev.state
FROM
    marketing_data mark
    INNER JOIN
    campaign_info camp
    ON
    mark.campaign_id = camp.id
    INNER JOIN
    website_revenue rev
    ON
    mark.campaign_id = rev.campaign_id
WHERE
    camp.name = 'Campaign5'
GROUP BY
    rev.state
ORDER BY
    total_conversions DESC
;
---------------------------------------
--Question 5
--I think Campaign 2 was the most efficient because it had the least cost per click while having the highest conversion rate and second highest return on spend.

SELECT
    ROUND(SUM(mark.conversions)/SUM(mark.clicks),2) as conversion_rate,
    ROUND(SUM(mark.conversions)/SUM(mark.cost),2) as cost_per_conversion,
    ROUND(SUM(mark.clicks)/SUM(mark.cost),2) as cost_per_click,
    ROUND(SUM(rev.revenue)/SUM(mark.cost),2) as return_on_spend,
    camp.name
FROM
    marketing_data mark
    INNER JOIN
    website_revenue rev
    ON
    mark.campaign_id = rev.campaign_id
    INNER JOIN
    campaign_info camp
    ON
    mark.campaign_id = camp.id
GROUP BY 
    camp.name
ORDER BY
    cost_per_click
;
---------------------------------------
--Bonus Question
--Friday is the best day of the week to run ads because it results in the highest number of impressions, highest number of conversions, and second highest clicks (just 31 clicks behind Saturday).

SELECT
    TO_CHAR("date", 'Day') AS day_of_week,
    SUM(cost) as total_cost,
    SUM(impressions) as total_impressions,
    SUM(conversions) as total_conversions,
    SUM(clicks) as total_clicks
FROM
    marketing_data
GROUP BY
    TO_CHAR("date", 'Day')
ORDER BY
    total_impressions DESC
;
   
