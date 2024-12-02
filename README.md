
# Snowflake Mock Data Demo

This repository provides a SQL script to demonstrate Snowflake's ability to handle large datasets efficiently. The demo includes creating a mock dataset, querying it, and optimizing the table for analytical queries.

## Prerequisites
1. A Snowflake account.
2. Access to the Snowflake Web UI or SnowSQL CLI.
3. A compute warehouse set up in your Snowflake account.

## Steps to Set Up and Run the Demo

### Step 1: Create the Table
1. Open the Snowflake Web UI or your preferred SQL interface for Snowflake.
2. Run the SQL file `demo.sql` starting with the `CREATE TABLE` statement to define the structure of the `mock_sales_data` table.

### Step 2: Populate the Table with Mock Data
1. The `INSERT INTO mock_sales_data` query in the script uses Snowflake's `TABLE(GENERATOR(...))` feature to generate 10 million rows of random data.
2. Execute this part of the script to populate the table.

### Step 3: Query the Data
1. Run the queries in the script to explore the mock data:
   - **Total sales by category**: Aggregates sales across categories.
   - **Sales statistics by country**: Shows the number of sales, average sales amount, and distribution across countries.
   - **Sales trends by month**: Analyzes trends over time.
   - **High-value transactions**: Lists sales above a threshold.

### Step 4: Optimize the Table
1. Use the `ALTER TABLE` statement in the script to apply clustering keys to the table (`category` and `sales_date`) for improved query performance.

### Step 5: Clean Up
1. Drop the `mock_sales_data` table to free up storage and resources after completing the demo.

## Key Features Demonstrated
- Use of `TABLE(GENERATOR(...))` to create mock data directly in Snowflake.
- Fast query execution on a large dataset (10 million+ rows).
- Clustering for performance optimization.
- Real-world use cases for analytics in Snowflake.

## Notes
- Adjust the `ROWCOUNT` in the `TABLE(GENERATOR(...))` clause to create a larger or smaller dataset as needed.
- Make sure your compute warehouse is sized appropriately for the dataset.

