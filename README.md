# Zepto Inventory SQL Analysis

## Project Overview
This project is based on a grocery inventory dataset from Kaggle (inspired by Zepto).  
I used PostgreSQL to explore, clean, and analyze the data in order to answer practical business questions such as revenue by category, discount patterns, and products at risk of stock-out.  

The main aim was to practice SQL in a real dataset and show how SQL can be used for data-driven decision making.

---

## What I Did
- Created a table in PostgreSQL and imported the dataset.  
- Cleaned the data by handling null values, removing rows with zero price, and converting paise into rupees.  
- Explored product categories, duplicate SKUs, and stock status.  
- Wrote queries to calculate category revenue, top products by revenue, discount patterns, and inventory weight.  
- Used CTEs and window functions for more advanced analysis like category contribution and ranking products.  

---
## Key Takeaways

- Some categories dominate revenue contribution (like Snacks and Beverages).
- High-discount products are more likely to run out of stock quickly.
- Bulk items tend to bring steady revenue despite smaller discounts.

---
## How to Run

- Clone this repo
- Import the sql file into PostgreSQL
- Run the queries step by step
  
---
## Project Overview

This project is based on a grocery inventory dataset from [Kaggle](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset/data?select=zepto_v2.csv) (inspired by Zepto).  
I used PostgreSQL to explore, clean, and analyze the data in order to answer practical business questions such as revenue by category, discount patterns, and products at risk of stock-out.
