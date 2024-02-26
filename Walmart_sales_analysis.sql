/* The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition. This dataset contains sales transactions 
from a three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:*/

Create Database Walmartsalesdata

drop table if exists sales
Create table sales (
Invoice_ID varchar(25) not null primary key,
Branch varchar(10) not null,
City varchar(20) not null,
Customer_type varchar(25) not null,
Gender varchar(6) not null,
Product_line varchar(100) not null,
unit_price float not null,
quantity int not null,
 VAT float not null,
Total float not null,
[date] date not null,
[time] time not null,
payment varchar(20) not null,
cogs decimal(10,2) not null,
gross_margin_pct float not null,
gross_income decimal(12,2) not null,
rating float
)



--------------------------------------- Feature Engineering---------------------------------------------------------

-- time_of_day

select TIME, (case when time between '00:00:00' and '12:00:00' then 'Morning'
			 when TIME between '12:00:01' and '16:00:00' then 'Afternoon'
			 else 'Evening'
			 end) as time_of_day
from sales

Alter table sales add  time_of_day varchar(20)

update sales
set time_of_day = (case when time between '00:00:00' and '12:00:00' then 'Morning'
			 when TIME between '12:00:01' and '16:00:00' then 'Afternoon'
			 else 'Evening'
			 end)

-- day_name

select DATE, FORMAT(date,'dddd') as day_name
from sales

alter table sales add day_name varchar(20)

update sales 
set day_name = FORMAT(date,'dddd')

--month_name

select DATE, datename(month,[date]) as month_name
from sales

alter table sales add month_name varchar(12)

update sales
set month_name = DATENAME(month,[date])


---------------------------------------------------Generic Question-------------------------------------------------------------

-- How many unique cities does the data have?

select count(distinct city) number_of_city from sales

-- In which city is each brach?

select Branch, city from sales group by Branch,City order by branch

--------------------------------------------------Product----------------------------------------------------------------------

-- How many unique product lines does the data have?

select distinct Product_line
from sales

-- What is the most common payment method?

select payment, COUNT(payment) as no_of_time
from sales
group by payment

-- What is the most selling product line?

select product_line, ROUND(sum(total),2) as Total_sale
from sales group by Product_line order by Total_sale desc

-- What is the total revenue by month?

select * from sales

select month_name, ROUND(sum(total),2) as total_revenue from sales group by month_name order by total_revenue desc

--What month had the largest cogs?

select top 1
MONTH_name, ROUND(sum(cogs),2) as total_cogs from sales group by MONTH_name order by total_cogs desc

-- What product line had the largest revenue?
select top 1 product_line, ROUND(sum(total),2) total_revenue from sales group by Product_line order by total_revenue desc

-- Which city had the largest revenue?

select top 1 city,
Round(sum(total),2) total_revenue from sales group by City order by total_revenue  desc

-- What product line had the largest VAT?

select top 1 product_line, ROUND(sum(VAT)
,2) highest_vat
from sales group by Product_line order by 
highest_vat desc

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select * from sales
select product_line, ROUND(AVG(total),2) avg_sale,round(sum(total),2),
( case
when ROUND(AVG(total),2) <=
ROUND(sum(total),2) then 'Good' else 'Bad'
end) as Good_or_bad from sales group by Product_line 

-- Which branch sold more products than average product sold?

select branch, COUNT(quantity) count_of_product
from sales group by branch having  COUNT(quantity) > ROUND(AVG(total),2)

-- What is the most common product line by gender?

select * from sales

select gender, product_line, COUNT(product_line) as num_of_product from sales group by Gender,Product_line
order by Product_line asc,
num_of_product desc

-- What is the average rating of each product line?

select product_line, ROUND(AVG(rating),2)
avg_rating from sales group by Product_line order by avg_rating desc

----------------------------------------------------------------------Sales---------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday

select * from sales

select DAY_name, time_of_day, count(time) num_of_sales_in_day from sales
group by day_name,time_of_day order by day_name, num_of_sales_in_day desc


-- Which of the customer types brings the most revenue?

select customer_type, ROUND(sum(total),2) total_revenue from sales
group by Customer_type order by total_revenue desc

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, SUM(VAT) highest_tax from sales
group by city order by highest_tax desc


-- Which customer type pays the most in VAT?

select customer_type, ROUND(sum(vat),2) total_vat
from sales
group by Customer_type order by total_vat desc

----------------------------------------------------------------------Customer---------------------------------------------------------------------

-- How many unique payment methods does the data have?

select distinct payment from sales

-- How many unique customer types does the data have?

select distinct customer_type from sales

-- What is the most common customer type?

select customer_type, COUNT(customer_type)count_of_cust from sales group by Customer_type

-- What is the gender of most of the customers?

select gender, COUNT(customer_type) count_of_customer from sales 
group by Gender 

-- What is the gender distribution per branch?

select branch,gender, count(branch) count_of_branch from sales group by branch,gender order by branch

-- Which time of the day do customers give most ratings?

select time_of_day, COUNT(rating) count_of_rating from sales group by time_of_day

--Which time of the day do customers give most ratings per branch?

select time_of_day, branch, COUNT(rating) count_of_rating from sales group by time_of_day,branch order by Branch

-- Which day fo the week has the best avg ratings?

select * from sales

select top 1 * from (
select day_name, round(AVG(rating),2) avg_rating from sales group by day_name ) a
order by avg_rating desc


-- Which day of the week has the best average ratings per branch?

select  * from (
select day_name,branch, round(AVG(rating),2) avg_rating from sales group by day_name ,Branch) a
order by Branch asc, avg_rating desc


























