
-- creating base table with month\week periods
create view komarpp.dpt_all_vw
as
with base as (

	select
		'week' as period_type,
		case 
			when extract(isodow from s.sale_date) < 1 then cast(date_trunc('week', s.sale_date) as date) - 8 + 1
			else cast(date_trunc('week', s.sale_date) as date) - 1 + 1
		end as start_date,
		case 
			when extract(isodow from s.sale_date) < 1 then cast(date_trunc('week', s.sale_date) as date) - 8 + 1 + 6
			else cast(date_trunc('week', s.sale_date) as date) - 1 + 1 + 6
		end as end_date,
		s.sale_date,
		s.salesman_id,
		s.item_id,
		s.quantity,
		s.final_price 
	from 
		sale s
	
	union all 
	
	select
		'month' as period_type,
		date_trunc('month', s.sale_date)::date as start_date,
		(date_trunc('month', s.sale_date) + interval '1 month - 1 day')::date as end_date,
		s.sale_date,
		s.salesman_id,
		s.item_id,
		s.quantity,
		s.final_price 
	from 
		sale s

),

-- calculating max_overcharge_item 
moi as (
	select
		q.period_type,
		q.start_date,
		q.end_date,
		q.salesman_id,
		q.item_id,
		sp.name as max_overcharge_item 
	from (
		select
			base.period_type,
			base.start_date,
			base.end_date,
			base.item_id,
			base.salesman_id,
			base.final_price,
			rank() over(partition by base.start_date, base.end_date, base.salesman_id  order by max(base.final_price) desc) as rank_num
		from base
		group by 1,2,3,4,5,6
		) q
	join (
		select 
				p.id,
				p.name
		from product p
		
		union 
		
		select 
			s.id,
			s.name
		from service s
	) sp 
	on q.item_id = sp.id and rank_num = 1 
),

-- calculating max_overcharge_percent 
mop as (
	select 
		qq.period_type,
		qq.start_date,
		qq.end_date,
		qq.salesman_id,
		qq.item_id,
		qq.max_perc as max_overcharge_percent 
	from 
	(
		select
			base.period_type,
			base.start_date,
			base.end_date,
			base.salesman_id,
			base.item_id,
			base.final_price,
			q.price,
			round(((base.final_price -  q.price)::decimal / q.price) * 100,2) as max_perc,
			rank() over(partition by base.start_date, base.end_date, base.salesman_id order by ((base.final_price -  q.price)::decimal / q.price) desc) as rank_num
		from base
		left join 
		(
			select 
				p.id,
				p.price,
				p.sdate::date,
				p.edate::date
			from product p
			union all 
			select 
				s.id,
				s.price,
				s.sdate::date,
				s.edate::date
			from service s
		) q
		on base.item_id = q.id and base.sale_date between q.sdate and q.edate 
		group by 1,2,3,4,5,6,7
	) qq
	where qq.rank_num = 1
),

-- aggregating sales_count & sales_sum 
agg as (
	select
		base.period_type,
		base.start_date,
		base.end_date,
		base.salesman_id, 
		sr.fio as salesman_fio,
		sr2.fio as chif_fio,
		count(quantity) as sales_count,
		sum(base.quantity * base.final_price) as sales_sum
	from 
		base
	left join seller sr on base.salesman_id = sr.id 
	left join department d on sr.department_id = d.department_id 
	left join seller sr2 on d.dep_chif_id = sr2.id 
	group by 1,2,3,4,5,6
)

--combining all together

select
	agg.period_type,
	agg.start_date,
	agg.end_date,
	coalesce (agg.salesman_fio, agg.salesman_id::text) as salesman_fio, -- also replaced nulls with salesman_id info for missing salesmans
	coalesce (agg.chif_fio, agg.salesman_id::text) as chif_fio,			-- same here
	agg.sales_count,
	agg.sales_sum,
	moi.max_overcharge_item,
	mop.max_overcharge_percent
from agg
left join moi 
	on agg.period_type = moi.period_type and agg.start_date = moi.start_date and agg.end_date = moi.end_date and agg.salesman_id = moi.salesman_id 
left join mop 
	on agg.period_type = mop.period_type and agg.start_date = mop.start_date and agg.end_date = mop.end_date and agg.salesman_id = mop.salesman_id
order by agg.salesman_fio, agg.start_date
;
