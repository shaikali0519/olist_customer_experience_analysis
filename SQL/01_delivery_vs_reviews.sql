WITH bucketed AS (
  SELECT
    CASE
      WHEN delay_days <= 0 THEN '1. On time'
      WHEN delay_days <= 3 THEN '2. 1-3 days late'
      WHEN delay_days <= 7 THEN '3. 4-7 days late'
      ELSE '4. 8+ days late'
    END AS delay_bucket,
    review_score
  FROM delivered_orders
)
SELECT delay_bucket,
       COUNT(*) AS orders,
       ROUND(AVG(CAST(review_score AS FLOAT)), 2) AS avg_review
FROM bucketed
GROUP BY delay_bucket
ORDER BY delay_bucket;