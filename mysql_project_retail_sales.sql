## Problem Statments

## 1. Write a SQL query to retrieve all columns for sales made on '2022-12-05'.
## 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.
## 3. Write a SQL query to calculate the total sales (total sale) for each category.
## 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
## 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
## 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
## 7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.
## 8. Write a SQL query to find the top 5 customers based on the highest total sales.
## 9. Write a SQL query to find the number of unique customers who purchased items from each category.
## 10. Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17).



create database sql_project1_retail;

use sql_project1_retail;

drop table retail_sales;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);


select	* from retail_sales


SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

## Data exploration

## Number of sales

select count(*) as Total_Sales from retail_sales

## Number of unique cutomers

select	* from retail_sales

select count(distinct customer_id) Unique_Customers from retail_sales;

## Number of distinct categories

select count(distinct category) Unique_Customers from retail_sales;

## Name of distinct categories

select distinct (category) as Category from retail_sales;


## Data Analysis

## My Analyst's Findings




## 1. Write a SQL query to retrieve all columns for sales made on '2022-12-05'.

select * from retail_sales

select * 
from retail_sales
where sale_date = '2022-12-05';

## 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022.

select category, sum(quantity)
from retail_sales
where category = 'Clothing'
and quantity > 2;


select *from retail_sales
where
	category = 'Clothing'
    and TO-CHAR (sale_date, 'YYYY-MM') = '2022-11'
    and 
    quantity >=4
    
select * from retail_sales
where category = 'Clothing'
and
TO-CHAR (sale_date, 'YYYY-MM') = '2022-11'
and quantity >=2;


SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND EXTRACT(YEAR_MONTH FROM sale_date) = '2022-11'
AND quantity >= 2;


select * from retail_sales

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity > 1
AND EXTRACT(YEAR_MONTH FROM sale_date) = '2022-11';


## 3. Write a SQL query to calculate the total sales (total sale) for each category.

select * from retail_sales

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1


## 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select * from retail_sales

select 
round(avg(age), 2) as Avg_age from retail_sales
where category = 'Beauty';


## 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale >1000;

## 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select * from retail_sales

select 
	category, 
	gender, 
	count(*)
from retail_sales
group by
		category, gender
	order by 1;

    

select gender, category,
	count(transaction_id),
    group by gender, category
from retail_sales;



select 
	category,
    gender,
    count (*) as total_trans 
from retail_sales
group by gender;


## 7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.

select *from retail_sales
    
select
	YEAR(sale_date) as year,
    MONTH(sale_date) as month,
	round(avg(total_sale),2) as avg_sale
from retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
order by 1,3 desc;


##

SELECT 
    year,
    month,
    avg_sale
FROM 
(
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        round(AVG(total_sale),2) AS avg_sale,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank_position
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE rank_position = 1;



## 8. Write a SQL query to find the top 5 customers based on the highest total sales.

select *from retail_sales

select 
	customer_id,
    sum(total_sale) as total_sales
from
	retail_sales
group by 
	customer_id
order by total_sales desc
limit 5;


## 9. Write a SQL query to find the number of unique customers who purchased items from each category.

select * from retail_sales

select 
	category,
	count(distinct(transactions_id)) as Unique_Customers_Count
from 
	retail_sales
group by 
	category;
    

    
## 10. Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, Evening >17).

select * from retail_sales

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift


## END ##
