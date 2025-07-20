--- PART TO WHOLE ANALYSIS ---

-- Which categories contribute the most to overall sales?

select *,
	sum(sales) over() total_sales,
	CONCAT(ROUND(CAST(sales AS float)/sum(sales) over() * 100,2),'%') contribution
from (
	select 
		p.category,
		sum(s.sales_amount) sales
	from gold.fact_sales s
	left join gold.dim_products p
	on s.product_key = p.product_key
	group by p.category
)t
ORDER BY sales desc
