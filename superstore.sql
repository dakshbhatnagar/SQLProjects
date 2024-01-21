-- use superstore

-- show tables

-- show columns from store

/*
OrderPriority, Discount, UnitPrice, ShippingCost, CustomerID, CustomerName, ShipMode, CustomerSegment, ProductCategory, 
ProductSub-Category, ProductContainer, ProductName, ProductBaseMargin, Country, Region, StateorProvince, City, PostalCode, 
OrderDate, ShipDate, Profit, Quantityorderednew, Sales, OrderID, Returned, Manager, ShippedIn(Days), OrderMonth
*/

UPDATE store
SET OrderDate =  str_to_date(OrderDate,'%d-%m-%Y');

Alter table store
MODIFY column OrderDate date;


UPDATE store
SET ShipDate =  str_to_date(ShipDate,'%d-%m-%Y');

Alter table store
MODIFY column ShipDate date;

-- Count of Orders OrderPriority Wise and their Percentage
SELECT 
    OrderPriority,
    COUNT(OrderPriority) AS OrderCount,
    ROUND(COUNT(OrderPriority) / (SELECT 
                    COUNT(*)
                FROM
                    store) * 100,
            2) AS OrderCount_Pct,
    SUM(CASE
        WHEN Returned = 'Returned' THEN 1
        ELSE 0
    END) AS ReturnedCount,
    SUM(CASE
        WHEN Returned = 'Not Returned' THEN 1
        ELSE 0
    END) AS NotReturnedCount
FROM
    store
GROUP BY OrderPriority , Returned
ORDER BY COUNT(OrderPriority) DESC;

--  Distribution of Orders CustomerSegment Wise where Orders have been returned by the customers
SELECT 
    CustomerSegment,
    COUNT(CustomerSegment) AS ReturnedCount,
    ROUND(COUNT(CustomerSegment) / (SELECT 
                    COUNT(*)
                FROM
                    store
                WHERE
                    Returned = 'Returned') * 100,
            2) AS ReturnedPct
FROM
    store
WHERE
    Returned = 'Returned'
GROUP BY CustomerSegment;


-- CustomerSegment and ProductCategory Wise Profit and Cost
SELECT 
    CustomerSegment,
    ProductCategory,
    ROUND(SUM(profit), 2) AS SumProfit,
    ROUND(SUM(ShippingCost), 2) AS sumShippingCost
FROM
    store
GROUP BY CustomerSegment , ProductCategory
ORDER BY sumShippingCost DESC;


-- Month Wise ProductCategory wise profit
SELECT 
    EXTRACT(MONTH FROM orderdate) AS OrderMonth,
    ROUND(SUM(CASE
                WHEN productcategory = 'Office Supplies' THEN profit
                ELSE 0
            END),
            2) AS SuppliesProfit,
    ROUND(SUM(CASE
                WHEN productcategory = 'Furniture' THEN profit
                ELSE 0
            END),
            2) AS FurnitureProfit,
    ROUND(SUM(CASE
                WHEN productcategory = 'Technology' THEN profit
                ELSE 0
            END),
            2) AS TechnologyProfit,
    ROUND(SUM(CASE
                WHEN productcategory <> '' THEN profit
                ELSE 0
            END),
            2) AS TotalProft
FROM
    store
GROUP BY EXTRACT(MONTH FROM orderdate)
ORDER BY OrderMonth ASC;

-- Sum of Sales and Proft Manager and ProductCategoryWise

SELECT 
    Manager,
    ProductCategory,
    ROUND(SUM(sales), 2) AS SumOfSales,
    ROUND(SUM(profit), 2) AS SumOfProfit
FROM
    store
GROUP BY manager , ProductCategory
ORDER BY manager;

-- Date Wise Sales and Profit and a runningprofit
select OrderDate, round(sum(sales),2) as Sales , 
		round(sum(profit),2) as Profit,
        round(SUM(SUM(profit)) OVER (ORDER BY OrderDate),2) AS RunningProfit
from store 
group by orderdate
order by orderdate asc;

-- Region and Maanager Wise Sales and Profit
SELECT 
    Region, manager, SUM(sales), SUM(profit)
FROM
    store
GROUP BY Region , manager
ORDER BY SUM(profit) DESC;

-- Finding out productcategory wise sum of sales and profit where maanager is sam
SELECT 
    ProductCategory,
    ROUND(SUM(sales), 2) AS Sales,
    ROUND(SUM(profit), 2) AS Profit
FROM
    store
WHERE
    Manager = 'Sam'
GROUP BY ProductCategory
ORDER BY ProductCategory ASC;

-- Find out the sales and profit where Sam is manager and Product Category is furniture
select OrderDate, round(sum(sales),2) as Sales , 
		round(sum(profit),2) as Profit,
        round(SUM(SUM(profit)) OVER (ORDER BY OrderDate),2) AS RunningProfit
from store where Manager = 'Sam' and ProductCategory='Furniture'
group by OrderDate
order by OrderDate asc;

-- Find out which ship mode is better or worse for us and in which product category
SELECT 
    ShipMode,
    COUNT(OrderID) AS OrderCount,
    ROUND(SUM(sales), 2) AS SumOfSales,
    ROUND(SUM(shippingcost), 2) AS ShipCost,
    ROUND(SUM(sales) / (SELECT 
                    SUM(sales)
                FROM
                    store) * 100,
            2) AS Pct_Sales,
    ROUND(SUM(CASE
                WHEN productcategory = 'Furniture' THEN profit
                ELSE 0
            END),
            2) AS FurnitureProfit,
    ROUND(SUM(CASE
                WHEN productcategory <> '' THEN profit
                ELSE 0
            END),
            2) AS TotalProft
FROM
    store
GROUP BY ShipMode
ORDER BY TotalProft DESC;


-- Date and Order Priority wise order counts
SELECT
   OrderDate,
    count(case when OrderPriority = 'Low' then orderid end) as LowPriorityOrderCount,
    count(case when OrderPriority = 'Medium' then orderid end) as MediumPriorityOrderCount,
    count(case when OrderPriority = 'High' then orderid end) as HighPriorityOrderCount,
    count(case when OrderPriority = 'Critical' then orderid end) as CriticalPriorityOrderCount,
    count(case when OrderPriority = 'Not Specified' then orderid end) as NotSpecifiedPriorityOrderCount,
    COUNT(orderid) AS OrderCount,
    round(Sum(COUNT(orderid)) OVER (ORDER BY OrderDate),2) AS RunningOrderCount
FROM
    store
GROUP BY
    OrderDate
ORDER BY
    OrderDate;
    
-- Customers and their order frequency (Customer Ordering Behavior)
SELECT
    CustomerName,
    COUNT(DISTINCT MONTH(OrderDate)) AS DistinctMonthsOrdered,
    round(datediff(max(orderdate), min(orderdate))/30) as MonthsOrdered,
    coalesce(round(COUNT(DISTINCT MONTH(OrderDate)) / round(datediff(max(orderdate), min(orderdate))/30),2),0) as AverageOrdersPerMonth,
    round(sum(sales),2) as TotalSales
FROM store 
GROUP BY CustomerName 
having AverageOrdersPerMonth > 0
ORDER BY AverageOrdersPerMonth DESC;

-- Find out which customer likes to buy from which productcategory and look at the customers who have orders worth more than 200$
select CustomerName, group_concat(distinct ProductCategory) as DistinctProdCat,round(sum(sales),2) as SumOfSales
from store
group by customername
having sum(sales) > 100
order by SumOfSales desc
