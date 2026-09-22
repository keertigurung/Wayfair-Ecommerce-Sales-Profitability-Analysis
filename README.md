# Wayfair E-commerce Sales & Profitability Analysis

## Case Study Context

This project analyzes a simulated e-commerce dataset based on a Wayfair business scenario. 
The project does not represent internal Wayfair data or employment experience.

## Project Overview

This project analyzes historical e-commerce sales data from 2024–2025 to evaluate sales performance, profitability, product and category performance, and the impact of returns and cancellations.

The analysis follows an end-to-end data analytics workflow, from data cleaning and exploratory analysis to SQL-based analysis and interactive Power BI visualization.

## Business Problem

Wayfair operates a large e-commerce marketplace where sales performance can vary across products, categories, and time periods. This analysis evaluates historical sales data to understand changes in sales and profitability, identify products and categories contributing to performance, and examine the role of returns and cancellations.

## Key Business Questions

1. How has sales performance changed from 2024 to 2025?
2. Which product and categories drive revenue and profitability?
3. How are returns and cancellations affecting sales performance?

## Dataset Overview

The project uses four datasets covering customers, products, orders, and order items.

| Dataset | Records | Purpose |
|---|---:|---|
| Customers | 3,600 | Customer and acquisition information |
| Products | 90 | Product, category, price, and cost information |
| Orders | 9,207 | Order dates, status, payment, discounts, and shipping |
| Order Items | 15,409 | Product-level transaction details |

The datasets cover e-commerce transactions from 2024–2025 and provide the information required to analyze sales performance, profitability, product performance, and order status.

## Tools & Technologies

- **Python** — data understanding, data cleaning, and exploratory data analysis
- **PostgreSQL** — relational data storage and data modeling
- **SQL** — KPI calculations and business-question analysis
- **Power BI** — interactive dashboard and data visualization

## Analytical Workflow

The project follows an end-to-end data analytics workflow:

**Raw Data → Data Cleaning → Exploratory Data Analysis → Data Modelling → KPI Definition → SQL Analysis → Power BI Dashboard → Insights & Recommendations**

### Workflow Overview

1. **Data Understanding** — Reviewed dataset structure, data types, missing values, duplicates, and relationships.
2. **Data Cleaning** — Removed duplicate records, handled missing values, converted date fields, and standardized category names.
3. **Data Modeling** — Built a relational data model in PostgreSQL using dimension and fact tables.
4. **KPI Definition** — Defined revenue, profit, profit margin, orders, average order value, return rate, and cancellation rate.
5. **EDA** — Used Python and Matplotlib to identify trends and patterns.
6. **SQL Analysis** — Used PostgreSQL and SQL to answer the main business questions.
7. **Power BI Dashboard** — Created an interactive dashboard for sales, profitability, product, and order-status analysis.
8. **Insights & Recommendations** — Summarized key findings and identified areas for business attention.

## Data Cleaning & Data Modeling

### Data Cleaning

The raw datasets were reviewed for missing values, duplicate records, invalid values, and data-type issues before analysis.

The main cleaning steps included:

- Removed **38 exact duplicate order records**.
- Removed **199 order-item records** with missing unit prices.
- Converted order and customer date fields from text to date format.
- Replaced missing discount codes with **"No Discount"**.
- Standardized product category names by removing extra spaces and applying consistent capitalization.
- Validated relationships between customers, orders, order items, and products.

After cleaning, the final datasets contained:

- **3,600 customers**
- **9,207 orders**
- **15,409 order items**
- **90 products**

### Data Model

A relational data model was created in PostgreSQL to support consistent analysis and reporting.

The main tables are:

- `dim_customer`
- `dim_product`
- `dim_date`
- `dim_order`
- `fact_order_items`

The `fact_order_items` table contains transaction-level quantities, prices, discounts, revenue, cost, and profit. The dimension tables provide descriptive information used to analyze transactions by customer, product, date, and order status.

### Derived Financial Metrics

The following metrics were derived from the transaction-level data:

**Revenue = (Quantity × Unit Price) − Discount Amount**

**Cost = Quantity × Unit Cost**

**Profit = Revenue − Cost**

These metrics were used consistently across the SQL analysis and Power BI dashboard.

## KPI Definitions & Key Metrics

The following KPIs were defined to provide consistent measures across the SQL analysis and Power BI dashboard.

| KPI | Definition |
|---|---|
| Total Revenue | Sum of net revenue from order items |
| Total Profit | Total Revenue − Total Cost |
| Profit Margin | Total Profit ÷ Total Revenue × 100 |
| Total Orders | Number of unique orders represented in the transaction data |
| Average Order Value | Total Revenue ÷ Total Orders |
| Return Rate | Returned Orders ÷ Total Orders × 100 |
| Cancellation Rate | Canceled Orders ÷ Total Orders × 100 |

### Overall Results

| Metric | Result |
|---|---:|
| Total Revenue | $2.05M |
| Total Profit | $1.01M |
| Profit Margin | 49.20% |
| Total Orders | 9,140 |
| Average Order Value | $223.99 |
| Return Rate | 4.42% |
| Cancellation Rate | 3.74% |

