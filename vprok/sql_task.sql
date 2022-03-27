set search_path to vprok;
/*******************************************************************************
Задача 1

*********************************************************************************/

select
	c.first_name,
	c.second_name,
	sum(p.payment_amount) as payment_amount_sum,
	count(p.id) as payment_quantity
from "Client" c 
join "Account" a on c.id = a.client_id 
join "Payments" p on a.id = p.account_id 
group by 1,2
having count(p.id) >= 5 
and sum(p.payment_amount) > 15000
;


/*******************************************************************************
Задача 2

*********************************************************************************/
with f as (
-- accounts that have >= 5000 for the last 30 days
	select 
		distinct p.account_id 
	from "Payments" p 
	where p.payment_date <= current_date 
	and p.payment_date >= (current_date - interval '30 days')::date
	and p.payment_amount >= 5000 
),
cl as (
-- selected clients and number of their accounts
	select 
		a.client_id,
		a.id as account_id,
		count(id) as num_accounts
	from "Account" a 
	where a.id in (select account_id from f)
	group by 1,2
),
tr as (
--calculating sum of transactions by transaction types for selected accounts for the current year
	select 
		p.account_id,
		sum(case p.payment_type 
			when 'payment' then p.payment_amount else 0 end) as sum_payment_transactions,
		sum(case p.payment_type 
			when 'cancel' then p.payment_amount else 0 end) as sum_cancel_transactions
	from "Payments" p 
	where p.account_id in (select account_id from f)
	and p.payment_date between (extract(year from now()::date) || '-01-01')::date and current_date
	group by 1
	
)

select
	cl.client_id,
	cl.num_accounts,
	tr.sum_payment_transactions,
	tr.sum_cancel_transactions
from cl
left join tr on cl.account_id = tr.account_id 
;

