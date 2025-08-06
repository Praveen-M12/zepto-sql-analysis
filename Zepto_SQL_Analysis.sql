-- Drop the 'zepto' table if it already exists
IF OBJECT_ID('zepto', 'U') IS NOT NULL
    DROP TABLE zepto;

-- Create the 'zepto' table with proper SQL Server data types
CREATE TABLE zepto (
    sku_id INT IDENTITY(1,1) PRIMARY KEY,              -- Auto-incrementing unique ID
    category VARCHAR(120),                             -- Product category
    name VARCHAR(150) NOT NULL,                        -- Product name
    mrp DECIMAL(8,2),                                  -- Maximum retail price
    discountPercent DECIMAL(5,2),                      -- Discount percentage
    availableQuantity INT,                             -- Quantity in stock
    discountedSellingPrice DECIMAL(8,2),               -- Price after discount
    weightInGms INT,                                   -- Weight in grams
    outOfStock BIT,                                    -- 1 = out of stock, 0 = in stock
    quantity INT                                       -- Pack quantity
);

-- Load the data 
select *
from zepto;

-- ================================
-- DATA EXPLORATION
-- ================================

-- 1. Count total number of records in the zepto table
SELECT COUNT(*) AS total_rows FROM zepto;

-- 2. Display first 10 records from the zepto table
SELECT TOP 10 * FROM zepto;

-- 3. Find rows with NULLs in important columns
SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- 4. List unique product categories
SELECT DISTINCT category FROM zepto
ORDER BY category;

-- 5. Count of products that are in stock vs out of stock
SELECT outOfStock, COUNT(sku_id) AS product_count
FROM zepto
GROUP BY outOfStock;

-- 6. Find product names with more than one SKU (multiple entries)
SELECT name, COUNT(sku_id) AS number_of_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY number_of_skus DESC;

-- ================================
-- DATA CLEANING
-- ================================

-- 7. View products where price or discounted price is 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

-- 8. Delete rows where MRP is 0 (invalid data)
DELETE FROM zepto
WHERE mrp = 0;

-- 9. Convert price values from paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- 10. Show MRP and discounted price after update
SELECT mrp, discountedSellingPrice FROM zepto;

-- ================================
-- DATA ANALYSIS
-- ================================

-- 1. Top 10 products with highest discount percentages
SELECT TOP 10 name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC;

-- 2. High-priced products (MRP > ₹300) that are out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = 1 AND mrp > 300
ORDER BY mrp DESC;

-- 3. Total estimated revenue by product category
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- 4. Products with MRP > ₹500 and discount < 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- 5. Top 5 categories with the highest average discount
SELECT TOP 5 category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

-- 6. Price per gram for products above 100g, sorted by best value
SELECT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice * 1.0 / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- 7. Categorize products based on weight: Low (<1kg), Medium (1-5kg), Bulk (>5kg)
SELECT name, weightInGms,
       CASE 
           WHEN weightInGms < 1000 THEN 'Low'
           WHEN weightInGms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- 8. Total inventory weight (in grams) per category
SELECT category,
       SUM(CAST(weightInGms AS BIGINT) * CAST(availableQuantity AS BIGINT)) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;


