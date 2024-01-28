-- ALTER TABLE hrdata
-- RENAME COLUMN `ï»¿Name` TO `EmpName`;

-- ALTER TABLE hrdata
-- RENAME COLUMN `Date of Join` TO `DateofJoin`;

-- ALTER TABLE hrdata
-- RENAME COLUMN `Education Qualification` TO `EdQual`;

-- ALTER TABLE hrdata
-- RENAME COLUMN `Leave Balance` TO `LeaveBal`;

-- ALTER TABLE hrdata
-- RENAME COLUMN `Job Title` TO `JobTitle`;

-- ALTER TABLE hrdata
-- RENAME COLUMN `Emp ID` TO `EmpID`;

-- ALTER TABLE hrdata
-- CHANGE COLUMN `DateofJoin` DateofJoin date;

/*




*/

-- 1) How many people are in each job?
select JobTitle, count(JobTitle) as FolksCount from hrdata group by JobTitle order by FolksCount desc;

-- 2) Gender break-down of the staff
select Gender, count(Gender) as FolksCount from hrdata group by Gender order by FolksCount desc;

-- 3) Age spread of the staff
SELECT
  FLOOR(Age/5) * 5 AS range_start,
  COUNT(*) AS frequency
FROM
  hrdata
GROUP BY
  range_start
ORDER BY
  range_start;
  
-- 4) Which jobs pay more?
select JobTitle, min(Salary) as MinSalary, round(avg(Salary),2) as AvgSalary,
      max(Salary) as MaxSalary 
from hrdata group by JobTitle order by AvgSalary desc;

-- 5) Top earners in each job
WITH RankedSalaries AS (
  SELECT
    jobtitle,
    salary, EmpName,
    ROW_NUMBER() OVER (PARTITION BY jobtitle ORDER BY salary DESC) AS SalaryRank
  FROM
    hrdata
)
SELECT
 EmpName,  jobtitle,
  salary
FROM
  RankedSalaries
WHERE
  SalaryRank = 1;

-- BONUS) Bottom earners in each job
WITH RankedSalaries AS (
  SELECT
    jobtitle,
    salary, EmpName,
    ROW_NUMBER() OVER (PARTITION BY jobtitle ORDER BY salary ASC) AS SalaryRank
  FROM
    hrdata
)
SELECT
 EmpName,  jobtitle,
  salary
FROM
  RankedSalaries
WHERE
  SalaryRank = 1;

-- 6) Qualification vs. Salary
SELECT 
    EdQual, ROUND(AVG(salary), 2) AS AvgSalary
FROM
    hrdata
GROUP BY EdQual
ORDER BY AvgSalary DESC;

-- 7) Staff growth trend over time
SELECT
  DateofJoin,
  count(DateofJoin) As JoinedCount,
  COUNT(*) OVER (ORDER BY DateofJoin) AS RunningTotal
FROM
  hrdata
  group by DateofJoin
order by DateofJoin;

-- 8) Employee filter by starting letter A with Joining Year greater or equal to than 2022
SELECT 
    *
FROM hrdata
WHERE EmpName LIKE 'A%' AND YEAR(DateOfJoin) >= 2022
ORDER BY DateOfJoin;

-- 9) Leave balance analysis
SELECT 
    empname, 
    SUM(LeaveBal) AS LeaveBalance
FROM
    hrdata
GROUP BY empname
HAVING SUM(LeaveBal) > 20
ORDER BY LeaveBalance DESC;

-- Which individuals have salaries below the average salary, considering both gender and job title?

with cte as (
        SELECT *, 
            round(avg(salary) over(partition by Gender, JobTitle),2) as AvgSalary 
        from hrdata)

select *, AvgSalary-Salary as DiffSalary 
  from cte 
  where Salary = AvgSalary;

