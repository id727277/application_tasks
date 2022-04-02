/* 		1. Write a SQL that shows By Date by Warehouse Name, Total # of Orders, Total Revenue, Avg Delivery Time, Avg Pick Time
 * 
 * I've used PostgreSQL syntax in all SQL scripts below.
 * 
 * I assump 'Total revenue' is the total amount paid by users for all orders. 
 * But I've seen different interpretations of revenue, so if it was meant as a difference between price_per_unit and cost of the product times quantity,
 *  please see version 2 of this question.
 * 
 * I used Age() function to show time diffs in human-readable format. An alternative function can be found in inline comments.
*/

select 
	t.created_at::date as "Date",
	w.warehouse_name as "Warehouse Name",
	count(t.order_id) as "Total # of Orders",
	sum(t.total) as "Total Revenue",
	date_trunc('second', avg(age(t.delivered_at, t.picked_at))) as "Avg Delivery Time", --avg(date_part('minute', t.delivered_at - t.picked_at))
	date_trunc('second', avg(age(t.picked_at, t.created_at))) as "Avg Pick Time" --avg(date_part('minute', t.picked_at - t.created_at))
from transactions t
left join warehouse w on t.warehouse_id = w.warehouse_id 
group by 1, 2
order by 1, 2;


/* 			VERSION 2 for Question 1 */ 

select
	t.created_at::date as "Date",
	w.warehouse_name as "Warehouse Name",
	count(t.order_id) as "Total # of Orders",
	sum(op.qty * (op.price_per_unit - p."cost")) as "Total Revenue", -- alternative
	date_trunc('second', avg(age(t.delivered_at, t.picked_at))) as "Avg Delivery Time",
	date_trunc('second', avg(age(t.picked_at, t.created_at))) as "Avg Pick Time"
from transactions t 
left join order_products op 	on t.order_id = op.order_id 
left join products p 	on op.product_id = p.product_id 
left join warehouse w 	on t.warehouse_id = w.warehouse_id 
group by 1, 2
order by 1, 2;


/*
 		2. Write a SQL to display Top 5 days with the least Avg Delivery Time
*/
with top as (
	select
		t.created_at::date as "Date",
		date_trunc('second', avg(age(t.delivered_at, t.picked_at)))
	from transactions t 
	group by 1
	order by 2
	limit 5
)
select "Date"
from top;

/*
    3. Write a SQL that displays names of top 10 Products (all-time) in terms of unit sold
*/
select
	p.product_name,
	sum(op.qty) as units_sold
from order_products op
left join products p 	on op.product_id = p.product_id 
group by 1
order by 2 desc 
limit 10;


/*
    4. Write a SQL that list User IDs of users that have ordered on two consecutive days
*/
select
	distinct t.user_id
from transactions t
join transactions t2 on t.user_id = t2.user_id and t2.created_at > t.created_at and t.created_at::date = t2.created_at::date - interval '1 day'
;


/*
    5. Write a SQL to display Product Margins for each product by week 
*
*  I assump Product Margin is difference between price_per_unit and cost of the product
*/

select
		case 
			when extract(isodow from t.created_at) < 1 then cast(date_trunc('week', t.created_at) as date) - 8 + 1
			else cast(date_trunc('week', t.created_at) as date) - 1 + 1
		end as "Week start", -- cutting dates in transactions in weeks and getting start of the week date
		case 
			when extract(isodow from t.created_at) < 1 then cast(date_trunc('week', t.created_at) as date) - 8 + 1 + 6
			else cast(date_trunc('week', t.created_at) as date) - 1 + 1 + 6
		end as "Week end", -- cutting dates in transactions in weeks and getting end of the week date
		p.product_name as "Product",
		(op.price_per_unit - p."cost" ) as "Product Margin"
from transactions t 
left join order_products op 	on t.order_id = op.order_id 
left join products p 			on op.product_id = p.product_id
where p.product_name is not null
;


