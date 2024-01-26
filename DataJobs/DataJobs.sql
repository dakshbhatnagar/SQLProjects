-- use database_name

-- show tables

-- describe jobs

/*
work_year, job_title, job_category, salary_currency, salary, 
salary_in_usd, employee_residence, experience_level, employment_type, work_setting, company_location, company_size
*/

-- What are the various Job Categories and their count of jobs
SELECT 
    job_category, COUNT(job_category) AS JobCount
FROM
    jobs
GROUP BY job_category
ORDER BY COUNT(job_category) DESC;

-- Avg Salaries grouped by different job_category sorted in descending ordder
SELECT 
    job_category,
    ROUND(AVG(salary_in_usd) / 1000, 2) AS AvgSalaryThousands
FROM
    jobs
GROUP BY job_category
ORDER BY AVG(salary_in_usd) DESC;

-- Make a salary histogram to show the ranges and their counts
with cte as (
select *, case when salary_in_usd< 50000 then '0-50000'
		WHEN salary_in_usd > 50000 AND salary_in_usd <= 100000 THEN '50001-100000'
        WHEN salary_in_usd > 100000 AND salary_in_usd <= 200000 THEN '100001-200000'
        WHEN salary_in_usd > 20000 AND salary_in_usd <= 300000 THEN '20000-300000'
        else '300000+' end as SalaryRange
		from jobs)
select SalaryRange, count(SalaryRange) as HeadCount from cte group by SalaryRange order by SalaryRange;

-- What is the distribution of salary ranges among different company sizes?
with cte as (
select *, case when salary_in_usd< 50000 then '0-50000'
		WHEN salary_in_usd > 50000 AND salary_in_usd <= 100000 THEN '50001-100000'
        WHEN salary_in_usd > 100000 AND salary_in_usd <= 200000 THEN '100001-200000'
        WHEN salary_in_usd > 20000 AND salary_in_usd <= 300000 THEN '20000-300000'
        else '300000+' end as SalaryRange
		from jobs)
        
SELECT 
    company_size,
    SUM(CASE
        WHEN SalaryRange = '0-50000' THEN 1
        ELSE 0
    END) AS '0-50000',
    SUM(CASE
        WHEN SalaryRange = '50001-100000' THEN 1
        ELSE 0
    END) AS '50001-100000',
    SUM(CASE
        WHEN SalaryRange = '100001-200000' THEN 1
        ELSE 0
    END) AS '100001-200000',
    SUM(CASE
        WHEN SalaryRange = '20000-300000' THEN 1
        ELSE 0
    END) AS '20000-300000',
    SUM(CASE
        WHEN SalaryRange = '300000+' THEN 1
        ELSE 0
    END) AS '300000+'
FROM
    cte
GROUP BY company_size;

-- In what work setting people are being paid the most. Output results in descending order on Salary column
SELECT 
    work_setting, ROUND(AVG(salary_in_usd), 2) AS AvgSalary
FROM
    jobs
GROUP BY work_setting
ORDER BY AvgSalary DESC;

-- Find out what avgsalary looks like at each experience level for the work setting with the max avg salary
SELECT 
    experience_level, ROUND(AVG(salary_in_usd), 2) AS AvgSalary
FROM
    jobs
WHERE
    work_setting = 'In-person'
GROUP BY experience_level
ORDER BY AvgSalary DESC;

-- what job titles get paid the most where the work setting has the max avg salary
SELECT 
    job_title, ROUND(AVG(salary_in_usd), 2) AS AvgSalary
FROM
    jobs
WHERE
    work_setting = 'In-person'
GROUP BY job_title
ORDER BY AvgSalary DESC;

-- Which Country's Companies provide higher than average salary
SELECT 
    company_location,
    MIN(salary_in_usd) AS MinSalary,
    ROUND(AVG(salary_in_usd), 2) AS AvgSalary,
    MAX(salary_in_usd) AS MaxSalary
FROM
    jobs
WHERE
    salary_in_usd > (SELECT 
            AVG(salary_in_usd)
        FROM
            jobs)
GROUP BY company_location
ORDER BY AvgSalary DESC;

-- Has the avg salary gone up over the years?
SELECT 
    work_year, ROUND(AVG(salary_in_usd), 2) AS AvgSalary
FROM
    jobs
GROUP BY work_year
ORDER BY work_year;

-- How does average salary over the years for each job category look like? 
select job_category, 
	round(avg(Case when work_year = 2020 then salary_in_usd else 0 end),2) as AvgSalary_2020, 
	round(avg(Case when work_year = 2021 then salary_in_usd else 0 end),2) as AvgSalary_2021,
	round(avg(Case when work_year = 2022 then salary_in_usd else 0 end),2) as AvgSalary_2022,
	round(avg(Case when work_year = 2023 then salary_in_usd else 0 end),2) as AvgSalary_2023,
	round(avg(salary_in_usd),2) as TotalAvgSalary
from jobs 
group by job_category 
order by avg(salary_in_usd) desc;

-- Show the avg salaries for various job titles. Also calculate what % of the total avg salary they get
SELECT 
    job_title,
    ROUND(AVG(salary_in_usd), 2) AS AvgSalary,
    ROUND(AVG(salary_in_usd) / (SELECT 
                    AVG(salary_in_usd)
                FROM
                    jobs) * 100,
            2) AS Pct_Salary
FROM
    jobs
GROUP BY job_title
ORDER BY AvgSalary DESC;

-- count the folks for each employment_type and show the total avg salary and each employment_type's avg salary. Order the results in ascending order by AvgSalary
SELECT 
    employment_type,
    COUNT(employment_type) AS CountOfFolks,
    round((select avg(salary_in_usd) from jobs),2) as TotalAvgSalary,
    round(AVG(salary_in_usd),2) AS AvgSalary
FROM
    jobs
GROUP BY employment_type
ORDER BY AvgSalary







