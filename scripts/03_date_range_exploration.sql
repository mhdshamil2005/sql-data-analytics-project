--- DATE EXPLORATION ---

-- Determine the first and last order date and the total duration in months

select min(order_date),max(order_date),
DATEDIFF(year,MIN(order_date),max(order_date))
from gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate

select 
MIN(birthdate) Oldest_BD,
DATEDIFF(year,MIN(birthdate),GETDATE()) Oldest_Age,
MAX(birthdate) Youngest_BD,
DATEDIFF(year,MAX(birthdate),GETDATE()) Youngest_Age
from gold.dim_customers;
