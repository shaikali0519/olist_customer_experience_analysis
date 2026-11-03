WITH cust_orders AS (
  SELECT c.customer_unique_id, d.delay_days, d.review_score,
         ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id
                            ORDER BY d.order_purchase_timestamp) AS rn,
         COUNT(*) OVER (PARTITION BY c.customer_unique_id) AS total_orders
  FROM delivered_orders d
  JOIN customers c ON d.customer_id = c.customer_id
),
first_orders AS (
  SELECT *,
         CASE WHEN delay_days <= 0 THEN '1. On time'
              WHEN delay_days <= 7 THEN '2. 1-7 days late'
              ELSE '3. 8+ days late' END AS first_delivery
  FROM cust_orders
  WHERE rn = 1
)
SELECT first_delivery,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS repeat_pct
FROM first_orders
GROUP BY first_delivery
ORDER BY first_delivery;