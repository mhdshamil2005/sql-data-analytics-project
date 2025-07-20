--- CUSTOMER REPORT ---
/*
1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
*/

IF OBJECT_ID ('gold.report_customers','V') IS NOT NULL
DROP VIEW gold.report_customers

GO

CREATE VIEW gold.report_customers AS 
WITH cust_info AS (
	select
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name,' ',c.last_name) customer_name,
		DATEDIFF(YEAR,birthdate,GETDATE()) age
	from gold.fact_sales s
	left join gold.dim_customers c
	on s.customer_key = c.customer_key
	where order_date IS NOT NULL
)

,customer_aggregation as (
	select 
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(distinct order_number) total_orders,
		SUM(sales_amount) total_sales,
		SUM(quantity) total_quantity,
		COUNT(distinct product_key) total_products,
		MAX(order_date) last_order,
		DATEDIFF(MONTH,MAX(order_date),GETDATE()) as recency,
		DATEDIFF(month,MIN(order_date),MAX(order_date)) lifespan
	from cust_info
	GROUP BY 
		customer_key,
		customer_number,
		customer_name,
		age	
)

select
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		 WHEN age between 20 and 29 THEN '20-29'
		 WHEN age between 30 and 39 THEN '30-39'
		 WHEN age between 40 and 49 THEN '40-49'
		 ELSE '50 or above'
	END as age_group,
	CASE WHEN lifespan >= 12 and total_sales > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 and total_sales <= 5000 THEN 'Regular'
		 ELSE 'New'
	END customer_segment,
	last_order,
	lifespan,
	recency,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	CASE WHEN total_orders = 0 then 0
		 ELSE total_sales / total_orders 
	END as avg_order_value,
	CASE WHEN lifespan = 0 then total_sales
		 ELSE total_sales / lifespan
	END avg_monthly_spend
from customer_aggregation 
