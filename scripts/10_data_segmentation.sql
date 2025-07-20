--- DATA SEGMENTATION ---

/*Segment products into cost ranges and 
count how many products fall into each segment*/
/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH product_segments as (
select 
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost between 100 and 500 THEN '100-500'
		 WHEN cost between 500 and 1000 THEN '500-1000'
		 ELSE 'Above 1000'
	END cost_range
from gold.dim_products
)

select 
	cost_range ,
	count(product_key) total_products
from product_segments
group by cost_range
order by total_products desc


with customer_details as (
select 
	c.customer_key,
	SUM(s.sales_amount) spending,
	MIN(s.order_date) first_order,
	MAX(s.order_date) last_order,
	DATEDIFF(month,MIN(s.order_date),MAX(s.order_date)) lifespan
from gold.fact_sales s
left join gold.dim_customers c
on s.customer_key = c.customer_key
GROUP BY c.customer_key
)

select
	customer_segments,
	COUNT(customer_key) total_customers
from (
	select
		customer_key,
		lifespan,
		spending,
		CASE WHEN lifespan >= 12 and spending > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 and spending <= 5000 THEN 'Regular'
			 ELSE 'New'
		END customer_segments
	from customer_details
	)t
GROUP BY customer_segments
ORDER BY total_customers desc
