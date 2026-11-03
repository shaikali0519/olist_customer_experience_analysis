# Olist Customer Experience Analysis

**Business question:** Only about 3% of Olist customers buy again. What in the delivery and seller experience hurts customers, and what should the business fix first?

**Tools:** SQL Server (T-SQL: CTEs, window functions, views), Power BI
**Data:** [Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). Download it and import the CSVs into SQL Server. Raw data is not included in this repo.

## Data-quality decisions
- Analysed **delivered** orders only (cancelled and unfinished orders have no delivery date).
- Kept the **latest review per order** (some orders have several reviews).
- Used `customer_unique_id` for repeat purchases, because `customer_id` changes with every order.
- Seller analysis includes only sellers with **30+ orders**.

## Key findings
1. **Late delivery is associated with much lower reviews.** On-time orders average 4.29 stars; 1-3 days late 3.29; 4-7 days late 2.10; 8+ days late 1.70. Even a short delay costs about one star.
2. **Revenue linked to bad experiences.** Of R$15.29M total revenue, R$1.11M (7.3%) came from late orders and R$2.30M (15.1%) from 1-2 star orders. About 65% of late-order revenue got a 1-2 star review.
3. **Lateness is not the whole story.** About 69% of 1-2 star revenue came from on-time orders, so product and service quality also matter.
4. **Repeat purchase is low everywhere.** Repeat rate is 3.01% after an on-time first order, 2.48% after a 1-7 day delay and 2.62% after 8+ days late. A late first delivery lowers it only slightly, so retention needs more than delivery fixes.
5. **A small group of sellers causes more than its share of problems.** The 157 sellers in the Coach and Review segments handle 25.3% of orders but cause 39.3% of bad reviews. The 23 Review sellers have a 15.2% average late rate versus 5.1% for Keep sellers.

## Recommendations
1. **Fix late deliveries first in the worst seller groups.** Start a coaching programme for the 134 Coach sellers and a performance review for the 23 Review sellers.
2. **Investigate on-time bad reviews.** Most unhappy customers received their order on time, so check product quality and listing accuracy by category.
3. **Treat retention separately.** With a 3% repeat rate even after good deliveries, test follow-up offers and re-engagement, because delivery alone will not bring customers back.

## Limitations
These are associations, not proof of cause. Repeat purchase counts only later orders that were delivered and reviewed. Seller segments use simple thresholds (average review below 3.5 = Review; below 4.0 or more than 15% late = Coach).

## Project files
`SQL/` contains the numbered queries (00 to 06). The Power BI dashboard is in `dashboard/` (coming next).
