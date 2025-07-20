--- RANKING ANALYSIS ---

-- Which 3 product categories Generating the Highest Revenue?

select * from (
select
p.category,
sum(s.sales_amount) total_revenue,
row_number() over(order by sum(s.sales_amount) desc) category_rank
from gold.dim_products p
left join gold.fact_sales s
on  p.product_key = s.product_key
group by p.category
)t
where category_rank <= 3

select top 3
p.category,
sum(s.sales_amount) total_revenue
from gold.dim_products p
left join gold.fact_sales s
on  p.product_key = s.product_key
group by p.category
order by total_revenue desc

-- Which 5 products Generating the Highest Revenue?

select top 5
p.product_name,
sum(s.sales_amount) total_revenue
from gold.dim_products p
left join gold.fact_sales s
on  p.product_key = s.product_key
group by p.product_name
order by total_revenue desc

select * from (
select 
p.product_name,
sum(s.sales_amount) total_revenue,
ROW_NUMBER() over(order by sum(s.sales_amount) desc) product_rank
from gold.dim_products p
left join gold.fact_sales s
on  p.product_key = s.product_key
group by p.product_name
)t
where product_rank <=5

-- What are the 5 worst-performing products in terms of sales?

select top 5
product_name,
sum(sales_amount) sales
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by product_name
order by sales asc

select * from (
select
product_name,
sum(sales_amount) sales,
ROW_NUMBER() over(order by sum(sales_amount) asc) sales_rank
from gold.fact_sales s
left join gold.dim_products p
on s.product_key = p.product_key
group by product_name
)t
where sales_rank <= 5

-- Find the top 10 customers who have generated the highest revenue

select * from (
select 
c.customer_id,
c.first_name,
c.last_name,
sum(s.sales_amount) total_revenue,
ROW_NUMBER() over(order by sum(s.sales_amount) desc) rank_customers
from gold.fact_sales s
left join gold.dim_customers c
on s.customer_key = c.customer_key
group by c.customer_id,
		 c.first_name,
		 c.last_name
)t
where rank_customers <= 10

-- The 3 customers with the fewest orders placed

SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ;
