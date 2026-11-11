USE telco;
SHOW TABLES
SELECT *
FROM customer;


-- Q1. How many customers are there?
SELECT COUNT(*) AS total_customers 
FROM customer;

-- Q2. How many churned vs stayed?
SELECT SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
       SUM(CASE WHEN Churn = 'No'  THEN 1 ELSE 0 END) AS active
FROM customer;
 
 -- Q3. Overall churn rate
SELECT ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_rate_pct
FROM customer;

 
-- Q4. Customers per contract type
SELECT Contract, COUNT(*) AS customers
FROM customer 
GROUP BY Contract 
ORDER BY customers DESC;

-- Q5. Churn rate by contract type
SELECT Contract, COUNT(*) AS customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_pct
FROM customer 
GROUP BY Contract 
ORDER BY churn_pct DESC;

-- Q6. Churn rate by internet service
SELECT InternetService, COUNT(*) AS customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_pct
FROM customer 
GROUP BY InternetService 
ORDER BY churn_pct DESC;

 
-- Q7. Churn rate by payment method
SELECT PaymentMethod, COUNT(*) AS customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_pct
FROM customer 
GROUP BY PaymentMethod 
ORDER BY churn_pct DESC;

-- Q8. Monthly revenue lost vs monthly revenue kept
SELECT SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END) AS mrr_lost,
       SUM(CASE WHEN Churn = 'No'  THEN MonthlyCharges ELSE 0 END) AS mrr_kept
FROM customer;


-- Q10. when do customers leave?
SELECT CASE WHEN tenure <= 12 THEN '0-12 months'
            WHEN tenure <= 24 THEN '13-24 months'
            WHEN tenure <= 48 THEN '25-48 months'
            ELSE '49+ months' END AS tenure_bucket,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_pct
FROM customer
GROUP BY CASE WHEN tenure <= 12 THEN '0-12 months'
              WHEN tenure <= 24 THEN '13-24 months'
              WHEN tenure <= 48 THEN '25-48 months'
              ELSE '49+ months' END
ORDER BY MIN(tenure);

-- Q11. What share of churners left in their first 12 months?
SELECT ROUND(100.0 * SUM(CASE WHEN tenure <= 12 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_first_year
FROM customer 
WHERE Churn = 'Yes';

-- Q12. Revenue lost by contract type
SELECT Contract, SUM(MonthlyCharges) AS mrr_lost
FROM customer WHERE Churn = 'Yes'
GROUP BY Contract 
ORDER BY mrr_lost DESC;

-- Q13. Churn rate for senior citizens vs others
SELECT SeniorCitizen, COUNT(*) AS customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_pct
FROM customer 
GROUP BY SeniorCitizen;

-- Q14. Worst contract + internet service combination (at least 100 customers)
SELECT Contract, InternetService, COUNT(*) AS customers,
       ROUND(100.0 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS churn_pct
FROM customer
GROUP BY Contract, InternetService
HAVING COUNT(*) >= 100
ORDER BY churn_pct DESC;


