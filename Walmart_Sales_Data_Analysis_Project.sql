create database if not exists WalmartSalesData;

create table if not exists sales(
   invoice_id varchar(30) not null primary key,
   branch varchar(5) not null,
   city varchar(30) not null,
   customer_type varchar(30) not null,
   gender varchar(10) not null,
   product_line varchar(100) not null,
   unit_price decimal(10,2) not null,
   quantity int not null,
   vat float(6,4) not null,
   total decimal(12,4) not null,
   date datetime not null,
   time time not null,
   payment_method varchar (15) not null,
   cogs decimal(10,2) not null,
   gross_margin_pct float(11,9),
   gross_income decimal(12,4) not null,
   rating float(2,1) );
   
   select * from walmartsalesdata.sales;
   
#----------------------------------------------------------------------------------------------------------------------------------
#---------------------------------------Feature Engineering -----------------------------------------------------------------------
#----time_of_day
   
select
	time,
     (case
	  when 'time' between "00:00:00" and "12:00:00" then "Morning"
	  when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
	   else "Evening"
	    end ) as time_of_day
       from sales;
   

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = ( case
when "time" between "00:00:00" and "12:00:00" then "Morning"
when "time" between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end );
            
select * from walmartsalesdata.sales;            
            
#--------------------------------------------------------------------------------------------------------------------------------
#----day_name

select date ,
	dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);

select * from walmartsalesdata.sales;   

update sales
set day_name = dayname(date);

select * from walmartsalesdata.sales; 

#-------------------------------------------------------------------------------------------------------------------------------------
#-------month_name

select date, monthname(date)
from sales;

alter table sales add column month_name varchar (10);
select * from walmartsalesdata.sales; 

update sales 
set month_name =monthname(date);

select * from walmartsalesdata.sales; 

#--------------------------------------------------------------------------------------------------------------------------------------------




#-------------------------------------------------------------------------------------------------------------------------------------------
#--------------------------Generic Questions--------------------------------------------------------------------------------------------

#Q 1.) How many unique cities does the data have?

select distinct city
from sales;

#Q 2.) In which city is each branch?

select distinct branch
from sales;

select distinct city, branch
from sales;

#-------------------------Product Based Questions -----------------------------------------------------------------------------------

#Q1.) How many unique product lines does the data have?

select count( distinct product_line)
from sales;

#Q2.) What is the most comman payment method?

select payment_method,count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

#Q3.) What is the most selling product line?

select product_line, count(quantity) as cnt
from sales
group by product_line
order by cnt desc ;

#Q4.) What is the total revenue by month?

select month_name as month,sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

#Q5.) What month had the largest COGS?

select month_name as month,sum(cogs) as total_cogs
from sales 
group by month
order by total_cogs desc;

#Q6.) What product line had the largest revenue?

select product_line as product, sum(total) as revenue
from sales
group by product
  order by revenue desc;
  
#Q7.) What is the city with the largest revenue?

select city, sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

#Q8.) What product line had the largest VAT?

select product_line , avg(vat) as avg_tax
from sales
group by product_line
order by avg_tax desc;

#Q9.) Fetch each product line and add a column to those product line showing 'Good','Bad'. (Good if its greater than average sales)

select product_line,round(avg(total),2) as avg_sales,
 (case 
  when avg(total) > (select avg(total) from sales) then "Good"
  else "Bad"
  end) as remarks
  from sales
  group by product_line;
  
                                                      
#Q10.) Which branch sold more products than average product sold?

select  branch,sum( quantity) as qty
from sales 
group by branch
having qty > (select avg(quantity) from sales );

#Q11.) What is the most comman product line by gender?

select gender , product_line, count(gender) as total_cnt
from sales 
group by gender , product_line
order by total_cnt desc;

#Q12.) What is the average rating of each product line?

select product_line, round(avg(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating desc;


#-----------------------------------Sales Based Questions-------------------------------------------------------------------------------

#Q1.) Number of sales made in each time of the day per weekday?

select time_of_day, count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day
order by total_sales desc;

#Q2.) Which of the customer types brings the most revenue?

select customer_type, sum(total) as total_revenue
 from sales
 group by customer_type
 order by total_revenue desc;
 
 #Q3.) Which city has the largest tax percent/VAT ?
 
 select city, round(avg(vat),2) as tax_pct
 from sales
 group by city
 order by tax_pct desc;
 
 #Q4.) Which customer type pays the most in VAT ?
 
 select customer_type,  round(avg(vat),2) as total_vat
 from sales
 group by customer_type
 order by total_vat desc;
 
 #------------------------------------------------------------------------------------------------------------------------------------------
 #---------------------------------------Customer Related Questions------------------------------------------------------------------------
 
 #Q1.) How many unique customer types does the data have?
 
 select distinct customer_type
 from sales;
 
 #Q2.) How many unique payment methods does the data have?
 
 select distinct payment_method
 from sales;
 
 #Q3.) What is the most common customer type?
 
 select customer_type, count(*) as count
 from sales
 group by customer_type
 order by count desc;
 
 #Q4.) Which cutomer type buys the most ?
 
 select customer_type, count(*) as customer_count
 from sales
 group by customer_type
 order by customer_count;
 
 #Q5.) What is the gender of most of the customer?
 
 select gender,count(*) as gender_count
 from sales
 group by gender
 order by gender_count desc;
 
 #Q6.) What is the gender distribution per branch?
 
 select gender,count(*) as gender_count
 from sales
 where branch = 'A'
 group by gender
 order by gender_count desc;
 
 #Q7.) Which time of the day do customers give most ratings ?
 
 select time_of_day, avg(rating) as avg_rating
 from sales
 group by time_of_day
 order by avg_rating desc;
 
 #Q8.) Which time of the day do customers give most ratings per branch?
 
  select time_of_day, avg(rating) as avg_rating
 from sales
 where branch ='A'
 group by time_of_day
 order by avg_rating desc;
 
 #Q9.) Which day of the week has the best average ratings?
 
 select day_name , avg(rating) as avg_rating
 from sales
 group by day_name
 order by avg_rating;
 
 #Q10.) Which day of the week has the best averege ratings per branch?
 
 select day_name , avg(rating) as avg_rating
 from sales
 where branch = 'A'
 group by day_name
 order by avg_rating desc;
 
 
 #-------------------------------- THANK YOU FOR WATCHING :) -----------------------------------------------------------------------------