## Key Findings

### Sales Performance

- Revenue increased by **21.0%** from 2024 to 2025.
- Profit increased by **27.7%** over the same period.
- Profit margin increased from **47.75% to 50.39%**.
- **November** was the strongest month for revenue and order volume in both years.
- November 2025 generated approximately **$141.1K in revenue**, compared with **$107.5K in November 2024**.

### Product & Category Performance

- **Furniture** generated the highest total revenue at approximately **$367.9K**.
- **Furniture** also generated the highest total profit at approximately **$170.3K**.
- **Storage** recorded the highest category profit margin at **55.59%**.
- **Cotton Patio Chair** generated the highest product revenue at approximately **$74.5K** and the highest product profit at approximately **$33.3K**.
- High revenue does not always translate into the highest profit margin.

### Returns & Cancellations

- **407 of 9,207 orders were returned**, resulting in an overall return rate of **4.42%**.
- **344 of 9,207 orders were canceled**, resulting in an overall cancellation rate of **3.74%**.
- **Furniture** had the highest category return rate at **11.66%**.
- **Bath** had the highest category cancellation rate at approximately **4.50%**.

## Power BI Dashboard

The Power BI dashboard provides an interactive overview of sales performance, profitability, product performance, and order-status analysis.

The dashboard includes:

- Total Revenue
- Total Profit
- Profit Margin
- Total Orders
- Average Order Value
- Monthly Revenue Trend
- Revenue and Profit by Category
- Top 10 Products by Revenue
- Return and Cancellation Rate by Category

Users can filter the analysis by **Year, Category, and Order Status**.

The Power BI report is available in the [`powerbi/`](powerbi/) folder.

## Project Structure

| Folder / File | Description |
|---|---|
| `data/raw/` | Documentation for the original source datasets |
| `data/processed/` | Documentation for cleaned and transformed datasets |
| `notebooks/` | Python notebooks for data understanding, cleaning, and EDA |
| `sql/` | SQL scripts for data modeling, KPI analysis, and business questions |
| `powerbi/` | Power BI dashboard |
| `report/` | Final project report |
| `presentation/` | Final project presentation |
| `README.md` | Project documentation |

## Deliverables

The project includes the following deliverables:

| Deliverable | File |
|---|---|
| Data understanding, cleaning & EDA | [`notebooks/`](notebooks/) — `Wayfair_Ecommerce_Analysis.ipynb` |
| Data model & SQL analysis | [`sql/`](sql/) — `01_data_model.sql`, `02_kpi_analysis.sql`, `03_business_questions.sql` |
| Power BI dashboard | [`powerbi/`](powerbi/) — `Wayfair_Ecommerce_Analysis.pbix` |
| Final analysis report | [`report/`](report/) — `Wayfair_Ecommerce_Analysis_Report.pdf` |
| Project presentation | [`presentation/`](presentation/) — `WayFair E-commerce Analysis.pptx` |

## Data Availability & Reproducibility

The original source CSV files were provided through the Data Career School e-commerce sales analysis lab and are not included in this public repository.

The repository includes the complete analysis workflow, including:

- Python notebooks documenting data understanding, cleaning, and exploratory analysis
- SQL scripts documenting data modeling, KPI calculations, and business-question analysis
- Power BI dashboard for interactive visualization
- Final report and presentation documenting the results

The analysis can be reproduced by obtaining the original source datasets and following the documented workflow in the notebooks and SQL scripts.

## Business Recommendations

- **Monitor category-level profitability:** Track revenue together with profit margin to identify categories where strong sales volume does not necessarily translate into higher profitability.
- **Investigate Furniture returns:** Furniture has the highest return rate at **11.66%**. Further analysis should examine potential causes such as product expectations, product descriptions, quality, or fulfillment.
- **Review Bath cancellations:** Bath has the highest cancellation rate at approximately **4.50%**. Investigating the reasons for cancellations could help identify operational or product-related issues.
- **Evaluate high-revenue products:** Products generating high revenue but comparatively lower profit margins should be reviewed for pricing, cost, and promotional strategies.
- **Plan around seasonal demand:** November recorded the highest revenue and order volume in both years. Seasonal demand patterns should be considered when planning inventory and promotional activity.

## Limitations

- The dataset represents a **simulated e-commerce business scenario** and does not represent internal Wayfair data.
- **199 order-item records with missing unit prices were removed**, so some transactions are not included in transaction-level revenue and profitability analysis.
- The dataset does not contain **refund amounts or the financial impact of cancellations and returns**, so their direct monetary impact could not be calculated.
- The analysis covers only the **2024–2025 period**, so longer-term trends could not be evaluated.

## Conclusion

This project demonstrates an end-to-end approach to e-commerce sales and profitability analysis using Python, PostgreSQL, SQL, and Power BI. The analysis combines data preparation, analytical modeling, business-question analysis, and interactive visualization to generate actionable business insights.
