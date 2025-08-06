# zepto-sql-analysis
SQL analysis performed on Zepto dataset including data cleaning, aggregation, and insights.
# Zepto SQL Analysis

This repository contains SQL queries and analysis based on a Zepto dataset. It includes:

- Data cleaning
- Aggregations
- Grouping and filtering
- Insights generation

## Query Example
```sql
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category;

