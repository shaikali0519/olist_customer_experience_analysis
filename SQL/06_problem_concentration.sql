WITH seller_orders AS (
  SELECT oi.seller_id, d.order_id, d.delay_days, d.review_score
  FROM order_items oi
  JOIN delivered_orders d ON oi.order_id = d.order_id
  GROUP BY oi.seller_id, d.order_id, d.delay_days, d.review_score
),
scorecard AS (
  SELECT seller_id,
         COUNT(*) AS orders,
         100.0 * SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) / COUNT(*) AS late_pct,
         AVG(CAST(review_score AS FLOAT)) AS avg_review,
         SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) AS late_orders,
         SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) AS bad_orders
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
SELECT segment, COUNT(*) AS sellers, SUM(orders) AS orders,
  ROUND(100.0 * SUM(orders) / SUM(SUM(orders)) OVER (), 1) AS pct_of_orders,
  ROUND(100.0 * SUM(late_orders) / SUM(SUM(late_orders)) OVER (), 1) AS pct_of_late_orders,
  ROUND(100.0 * SUM(bad_orders) / SUM(SUM(bad_orders)) OVER (), 1) AS pct_of_bad_reviews
FROM classified
GROUP BY segment
ORDER BY segment;