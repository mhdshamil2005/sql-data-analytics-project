--- MEASURES EXPLORATION ---

-- Generate a Report that shows all key metrics of the business

select 'Total Sales' measure_name,
sum(sales_amount) measure_value
from gold.fact_sales

UNION ALL

select 'Total Quantity', sum(quantity) from gold.fact_sales 
UNION ALL
select 'Average Price', AVG(price) from gold.fact_sales
UNION ALL 
select 'Total No Of Orders' ,count(distinct order_number) from gold.fact_sales
UNION ALL
select 'Total No Of Products',count(DISTINCT product_number)from gold.dim_products
UNION ALL
select 'Total No Of Customers',count(distinct customer_id) from gold.dim_customers
UNION ALL
select 'No Of Customers with Order',count(distinct customer_key) from gold.fact_sales
