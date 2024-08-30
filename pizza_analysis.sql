create database pizzasales;

use pizzasales;

select * 
from 
	pizza_sales;

-- 1. total Revenue: the sum of the total price of all pizza order

select 
	sum(total_price) as total_revenue
from 
	pizza_sales;


-- 2. : the avg amount spent per order
with cte as (
select 
	sum(total_price) as amount_per_order, 
	order_id
from 
	pizza_sales
group by 
	order_id ),
final_cte as (
select 
	sum(amount_per_order) as total_revenue, 
	count(1) as total__orders
from 
	cte)
select 
	total_revenue / total__orders as Average_order_value
from 
	final_cte;


-- 3. total pizzas sold: 

select 
	sum(quantity) as total_pizza_sold
from
	pizza_sales;

-- 4. total orders

select 
	count(distinct order_id) as total_orders
from 
	pizza_sales;

-- 5. avg pizza's per order

with cte as (
select 
	sum(quantity) as quan_per_order, 
	order_id
from 
	pizza_sales
group by 
	order_id ),
final_cte as (
select 
	sum(quan_per_order) total_pizza_quan, 
	count(1) as cnt_order
from 
	cte)
select 
	cast(total_pizza_quan * 1.0/ cnt_order as decimal(10, 2)) as avg_pizza_order
from 
	final_cte;


--*********************************************************************************************************************************************
-- chart requirements
--*********************************************************************************************************************************************

 -- 1. daily trend for total orders: 
						-- create a bar chart that displays the daily trend of total orders over a specific time period. this chart will help
						-- use identify any patterns or fluctuatuions in  order volumnes on a dauly basis

select 
	DATENAME(WEEKDAY, order_date) as day_of_week, 
	COUNT(distinct order_id) as total_orders_per_day, 
	cast(sum(total_price) as decimal(10, 2)) as total_sales_per_day
from 
	pizza_sales
group by  
	DATENAME(WEEKDAY, order_date)
order by 
	total_sales_per_day desc, day_of_week ;



-- 2. Hourly trend for total Orders:

select 
	DATEPART(HOUR, order_time) AS Hour_of_day, 
	COUNT(distinct order_id) as total_orders_per_hor, 
	cast(sum(total_price) as decimal(10, 2)) as total_sales_per_day
from 
	pizza_sales
group by  
	DATEPART(HOUR, order_time)
order by 
	HOUR_of_day,
	total_sales_per_day desc ;

-- 3. Percenage opf sales bby pizza category

with cte as (
select 
	pizza_category, 
	sum(total_price) as sales_per_category
from 
	pizza_sales
group by 
	pizza_category )
select pizza_category, sales_per_category, cast(sales_per_category *100.0 / sum(sales_per_category) over() as decimal(10, 2)) as perc_sales_per_category
from cte;

-- If we want to see sales per month we can do that as well


-- perc sold per pizza size

with cte as (
select 
	pizza_size, 
	sum(total_price) as sales_per_category
from 
	pizza_sales
group by 
	pizza_size )
select 
	pizza_size, 
	sales_per_category, 
	cast(sales_per_category *100.0 / sum(sales_per_category) over() as decimal(10, 2)) as perc_sales_per_category
from cte;


-- total pizza's sold by pizza category

select 
	pizza_category, 
	sum(quantity) as quantity_per_category
from 
	pizza_sales
group by 
	pizza_category ;


-- top 5 best seller by total pizza's sold

select 
	top 5
	pizza_name,
	sum(quantity) as quan_per_name
from 
	pizza_sales
group by 
	pizza_name 
order by 
	quan_per_name desc;


-- top 5 worst seller by total pizza's sold

select 
	top 5
	pizza_name,
	sum(quantity) as quan_per_name
from 
	pizza_sales
group by 
	pizza_name 
order by 
	quan_per_name;