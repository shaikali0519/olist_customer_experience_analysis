WITH order_rev AS (
  SELECT order_id, SUM(price + freight_value) AS order_value
  FROM order_items GROUP BY order_id
)
SELECT
  ROUND(SUM(r.order_value), 0) AS total_revenue,
  ROUND(SUM(CASE WHEN d.delay_days > 0 THEN r.order_value ELSE 0 END), 0) AS late_revenue,
  ROUND(SUM(CASE WHEN d.review_score <= 2 THEN r.order_value ELSE 0 END), 0) AS bad_review_revenue,
  ROUND(SUM(CASE WHEN d.delay_days > 0 AND d.review_score <= 2
                 THEN r.order_value ELSE 0 END), 0) AS late_and_bad_revenue
FROM delivered_orders d
JOIN order_rev r ON d.order_id = r.order_id;