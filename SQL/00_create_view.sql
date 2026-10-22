CREATE OR ALTER VIEW delivered_orders AS
WITH latest_review AS (
  SELECT order_id, review_score,
         ROW_NUMBER() OVER (PARTITION BY order_id
                            ORDER BY review_creation_date DESC) AS rn
  FROM reviews
)
SELECT
  o.order_id,
  o.customer_id,
  o.order_purchase_timestamp,
  DATEDIFF(day, o.order_estimated_delivery_date,
                o.order_delivered_customer_date) AS delay_days,
  r.review_score
FROM orders o
JOIN latest_review r ON o.order_id = r.order_id AND r.rn = 1
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL;