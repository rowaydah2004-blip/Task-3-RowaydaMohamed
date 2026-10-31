# E-Commerce SQL Data Analysis | DecodeLabs Project 3

**Data Analytics Internship · Project 03 · SQL / SQLite**

A reproducible SQL analysis of **1,200 e-commerce orders** recorded from **January 2023 through June 2025**. The project answers business questions about product activity, order outcomes, payment methods, customer behavior, marketing sources, and monthly trends using **22 documented SQL queries**.

> **Interpretation note:** `TotalPrice` includes cancelled, returned, pending, shipped, and delivered orders. All reported monetary totals are **recorded order values**, not verified revenue, refunds, profit, or financial losses.

## At a glance

| Measure | Result |
|---|---:|
| Orders | 1,200 |
| Unique customers | 1,189 |
| Recorded order value | 1,264,761.96 |
| Product categories | 7 |
| Payment methods | 5 |
| Months analyzed | 30 |
| Cancelled or returned orders | 497 (41.42%) |
| Recorded value associated with those orders | 519,673.91 (41.09%) |
| Repeat customers observed | 11 (0.93% of customers) |

## Project objectives

- Validate order identifiers, key fields, numerical ranges, and total calculations.
- Compare product, order-status, and payment-method patterns.
- Examine monthly order values and month-over-month variation.
- Study referral sources, coupon usage, repeat customers, and spending segments.
- Identify cancellation and return patterns for further business investigation.

## DecodeLabs Project 3 requirements

The official project brief asks for **`SELECT` queries**, **`WHERE` filtering**, **`ORDER BY` sorting**, **`GROUP BY` grouping**, and the **`COUNT`, `SUM`, and `AVG`** aggregate functions. These are demonstrated in the master script. The brief also suggests extensions such as `HAVING` and percentage contribution; a `HAVING` example appears in the separate product-payment analysis script, and percentage calculations appear throughout the master script.

The project additionally demonstrates `CASE WHEN`, CTEs (`WITH`), `strftime()`, `LAG()`, `RANK()`, `COALESCE()`, and `NULLIF()`.

## Files

```text
.
├── README.md
├── DecodeLabs_Project3_Complete_SQL_Analysis.sql
├── DecodeLabs_Project3_SQL_Analysis.db
├── DecodeLabs_Project3_Dataset.csv
├── Dataset for Data Analytics (2).xlsx
├── 29_Product_Payment_Risk_Analysis.sql
├── DecodeLabs_Project3_SQL_Analysis_Report.pdf
└── Screenshots/
    └── SQL_Master_Script_Execution.png
```

**Note:** This tree is the suggested GitHub repository layout. The report PDF is the file shown in the local project folder. If your filenames or extensions differ, update the tree to match what you upload. An editable `.docx` copy of the report may also be included.

## How to run

1. Install [DB Browser for SQLite](https://sqlitebrowser.org/).
2. Open `DecodeLabs_Project3_SQL_Analysis.db` in DB Browser.
3. Select the **Execute SQL** tab.
4. Open `DecodeLabs_Project3_Complete_SQL_Analysis.sql` using the SQL editor's **Open SQL file** control.
5. Execute the full script. It contains read-only `SELECT` statements and does not change the database.
6. Review the output and execution log. The final query groups orders by product and payment method and should return **35 rows** on this dataset.

**Verification:** The complete 22-query script was executed in DB Browser for SQLite and the application displayed **“Execution finished without errors.”** Evidence is in [`Screenshots/SQL_Master_Script_Execution.png`](Screenshots/SQL_Master_Script_Execution.png).

## Analysis structure

| Section | Queries | Topics |
|---|---|---|
| 01. Data validation | 01–05 | Record count, duplicate IDs, missing values, prices, calculation checks |
| 02. Business performance | 06–09 | Products, statuses, payments, cancellation/return rates |
| 03. Time-based analysis | 10–12 | Monthly trends, `LAG()` comparisons, `RANK()` |
| 04. Marketing and customers | 13–17 | Referrals, coupons, repeat purchasing, customer spending and segments |
| 05. Order risk | 18–22 | Product, quantity and product-payment cancellation/return patterns |

## Selected findings

- **Order outcomes:** 250 cancelled and 247 returned orders together account for **41.42%** of records. Their recorded order values total **519,673.91**. This is **not a verified revenue loss**.
- **Products:** Chair had the highest recorded order value (**195,620.11**), closely followed by Printer (**195,612.61**) and Laptop (**192,126.56**).
- **Customers:** 11 of 1,189 observed customers had more than one order. This is an observed repeat-purchase measure, **not** a complete customer retention rate.
- **Monthly activity:** June 2024 had the highest monthly recorded order value (**68,068.54**). April 2023 had the lowest (**27,751.71**).
- **Payment methods:** Gift Card had the highest combined cancellation/return rate (**44.35%**), compared with **35.27%** for Online. The difference is associative, not causal.
- **Detailed segment:** Tablet orders paid by Cash had **19 affected orders out of 35 (54.29%)**. Small subgroup sizes warrant caution.

## Recommendations

1. Capture standardized cancellation and return reasons and track them by product and fulfillment stage.
2. Build monthly order-outcome monitoring to complement recorded order-value trends.
3. Measure repeat purchases using customer acquisition cohorts and consistent observation windows.
4. Investigate differences by payment method and product while accounting for order mix and small sample sizes.
5. Connect referral information with marketing cost and completed-order data before judging channel effectiveness.

## Limitations

- No confirmed payment settlement, refund, cost, or profit information.
- No documented reasons for cancellations or returns.
- Incomplete historical visibility into customer purchases and acquisition dates.
- No marketing expenditure or conversion denominator.
- Small product-payment segments can produce unstable rates.
- Customer spending thresholds were defined for exploratory analysis, not as official business categories.

## Deliverables and submission checklist

- [x] Master SQL script with 22 labeled queries
- [x] Official SQL fundamentals covered: `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `COUNT`, `SUM`, `AVG`
- [x] Full script executed without errors against the project database
- [x] Execution screenshot captured
- [x] Analytical report drafted and saved
- [ ] Confirm every published link and filename works
- [ ] Review source data for personal or sensitive information before public upload
- [ ] Upload final files to a **public** GitHub repository
- [ ] Verify repository access while signed out or in an incognito window
- [ ] Submit the repository link through the official DecodeLabs portal

## Credits

Prepared by **Rowayda Mohamed** for the **DecodeLabs Data Analytics Internship, Project 3**.

This analysis is an educational project. Recommendations reflect patterns in the supplied dataset, not validated causal or financial conclusions.
