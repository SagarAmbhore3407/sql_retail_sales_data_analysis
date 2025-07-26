--Retail Sales Analysis-

CREATE DATABASE sql_project;

--Create Table
``
CREATE TABLE IF NOT EXISTS retail_sales
	(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,	
		sale_time Time,	
		customer_id	INT,
		gender	VARCHAR(15),
		age	INT,
		category VARCHAR(15),	
		quantity INT,
		price_per_unit FLOAT,	
		cogs FLOAT,	
		total_sale FLOAT
	);


SELECT * FROM retail_sales 
LIMIT 10;

SELECT
	COUNT(*)
FROM retail_sales;	


--  DATA CLEANING
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;


--
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--DATA Exploration

-- Hom many sales we have?

SELECT COUNT(*) AS total_sale FROM retail_sales;

--How many unique customers we have?

SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;

--Category 

SELECT COUNT(DISTINCT category) AS total_categories FROM retail_sales;

--DATA Analysis & Business key problem and solution.

--1.Retrive all columns for sales made on '2022-11-05'

SELECT COUNT(*)
FROM retail_sales
WHERE sale_date = '2022-11-05';

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2.Retrieve transaction where category is 'clothing' and qunatity sold is more than or equal 4 in month Nov-2022

SELECT * 
FROM retail_sales
WHERE
	category = 'Clothing'
	AND
	sale_date BETWEEN '2022-11-01' AND '2022-11-30'
	AND 
	quantity >= 4;

SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

--3. Calculate total sales for each category.

SELECT 
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

--4. Find average age of customers who purchased items From beauty category.

SELECT 
	ROUND(AVG(age), 2) AS avg_age 
FROM retail_sales
WHERE category = 'Beauty';

--5. Find all transaction where total sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

--6. Find total no. of transaction made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(*) as total_trans 
FROM retail_sales
GROUP BY 
	category, 
	gender
ORDER BY 1;

--7. Calculate average sale for each month. Find out best selling month in year.

SELECT 
	year,
	month,
	avg_sale 
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank = 1;

--8. FIND the top 5 customers based on the highest total sales.

SELECT 
	customer_id,
	SUM(total_sale) AS total_sale 
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--9. FIND no. of UNIQUE customers who purchased items from each category.

SELECT
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

--10. CREATE each shift and number of orders (EG. morning <=12, afternoon between 12 & 17, evening >17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift	
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders FROM hourly_sale
GROUP BY shift

-- END of PROJECT
















