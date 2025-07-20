--- CUMULATIVE ANALYSIS ---

-- Calculate the total sales per month 
-- and the running total of sales over time 

select 
	order_date,
	total_sales,
	sum(total_sales) over(order by order_date) running_total
	from (
	select 
	DATETRUNC(month,order_date) order_date,
	SUM(sales_amount) total_sales
from gold.fact_sales
WHERE order_date is not NULL
GROUP BY DATETRUNC(month,order_date)
)t

-- running average

select 
	order_date,
	total_sales,
	sum(total_sales) over(order by order_date) running_total,
	avg(avg_sales) over(order by order_date) moving_avg
from (
	select 
		DATETRUNC(YEAR,order_date) order_date,
		SUM(sales_amount) total_sales,
		AVG(sales_amount) avg_sales
	from gold.fact_sales
	WHERE order_date is not NULL
	GROUP BY DATETRUNC(YEAR,order_date)
)t
