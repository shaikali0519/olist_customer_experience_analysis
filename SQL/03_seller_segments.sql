WITH seller_orders AS (
  SELECT oi.seller_id, d.order_id, d.delay_days, d.review_score,
         SUM(oi.price) AS order_revenue
  FROM order_items oi
  JOIN delivered_orders d ON oi.order_id = d.order_id
  GROUP BY oi.seller_id, d.order_id, d.delay_days, d.review_score
),
scorecard AS (
  SELECT seller_id,
         COUNT(*) AS orders,
         SUM(order_revenue) AS revenue,
         100.0 * SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) / COUNT(*) AS late_pct,
         AVG(CAST(review_score AS FLOAT)) AS avg_review
  FROM seller_orders
  GROUP BY seller_id
  HAVING COUNT(*) >= 30
),
classified AS (
  SELECT *,
         CASE WHEN avg_review < 3.5 THEN '3. Review'
              WHEN avg_review < 4.0 OR late_pct > 15 THEN '2. Coach'
              ELSE '1. Keep' END AS segment
  FROM scorecard
)
SELECT segment,
       COUNT(*) AS sellers,
       SUM(orders) AS orders,
       ROUND(SUM(revenue), 0) AS revenue,
       ROUND(AVG(late_pct), 1) AS avg_late_pct,
       ROUND(AVG(avg_review), 2) AS avg_review
FROM classified
GROUP BY segment
ORDER BY segment;