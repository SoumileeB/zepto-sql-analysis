DROP TABLE IF EXISTS zepto;

-- Step 2: Create table

CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);

-- Step 3: Load CSV data
COPY zepto(category, name, mrp, discountPercent, availableQuantity, discountedSellingPrice, weightInGms, outOfStock, quantity)
FROM 'C:\Users\Soumilee\Documents\Projects\SQL\zepto_v2.csv'
DELIMITER ','
CSV HEADER;

-- Step 4: Data Exploration

-- Count of rows
SELECT COUNT(*) FROM zepto;

-- Sample data
SELECT * FROM zepto LIMIT 10;

-- Null values check
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

-- Different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Products in stock vs out of stock
SELECT outOfStock, COUNT(sku_id) AS product_count
FROM zepto
GROUP BY outOfStock;

-- Duplicate product names
SELECT name, COUNT(sku_id) AS num_skus
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

-- Step 5: Data Cleaning

-- Products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

-- Remove invalid rows
DELETE FROM zepto
WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- Check conversion
SELECT mrp, discountedSellingPrice FROM zepto LIMIT 10;

-- Step 6: Analysis Queries

-- Q1. Top 10 best-value products based on discount %
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. Products with high MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;

-- Q3. Estimated revenue per category
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Products with MRP > 500 and discount < 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Top 5 categories with highest average discount %
SELECT category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Price per gram for products above 100g (best value first)
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7. Group products into weight categories
SELECT DISTINCT name, weightInGms,
       CASE WHEN weightInGms < 1000 THEN 'Low'
            WHEN weightInGms < 5000 THEN 'Medium'
            ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q8. Total inventory weight per category
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;

-- Step 7: Unique Queries (to stand out)

-- UQ1. Top 10 products generating highest revenue
SELECT name,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY name
ORDER BY total_revenue DESC
LIMIT 10;

-- UQ2. Category contribution to overall revenue (% share)
WITH category_revenue AS (
    SELECT category,
           SUM(discountedSellingPrice * availableQuantity) AS revenue
    FROM zepto
    GROUP BY category
),
total AS (
    SELECT SUM(revenue) AS total_rev FROM category_revenue
)
SELECT c.category,
       c.revenue,
       ROUND((c.revenue / t.total_rev) * 100, 2) AS percent_share
FROM category_revenue c, total t
ORDER BY percent_share DESC;

-- UQ3. Average discount per weight category
WITH weight_groups AS (
    SELECT CASE WHEN weightInGms < 1000 THEN 'Low'
                WHEN weightInGms < 5000 THEN 'Medium'
                ELSE 'Bulk'
           END AS weight_category,
           discountPercent
    FROM zepto
)
SELECT weight_category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM weight_groups
GROUP BY weight_category
ORDER BY avg_discount DESC;

-- UQ4. Rank products within each category by discount %
SELECT category, name, discountPercent,
       RANK() OVER (PARTITION BY category ORDER BY discountPercent DESC) AS discount_rank
FROM zepto;

-- UQ5. Stock-out risk: top 10 products with lowest available quantity but high demand potential
SELECT name, category, availableQuantity, mrp, discountPercent
FROM zepto
WHERE availableQuantity < 10 AND discountPercent > 20
ORDER BY availableQuantity ASC, discountPercent DESC
LIMIT 10;