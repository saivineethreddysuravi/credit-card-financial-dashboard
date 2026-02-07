-- SQL Data Quality Check
SELECT transaction_id, amount 
FROM transactions 
WHERE amount IS NULL OR amount < 0;
