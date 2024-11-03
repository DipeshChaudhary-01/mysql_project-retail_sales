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



select * from [dbo].[project1_retail_sales]

----------------

create database sql_project1_retail;

use sql_project1_retail

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

---

SELECT * FROM project1_retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;


DELETE FROM project1_retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

------
## Data exploration

## Number of sales

select count(*) as Total_Sales from project1_retail_sales

## Number of unique cutomers

select	* from project1_retail_sales

select count(distinct customer_id) Unique_Customers from project1_retail_sales;

## Number of distinct categories

select count(distinct category) Unique_Customers from project1_retail_sales;

## Name of distinct categories

select distinct (category) as Category from project1_retail_sales;


----------------
## Data Analysis
## Data Analysis
----------------

----------------
## Problem Statements


## 1. Write a SQL query to retrieve all columns for sales made on '2022-12-05'.
## 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
      the quantity sold is more than 10 in the month of Nov-2022.
## 3. Write a SQL query to calculate the total sales (total sale) for each category.
## 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
## 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
## 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
## 7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.
## 8. Write a SQL query to find the top 5 customers based on the highest total sales.
## 9. Write a SQL query to find the number of unique customers who purchased items from each category.
## 10. Write a SQL query to create each shift and number of orders (Example: Morning <=12, Afternoon Between 12 & 17, 
       Evening >17).



## 1. Write a SQL query to retrieve all columns for sales made on '2022-12-05'.

select * from project1_retail_sales

select * 
from project1_retail_sales
where sale_date = '2022-12-05';

## 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
the quantity sold is more than 2 in the month of Nov-2022.


-----

select * from [dbo].[project1_retail_sales]

SELECT *
FROM project1_retail_sales
WHERE category = 'Clothing'
AND quantity > 2
AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';


## 3. Write a SQL query to calculate the total sales (total sale) for each category.

select * from project1_retail_sales

SELECT 
    category,
     SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM project1_retail_sales
GROUP BY category


## 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select * from project1_retail_sales

select 
round(avg(age), 2) as Avg_age from project1_retail_sales
where category = 'Beauty';


## 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from project1_retail_sales
where total_sale >1000;

## 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select * from project1_retail_sales

select 
	gender, 
	category, 
	count(*) as Transaction_Count
from project1_retail_sales
group by
		category, gender
	order by 1;




## 7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.

select *from project1_retail_sales
    
############
--(1)
SELECT
    year,
    month,
    avg_sale
FROM
(
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_position
    FROM project1_retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
ORDER BY 
    year, month
;
------
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    AVG(total_sale) AS avg_monthly_sale
FROM 
    project1_retail_sales
GROUP BY 
    YEAR(sale_date), 
    MONTH(sale_date)
ORDER BY 
    sale_year, sale_month;

----
--(2)

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'project1_retail_sales';

----

WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        SUM(total_sale) AS monthly_total
    FROM 
        project1_retail_sales
    GROUP BY 
        YEAR(sale_date), 
        MONTH(sale_date)
)

SELECT 
    ms.sale_year,
    ms.sale_month,
    ms.monthly_total
FROM 
    MonthlySales AS ms
JOIN 
    (SELECT sale_year, MAX(monthly_total) AS max_monthly_total
     FROM MonthlySales
     GROUP BY sale_year) AS max_sales
ON 
    ms.sale_year = max_sales.sale_year
    AND ms.monthly_total = max_sales.max_monthly_total
ORDER BY 
    ms.sale_year;



#######



## 8. Write a SQL query to find the top 5 customers based on the highest total sales.

select *from project1_retail_sales

SELECT TOP 5
    customer_id,
    SUM(total_sale) AS total_sales
FROM project1_retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;



## 9. Write a SQL query to find the number of unique customers who purchased items from each category.

select * from project1_retail_sales

select 
	category,
	count(distinct(transactions_id)) as Unique_Customers_Count
from 
	project1_retail_sales
group by 
	category
    order by Unique_Customers_Count desc;
    

############    


## 10. Write a SQL query to create each shift and number of orders (Example: Morning <=12, 
Afternoon Between 12 & 17, Evening >17).

select * from project1_retail_sales

WITH hourly_sale AS (
    SELECT *,
        CASE 
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM project1_retail_sales
)
SELECT 
    shift, 
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;


## END ##
