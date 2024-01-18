select * from rental;
with date_form as ( select customer_id, convert(rental_date, date) as Active_date,
date_format(convert(rental_date, date), '%m') as Active_month,
date_format(convert(rental_date, date), '%Y') as Active_year
from rental
) 
select Active_year, Active_month, count(distinct customer_id) as active_customer
from date_form
group by Active_year, Active_month
;
with date_form as ( select customer_id, convert(rental_date, date) as Active_date,
date_format(convert(rental_date, date), '%m') as Active_month,
date_format(convert(rental_date, date), '%Y') as Active_year
from rental
),
active_custom as(select Active_year, Active_month, count(distinct customer_id) as Active_customer
from date_form
group by Active_year, Active_month)
select  Active_year, Active_month, Active_customer,
lag(Active_customer) over(order by Active_year, Active_month) as Previous_month
from active_custom 
;
with date_form as ( select customer_id, convert(rental_date, date) as Active_date,
date_format(convert(rental_date, date), '%m') as Active_month,
date_format(convert(rental_date, date), '%Y') as Active_year
from rental
),
active_custom as(select Active_year, Active_month, count(distinct customer_id) as Active_customer
from date_form
group by Active_year, Active_month), 
previous_m as (select  Active_year, Active_month, Active_customer,
lag(Active_customer) over(order by Active_year, Active_month) as Previous_month 
from active_custom)
select *,
(Active_customer - Previous_month) as Difference,
concat(round((Active_customer - Previous_month) / Active_customer*100), '%') as Percentage_change
from previous_m
;
with date_form as ( select customer_id, convert(rental_date, date) as Active_date,
date_format(convert(rental_date, date), '%m') as Active_month,
date_format(convert(rental_date, date), '%Y') as Active_year
from rental
),
active_custom as (select distinct customer_id as Active_customer, Active_year, Active_month
from date_form
order by Active_customer, Active_year, Active_month
) select ac.Active_customer, ac.Active_year, ac.Active_month, rc.Active_month as Priveous_month
from active_custom ac
join active_custom rc
on ac.Active_year= rc.Active_year
and  ac.Active_month = rc.Active_month+1
and ac.Active_customer=rc.Active_customer
;



