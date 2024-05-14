create database Mysql_Project_2;
use Mysql_Project_2;
show tables;                                         
select * from walmartsalesdata_2024;
select min(date) from walmartsalesdata_2024;
select max(date) from walmartsalesdata_2024;
select date_format(date, "%Y") as date from walmartsalesdata_2024;
### Generic Question
/*
1. How many unique cities does the data have?
2. In which city is each branch?
*/
# 1. How many unique cities does the data have?

select distinct city
from walmartsalesdata_2024;

-- 2. In which city is each branch?

select city,
Branch,
count(city) as city_count
from walmartsalesdata_2024
where branch in('a','b','c') 
group by 1,2
order by Branch;
-- > OR
select  City,Branch
from walmartsalesdata_2024 
where branch in('a','b','c');

### Product

-- > 1. How many unique product lines does the data have?
-- > ANS => Health and beauty,Electronic accessories,Home and lifestyl,Sports and travel,Food and beverages,Fashion accessories

select distinct product_line
from walmartsalesdata_2024;

-- > 2. What is the most common payment method?
-- >ANS => Ewallet =>	345

select Payment,
count(*) as count
from walmartsalesdata_2024
group by Payment order by Payment desc
limit 1;

-- > 3. What is the most selling product line?
-- > ANS => Sports and travel	920

select product_line,sum(Quantity) as MostSelling_Product 
from walmartsalesdata_2024 
group by 1 
order by Product_line desc limit 1;

-- > 4. What is the total revenue by month?
-- > ANS ==> execute the Query
select date_format(date, '%m') as month,
round(sum(total),0) as Revenue
from walmartsalesdata_2024
group by 1;

-- > 5. What month had the largest COGS?
-- > ANS => in 9 month  =>13112

select Month(Date) as Month,
round(sum(cogs),0) as COGSbyMonth 
from walmartsalesdata_2024
group by 1
order by COGSbyMonth desc
limit 1 ;

-- > 6. What product line had the largest revenue?
-- > ANS => Food and beverages	53471

select product_line,
round(sum(cogs),0) as Revenue
from walmartsalesdata_2024
group by 1
order by Revenue desc
limit 1 ;

-- 7. What is the city with the largest revenue?
-- > ANS => Naypyitaw	105304
select city,
round(sum(COGS),0) as Revenue
from walmartsalesdata_2024
group by 1
order by Revenue desc
limit 1;

-- 8. What product line had the largest VAT?
-- > ANS ==> Food and beverages	=> 2674

select product_line,
round(max(Tax_5_percent),2) as Largest_VAT
from walmartsalesdata_2024
group by 1
order by 2 desc 
limit 1;

-- > ANS => Fashion accessories	 49.65
select 
Product_line,
round(max(Tax_5_percent),2) as Largest_VAT 
from walmartsalesdata_2024
group by 1
order by 2 desc
limit 1;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

select 
x.Product_line,
AVG_sale, 
Total,
CASE 
      WHEN Total > AVG_sale THEN 'GOOD'
      ELSE 'BAD'
END AS Sales_Quality       -- ## NOTE ==> To Add Quality column used case function
 
from walmartsalesdata_2024
cross join 
(select product_line,
Round(avg(Total),2) as AVG_sale 
from walmartsalesdata_2024
group by 1) as x;

-- 10. Which branch sold more products than average product sold?
select * 
from walmartsalesdata_2024;

select * from (select distinct(Branch),count(Product_line) as Product_sale from  walmartsalesdata_2024 group by 1)oo 
where 
Product_sale  >(select avg(Product_sale) from(select distinct(Branch),count(Product_line) as Product_sale from  walmartsalesdata_2024 group by 1)xx);

-- 11. What is the most common product line by gender?
-- > ANS ==>  Female =>	Fashion accessories =>	96

select gender, Product_line,
count(Product_line) as  count
from walmartsalesdata_2024
group by 1,2
order by count desc limit 1;

