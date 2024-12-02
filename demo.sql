
-- ***************************************************************
-- Snowflake Demo: Generate and Query Large Mock Dataset
-- ***************************************************************

-- Step 0: Set the warehuose and the schema -- 

CREATE WAREHOUSE demo_warehouse
WITH WAREHOUSE_SIZE = 'XSMALL'
AUTO_SUSPEND = 60
AUTO_RESUME = TRUE;


USE WAREHOUSE demo_warehouse;

CREATE DATABASE demo_database;

USE DATABASE demo_database;

CREATE SCHEMA demo_schema;

-- Step 1: Create the table to store mock data
CREATE TABLE mock_sales_data (
    sale_id INT,                -- Unique identifier for each sale
    category STRING,            -- Product category
    sales_amount DECIMAL(10, 2),-- Amount of the sale
    sales_date DATE,            -- Date of the sale
    country STRING              -- Country where the sale occurred
);

-- Step 2: Populate the table with mock data
-- Using Snowflake's TABLE(GENERATOR(...)) to generate rows dynamically
-- This example creates 10 million rows of random sales data
INSERT INTO mock_sales_data
SELECT 
    SEQ4() AS sale_id,          -- Generate sequential sale IDs
    CASE                        -- Assign random categories
        WHEN RANDOM() < 0.2 THEN 'Electronics'
        WHEN RANDOM() < 0.4 THEN 'Books'
        WHEN RANDOM() < 0.6 THEN 'Clothing'
        WHEN RANDOM() < 0.8 THEN 'Toys'
        ELSE 'Furniture'
    END AS category,
    ROUND(UNIFORM(10, 1000, RANDOM()), 2) AS sales_amount,  -- Random sales amount between 10 and 1000
    DATEADD(DAY, UNIFORM(-365, 0, RANDOM()), CURRENT_DATE) AS sales_date, -- Random dates in the past year
    CASE                        -- Assign random countries
        WHEN RANDOM() < 0.2 THEN 'USA'
        WHEN RANDOM() < 0.4 THEN 'Canada'
        WHEN RANDOM() < 0.6 THEN 'UK'
        WHEN RANDOM() < 0.8 THEN 'Germany'
        ELSE 'India'
    END AS country
FROM TABLE(GENERATOR(ROWCOUNT => 10000000));  -- Generate 10 million rows (adjust ROWCOUNT as needed)

-- Step 3: Run queries to demonstrate Snowflake's performance

-- Query 1: Total sales by category
-- Summarizes the total sales for each category and orders by total sales in descending order
SELECT category, SUM(sales_amount) AS total_sales
FROM mock_sales_data
GROUP BY category
ORDER BY total_sales DESC;

-- Query 2: Sales statistics by country
-- Counts the number of sales, calculates the average sales amount, and orders by the number of sales
SELECT country, COUNT(*) AS num_sales, AVG(sales_amount) AS avg_sales
FROM mock_sales_data
GROUP BY country
ORDER BY num_sales DESC;

-- Query 3: Sales trends by month
-- Aggregates total sales by month and orders results chronologically
SELECT DATE_TRUNC('month', sales_date) AS sales_month,
       SUM(sales_amount) AS total_sales
FROM mock_sales_data
GROUP BY sales_month
ORDER BY sales_month;

-- Query 4: High-value transactions
-- Finds all sales where the amount exceeds 900, ordered by sales amount
SELECT *
FROM mock_sales_data
WHERE sales_amount > 900
ORDER BY sales_amount DESC;

-- Step 4: Optimize the table for frequent queries
-- Apply clustering to improve query performance when filtering or grouping by common columns
ALTER TABLE mock_sales_data CLUSTER BY (category, sales_date);

-- Step 5: Clean up the table after the demo
-- Drop the table to free up resources
DROP TABLE IF EXISTS mock_sales_data;
