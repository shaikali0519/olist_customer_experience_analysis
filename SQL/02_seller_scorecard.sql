WITH seller_orders AS (
  SELECT oi.seller_id, d.order_id, d.delay_days, d.review_score,
         SUM(oi.price) AS order_revenue
  FROM order_items oi
  JOIN delivered_orders d ON oi.order_id = d.order_id
  GROUP BY oi.seller_id, d.order_id, d.delay_days, d.review_score
)
SELECT
  seller_id,
  COUNT(*) AS orders,
  ROUND(SUM(order_revenue), 0) AS revenue,
  ROUND(100.0 * SUM(CASE WHEN delay_days > 0 THEN 1 ELSE 0 END) / COUNT(*), 1) AS late_pct,
  ROUND(AVG(CAST(review_score AS FLOAT)), 2) AS avg_review
FROM seller_orders
GROUP BY seller_id
HAVING COUNT(*) >= 30
ORDER BY avg_review ASC;