-- 12. What is the average rating of each product line?

select product_line,
round(avg(Rating),2) as AvgRating 
from walmartsalesdata_2024
group by 1;


### Sales
/*
1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
4. Which customer type pays the most in VAT?
*/
-- 1. Number of sales made in each time of the day per weekday
select 
dayname(date) as weekday,
hour(time) as hour_of_day,
count(cogs) as total_sales
from walmartsalesdata_2024
group by dayname(date),hour(time)
order by dayname(date),hour(time);


-- 2. Which of the customer types brings the most revenue?
-- > ANS ==> Member	=> 156403
select Customer_type,
round(sum(cogs),0) as Revenue
from walmartsalesdata_2024
group by 1
order by 2 desc limit 1 ;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
-- > ANS ==> Naypyitaw	5265.176500000002
select City, 
round(sum(Tax_5_percent),0) as Vat
from walmartsalesdata_2024
group by 1
order by Vat desc;

-- 4. Which customer type pays the most in VAT?
select customer_type, 
round(sum(Tax_5_percent),2) as Vat
from walmartsalesdata_2024
group by 1
order by Vat desc;


### Customer
/*
1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day fo the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?

*/

-- 1. How many unique customer types does the data have?

select customer_type,
count(distinct Invoice_ID) as Invoice_count 
from walmartsalesdata_2024
group by 1
order by Invoice_count desc;

-- 2. How many unique payment methods does the data have?

select Payment,
count(distinct Invoice_ID) as unique_payment 
from walmartsalesdata_2024
group by 1
order by unique_Payment;

-- 3. What is the most common customer type?
-- > ANS ==> Member
 
Select distinct(Customer_type) as Most_Common_Customer_Type,
count(Customer_type) as Number_of_Customer 
FROM walmartsalesdata_2024 
group by 1 
order by 2 desc limit 1;

-- 4. Which customer type buys the most?
-- > ANS ==> Member	2785

Select distinct(Customer_type) as Most_Buy_Customer,
sum(Quantity) as Number_of_QTY 
FROM walmartsalesdata_2024 
group by 1
order by 2 desc limit 1;

-- 5. What is the gender of most of the customers?
-- > ANS ==> Female	501
Select distinct(Gender) as Most_Gender,
count(Customer_type) as Number_of_Orders 
FROM walmartsalesdata_2024 
group by 1 
order by 2 desc limit 1;

-- 6. What is the gender distribution per branch?
-- > ANS ==> Execute the query
select branch,
Gender,
count( distinct Invoice_ID) as count
from walmartsalesdata_2024
group by 1,2;

-- 7. Which time of the day do customers give most ratings?
-- > ANS ==> 19:48:00	7
Select Time, 
count(Rating) as Rating_Count  
from  walmartsalesdata_2024 
group by 1 
order by 2 desc limit 5;

-- 8. Which time of the day do customers give most ratings per branch?
-- > ANS ==>  A	20:59:00	1

select branch, Time,     -- OR  select Branch, 
count(Rating) as Rating_count  
from walmartsalesdata_2024
group by 1,2
order by 2 desc limit 1;
-- 9. Which day fo the week has the best avg ratings?
-- > ANS ==> 22-01-2024	=> 9

Select Date as Day_of_Week,        -- OR  select dayofweek(Date) as Day_of_Week,
round(Avg(Rating)) as Avg_Rating
From walmartsalesdata_2024
Group by 1
Order By Avg_Rating Desc limit 1;

-- 10. Which day of the week has the best average ratings per branch?
-- > ANS ==>  c	 04/01/2024 	9.07

Select Branch, Date as Day_of_Week,    -- OR select Branch, dayofweek(Date) as Day_of_Week,
round(Avg(Rating),2) as  Avg_Rating
From walmartsalesdata_2024
Group by 1,2
Order By Avg_Rating Desc limit 1;

