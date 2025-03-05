-- sql retail sales data 

create database if not exists retail ;

use retail;

drop table if exists retail_sales;


create table retail_sales
                       (
							transction_id int primary key,
							sale_date date,
                            sale_time time,
                            customer_id int,
                            gender varchar(50),
                            age int,
                            category varchar(20),
                            quantity int,
                            price_per_unit float,
                            cogs float,
                            total_sale float
						);

### data cleaning

-- checking columns any null values are represented are not 


select * from retail_sales
where 
		transction_id is null
		or 
        sale_date is null 
        or 
        sale_time is null 
        or 
        customer_id is null 
        or 
        gender is null
        or 
        age is null 
        or 
        category is null 
        or 
        quantity is null 
        or 
        price_per_unit is null 
        or 
        cogs is null 
        or 
        total_sale is null
        ;
        
### data exploration 

-- how many unique customers are purchased
select count(distinct customer_id) from retail_sales ;

-- how many category are unique there 
select count(distinct category) from retail_sales;


-- unique category details 
select distinct category from retail_sales;



### data anlysis business solving problems 

-- write a query to reterive all columns for sales made on '2022-11-05' 

select * from retail_sales
where sale_date = '2022-11-05' ;


-- reterive all transctions where the category is 'clothing' and the quantity sold
-- is more than 10 in month of nov-2022

select * from retail_sales
where category = 'clothing' and sale_date between '2022-11-01' and '2022-11-30' and quantity >= 4;



-- calculate the total sales for each category 

select category,sum(total_sale) sales,count(*) total_orders  from retail_sales 
group by 1;


-- find the avg age of custoemrs who purchased items from 'beauty' cateogry

select category,round(avg(age),2) from retail_sales 
where category = 'beauty' ;


-- find all transctions where the total_sales is greater than 1000 

select * from retail_sales 
where total_sale > 1000;

-- find total_number of transctions_id made by each gender in each category 

select category,gender,count(*) from retail_sales
group by gender,category 
order by 1;


-- calculate the avg sale for each month.find out best selling month in each year 

select year,month,revenue from 
				(select 
				   extract(year from sale_date) year,
				   extract(month from sale_date) month,
				   avg(total_sale) revenue,
				   rank() over(partition by extract(year from sale_date)  order by avg(total_sale) desc) as ranking
				from retail_sales 
				group by 1,2 ) t1
where ranking = 1;


-- find the top 5 customers based on their highest sales  

select customer_id,sum(total_sale) high_sales from retail_sales 
group by 1 
order by 2 desc 
limit 5;


-- find the number of unique customers who purschased items for each category 

select category,count(distinct customer_id) 
from retail_sales 
group by 1;


-- create a each shif and number of orders like time of the day
with hourly_shift 
as
(
select *,
case when extract(hour from sale_time) <=12 then "Morning"
	 when extract(hour from sale_time) between 12 and 17 then "Afternoon"
     else "Evening" 
     end Shift
from retail_sales
)
select shift,count(*) total_orders from hourly_shift 
group by shift;


########## END OF PROJECT ##########
