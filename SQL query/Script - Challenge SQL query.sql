/* DATA CLEANING */
/* replace comma with dot in "income" column on "customer table"*/
update customer 
set income = replace(income, ',', '.');

/* replace data type of "income" column from varchar to float*/
alter table customer
alter column income type float8 using income::float8;

/* impute NULL values in "marital_status" using mode in "marital_status"*/
update customer 
set marital_status = (select marital_status 
					  from(select marital_status, count(marital_status) as count
	 					   from customer
	 					   group by marital_status
	 					   order by count desc)
					  limit 1)
where marital_status is null;

----------------------------------------------

/* CHALLENGE: SQL QUERY */
/* What is the average of customer age for each marital status? */
select marital_status, avg(age) as average_age
from customer
group by marital_status;

/* What is the average of customer age for each gender? */
select case when gender = 0 then 'Woman'
			when gender = 1 then 'Man'
	   end as gender, avg(age) as average_age
from customer
group by gender;

/* Identify the name of the shop with the highest total quantity! */
select store_name, sum(quantity) as total_quantity
from (select *
	  from transaction t
	  left join store s on s.store_id = s.store_id)
group by store_name
order by total_quantity desc;
	  
/* Identify the name of the best-selling product with the highest total amount! */
select product_name, sum(total_amount) as total_amount
from (select *
	  from transaction t
	  left join product p on t.product_id = p.product_id)
group by product_name
order by total_amount desc;