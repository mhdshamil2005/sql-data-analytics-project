--- CHANGES OVER TIME ---

-- Analyse sales performance over time

-- Quick Date Functions

select 
	YEAR(order_date) order_year,
	MONTH(order_date) order_month,
	SUM(sales_amount) total_revenue,
	count(distinct customer_key) total_customers,
	SUM(quantity) total_quantity
	from gold.fact_sales
WHERE order_date is not NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date)

-- DATETRUNC()

select 
	DATETRUNC(month,order_date) order_date,
	SUM(sales_amount) total_revenue,
	count(distinct customer_key) total_customers,
	SUM(quantity) total_quantity
from gold.fact_sales
WHERE order_date is not NULL
GROUP BY DATETRUNC(month,order_date)
ORDER BY DATETRUNC(month,order_date)

-- DATENAME 

select 
	DATENAME(month,order_date) order_month,
	SUM(sales_amount) total_revenue,
	count(distinct customer_key) total_customers,
	SUM(quantity) total_quantity
from gold.fact_sales
WHERE order_date is not NULL
GROUP BY DATENAME(month,order_date)
ORDER BY DATENAME(month,order_date)

-- FORMAT 

select 
	FORMAT(order_date,'yyyy MMM') order_date,
	SUM(sales_amount) total_revenue,
	count(distinct customer_key) total_customers,
	SUM(quantity) total_quantity
from gold.fact_sales
WHERE order_date is not NULL
GROUP BY FORMAT(order_date,'yyyy MMM')
ORDER BY FORMAT(order_date,'yyyy MMM')
