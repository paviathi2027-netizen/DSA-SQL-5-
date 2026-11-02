SELECT 
manufacturer ,
CONCAT('$' , Round(sum(total_sales)/ 1000000), ' million') as sales_in_Million
from pharmacy_sales
GROUP BY manufacturer
ORDER BY Sum(total_sales) DESC, manufacturer ASC;

#Or

WITH drug_sales AS (
  SELECT 
    manufacturer, 
    SUM(total_sales) as sales 
  FROM pharmacy_sales 
  GROUP BY manufacturer
) 

SELECT 
  manufacturer, 
  ('$' || ROUND(sales / 1000000) || ' million') AS sales_mil 
FROM drug_sales 
ORDER BY sales DESC, manufacturer;

With call_count_details AS (SELECT 
policy_holder_id,
count(case_id) as calls_count
FROM callers
GROUP BY policy_holder_id 
having count(case_id) >=3)

select count(policy_holder_id) as policy_holder_count from call_count_details;

#OR

Select count(policy_holder_id) as policy_holder_count
From (
Select 
policy_holder_id,
count(case_id) as calls_count
FROM callers
GROUP BY policy_holder_id 
having count(case_id) >=3
) as Caller_details;

WITH user_trans_record AS (SELECT 
user_id,
spend,
transaction_date,
Row_Number() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) as row_rnk
FROM transactions)

SELECT user_id,
spend,
transaction_date
from user_trans_record
where row_rnk = 3;

#OR

SELECT 
  user_id,
  spend,
  transaction_date
FROM (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    ROW_NUMBER() OVER (
      PARTITION BY user_id ORDER BY transaction_date) AS row_num
  FROM transactions) AS trans_num 
WHERE row_num = 3;

WITH salary_details AS (SELECT 
employee_id,
salary,
Row_Number() OVER(ORDER BY salary DESC) as salr_rnk
FROM employee)

SELECT salary as second_highest_salary 
FROM salary_details
WHERE salr_rnk = 2;

#OR

Select max(salary) as second_highest_salary 
From employee 
where salary < (Select max(salary) from employee);