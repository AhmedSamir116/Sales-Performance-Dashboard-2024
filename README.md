# Sales Analysis – Excel Power Query & Power Pivot Dashboard

An end-to-end sales analysis project built in Microsoft Excel. It covers data
viewing and cleaning with Power Query, star schema data modeling with Power
Pivot, pivot table analysis, and an interactive **Sales Performance Dashboard 2024**.

## 📑 Table of Contents
1. [Project Overview](#-project-overview)
2. [Tools Used](#%EF%B8%8F-tools-used)
3. [Workflow](#-workflow)
4. [Key Insights](#-key-insights)
5. [Repository Structure](#-repository-structure)
6. [How to Use](#-how-to-use)
7. [Author](#-author)

## 📌 Project Overview
The project analyzes 2024 sales across five Egyptian regions (Alexandria, Aswan,
Cairo, Giza, Mansoura) using four tables: **Orders**, **Customers**,
**Products**, and **Calendar**. The catalog has **25 products in 5 categories**
(Books, Clothing, Electronics, Furniture, Toys).

| KPI | Value |
|---|---|
| Total Sales | $101,146,137 |
| Total Orders | 19,594 |
| Total Quantity | 108,120 |
| Total Customers | 300 |
| Total Products | 25 |

## 🛠️ Tools Used
- Microsoft Excel
- Power Query (data cleaning and transformation)
- Power Pivot and DAX (data modeling and measures)
- PivotTables, PivotCharts, and Slicers

## 🔄 Workflow

### 1. Data Viewing & Exploration
- Reviewed the structure, data types, and quality of each source
- Orders arrive as **multiple monthly files** in one folder, with inconsistent
  date formats
- Found duplicate customers, inconsistent text casing and spacing, and a price
  stored as text ("Two Hundred")

### 2. Data Cleaning with Power Query
The full M code for each query is in the [`power-query/`](power-query) folder.

**Customers** ([customers.pq](power-query/customers.pq))
- Promoted headers and set data types
- Removed duplicate customers by `CustomerID`
- Trimmed text and applied proper case to names
- Split `CustomerName` into **First Name** and **Last Name**
- Cleaned the `Region` column (removed non-printable characters and extra
  spaces) and applied proper case

**Orders** ([orders.pq](power-query/orders.pq))
- Combined all monthly files from the source folder into one table
- Removed rows with a missing `ProductID` or `Quantity`
- Rebuilt `OrderID` as a clean sequential index
- Standardized mixed date formats (`/` → `-`) and split each date into 3 parts
- Derived **Year** (the part greater than 31), **Month** (from the file name),
  and **Day** (the remaining part)
- Merged them into a single **New Date** column of type `date`
  (`en-US` locale)

**Products** ([products.pq](power-query/products.pq))
- Fixed a text price ("Two Hundred" → 200) and set `Price` to currency
- Trimmed and applied proper case to `ProductName` and `Category`

**Calendar**
- Date table with Year, Month Number, Month, MMM-YYYY, Day Of Week Number,
  Day Of Week, and a Date Hierarchy

### 3. Data Modeling – Star Schema
- **Fact table:** `order` (OrderID, CustomerID, ProductID, Quantity, New Date)
- **Dimension tables:**
  - `Products` (ProductID, ProductName, Category, Price)
  - `Customers` (CustomerID, First Name, Last Name, Region)
  - `Calendar` (Date, Year, Month Number, Month, MMM-YYYY,
    Day Of Week Number, Day Of Week, Date Hierarchy)
- **Relationships:** one-to-many from each dimension to the fact table
  (Products → order, Customers → order, Calendar → order)

**DAX measures (in the `order` table):**

| Measure | Purpose |
|---|---|
| `Total Sales` | Total sales revenue |
| `Total Quantity` | Total units sold |
| `Total Orders` | Number of orders |
| `Total Customer` | Number of distinct customers |

<img width="1143" height="557" alt="image" src="https://github.com/user-attachments/assets/06ba9457-13b2-41e1-a4bf-d206f920dfeb" />


### 4. Analysis with Pivot Tables
- Total Sales by product and by category
- Total Quantity by product
- Total Sales by region
- Core KPIs: sales, quantity, orders, customers, and products

<img width="1160" height="446" alt="image" src="https://github.com/user-attachments/assets/c2427673-39c1-4e15-9fef-93cf5fb5e0c8" />


### 5. Dashboard
An interactive dashboard with slicers for **Category**, **Region**, and **Month**:
- 5 KPI cards: Total Sales, Total Orders, Total Quantity, Total Customers,
  Total Products
- Sales distribution by product (bar chart, top and bottom products highlighted)
- Percentage of sales by region (donut chart)
- Total sales by category (column chart)
- Monthly sales trend (line chart)

<img width="1297" height="472" alt="Dashboard" src="https://github.com/user-attachments/assets/547c3933-e2fd-4a49-aca0-4f7cc5f9d2a7" />


## 🔍 Key Insights
- **Total sales** reached **$101.1M** from **19,594 orders** and **300 customers**
  (an average of about **$5,160 per order**).
- **Clothing** is the top category with **$29.1M (~29%)**, followed by **Toys**
  ($25.4M) and **Electronics** ($19.0M). **Furniture** is the lowest at $10.4M.
- **Doll** ($8.15M) and **Shirt** ($7.21M) are the best-selling products, while
  **Sofa** ($0.26M) and **Headphones** ($0.89M) sell the least.
- Units sold are fairly even across products (about **3,900–4,600** units each),
  so the sales gap between products comes mostly from **price**, not volume.
- Sales are spread evenly across regions: **Mansoura** leads (~$21.0M), then
  Aswan (~$20.6M), Cairo (~$20.5M), and Giza (~$20.4M). **Alexandria** is the
  lowest (~$18.7M).
- Monthly sales stay around $8.3–8.7M all year, peaking in **May (~$8.66M)** and
  **April (~$8.63M)**, with the lowest month in **February (~$8.31M)**.

## 📁 Repository Structure
```
├── data/                    # Source datasets (Customers.csv, Products.csv, order/)
├── power-query/
│   ├── customers.pq
│   ├── orders.pq
│   └── products.pq
├── images/
│   ├── star-schema.png
│   ├── pivot-tables.png
│   └── dashboard.png
├── Sales_Analysis.xlsx      # Final Excel file
└── README.md
```

## 🚀 How to Use
1. Download `Sales_Analysis.xlsx`.
2. Open it in Excel 2016 or later with the Power Pivot add-in enabled.
3. Update the source file paths in Power Query if needed
   (**Data → Get Data → Query Options → Data Source Settings**).
4. Go to **Data → Refresh All** to update the model.
5. Use the slicers to explore the dashboard.

## 👤 Author
Ahmed Samir – www.linkedin.com/in/ahmed-samir-190155238
