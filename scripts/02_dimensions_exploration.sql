--- DIMENSION EXPLORATION ---

-- Retrieve a list of unique categories, subcategories, and products

select distinct
category,subcategory,product_name
from gold.dim_products
order by 1,2,3;
