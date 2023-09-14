

--Finding the KPI's Total revenue, total profit, total orders, profit margin
SELECT 
sum(revenue) as total_revenue,
sum(profit) as total_profit,
count(*) as total_orders,
sum(profit)/ sum(revenue) *100 as profit_margin
from [Sport Sales].dbo.orders

--Total revenue, total profit, total orders, profit margin for each sport
SELECT
sport,
round(sum(revenue),2) as total_revenue,
round(sum(profit),2) as total_profit,
 count(order_id) as total_orders,
sum(profit)/ sum(revenue) *100 as profit_margin
from [Sport Sales].dbo.orders
group by sport
order by profit_margin desc

-- Avg Rating and no of reviews

select round(avg(rating),2) as avg_rating, 
 (select count(*) from orders where rating is not null) as no_of_reviews 
from orders

---KPI's Total revenue, total profit, total orders, profit margin against review
SELECT
rating,
round(sum(revenue),2) as total_revenue,
round(sum(profit),2) as total_profit,
 count(order_id) as total_orders,
sum(profit)/ sum(revenue) *100 as profit_margin
from [Sport Sales].dbo.orders
where rating is not null
group by rating
order by rating desc

---Finding revenue total profit, total orders, profit margin for each state

select 
c.state,
ROW_NUMBER() over(order by sum(o.revenue) desc) as revenue_rank,
sum(o.revenue) as total_revenue,
ROW_NUMBER() over(order by sum(o.profit) desc) as profit_rank,
sum(o.profit) as total_profit,
ROW_NUMBER() over(order by sum(o.profit)/sum(o.revenue) desc) as margin_rank,
sum(o.profit)/sum(o.revenue) *100 as profit_margin
from orders o
join customers c
on o.customer_id = c.customer_id
group by c.state
order by margin_rank

-----Monthly profit 
with monthly_profit as
(
select 
month(date) as month,
sum(profit) as total_profit
from orders
group by month(date)
)
select month,
total_profit,
lag(total_profit) over (order by month) as previous_month_profit,
total_profit - lag(total_profit) over (order by month) as previous_profit_diff

from monthly_profit
order by month
