--- PERFORMANCE ANALYSIS ---

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH product_yearly_sales as (
select 
	YEAR(s.order_date) order_year,
	p.product_name,
	SUM(s.sales_amount) current_sales
from gold.fact_sales s
left join gold.dim_products p
on p.product_key = s.product_key
where YEAR(s.order_date) is NOT NULL
GROUP BY p.product_name,YEAR(s.order_date)
)

select 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) over(partition by product_name) avg_sales,
	current_sales - AVG(current_sales) over(partition by product_name) diff_avg,
	CASE  
		WHEN current_sales - AVG(current_sales) over(partition by product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) over(partition by product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END avg_performance,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) previous_sale,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) diff_previous_year,
	CASE  
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		ELSE 'No Change'
	END avg_performance
from product_yearly_sales
ORDER BY product_name,order_year
