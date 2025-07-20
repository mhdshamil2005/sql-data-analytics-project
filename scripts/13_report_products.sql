--- PRODUCT REPORT ---

/*  1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
*/

IF OBJECT_ID ('gold.report_products','V') IS NOT NULL
DROP VIEW gold.report_products

GO

CREATE VIEW gold.report_products AS 
WITH product_info AS (
	select 
		s.order_number,
		s.customer_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
	from gold.fact_sales s
	left join gold.dim_products p
	on s.product_key = p.product_key
	where order_date IS NOT NULL
)

, product_aggregation AS (
	select 
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		COUNT(DISTINCT order_number) total_orders,
		SUM(sales_amount) total_sales,
		SUM(quantity) total_quantity,
		COUNT(DISTINCT customer_key) total_customers,
		MAX(order_date) last_sale_date,
		DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) lifespan,
		DATEDIFF(MONTH,MAX(order_date),GETDATE()) recency
	from product_info
	GROUP BY
		product_key,
		product_name,
		category,
		subcategory,
		cost
)

select 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	CASE WHEN total_sales >= 50000 THEN 'High-Performer'
		 WHEN total_sales >= 1000 THEN 'Mid-Range'
		 ELSE 'Low-Performer'
	END product_segment,
	last_sale_date,
	lifespan,
	recency,
	total_orders,
	total_sales,
	total_customers,
	total_quantity,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
	END as avg_order_revenue,
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END as avg_monthly_revenue
from product_aggregation
