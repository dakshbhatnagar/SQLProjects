-- use imports;

/* COLUMNS
-- order_id, customer_id, restaurant_name, cuisine_type, cost_of_the_order, 
day_of_the_week, food_preparation_time, delivery_time, is_takeaway, distance, GST, rating\
*/

-- What is the avg cost, food_preparation_time, delivery_time of order

SELECT 
    ROUND(AVG(cost_of_the_order), 2) AS avg_cost,
    ROUND(AVG(food_preparation_time), 2) AS avg_food_preparation_time,
    ROUND(AVG(delivery_time), 2) AS avg_delivery_time
FROM
    yummyeats;

# Do we have more takeways or not?
SELECT
    is_takeaway,
    COUNT(is_takeaway) AS count_takeaway,
    ROUND(COUNT(is_takeaway) / (SELECT COUNT(*) FROM yummyeats) * 100, 2) AS Pct
FROM
    yummyeats
GROUP BY
    is_takeaway;

# Ratings and their distribution??
SELECT 
    rating,
    COUNT(rating) AS CountRating,
    ROUND(COUNT(rating) / (SELECT 
                    COUNT(*)
                FROM
                    yummyeats) * 100,
            2) AS Pct_rating
FROM
    yummyeats
GROUP BY rating
ORDER BY rating;

# Top 5 Cuisine Type where Rating is not given

SELECT 
    cuisine_type,
    COUNT(cuisine_type) AS Countcuisine_type,
    ROUND(COUNT(cuisine_type) / (SELECT 
                    COUNT(*)
                FROM
                    yummyeats) * 100,
            2) AS Pct_cuisine_type
FROM
    yummyeats
WHERE
    rating = 'Not Given'
GROUP BY cuisine_type
ORDER BY Pct_cuisine_type DESC
LIMIT 5;

# Top 5 restaurant_name where Rating is not given
SELECT 
    restaurant_name,
    COUNT(restaurant_name) AS Countrestaurant_name,
    ROUND(COUNT(restaurant_name) / (SELECT 
                    COUNT(*)
                FROM
                    yummyeats) * 100,
            2) AS Pct_restaurant_name
FROM
    yummyeats
WHERE
    rating = 'Not Given'
GROUP BY restaurant_name
ORDER BY Pct_restaurant_name DESC
LIMIT 5;

# How many takeaway orders and dine orders we get over the weekends and weekdays?
SELECT
    day_of_the_week,
    SUM(CASE WHEN is_takeaway = 'TRUE' THEN 1 ELSE 0 END) AS TakeawayOrder,
    SUM(CASE WHEN is_takeaway = 'FALSE' THEN 1 ELSE 0 END) AS DineInOrder,
    COUNT(is_takeaway) AS total_orders
FROM
    yummyeats
GROUP BY
    day_of_the_week;

#Which restaurant has taken which order 
SELECT 
    restaurant_name,
    SUM(CASE
        WHEN is_takeaway = 'TRUE' THEN 1
        ELSE 0
    END) AS TakeawayOrder,
    SUM(CASE
        WHEN is_takeaway = 'FALSE' THEN 1
        ELSE 0
    END) AS DineInOrder,
    SUM(CASE
        WHEN is_takeaway <> '' THEN 1
        ELSE 0
    END) AS TotalOrders,
    ROUND(SUM(CASE
                WHEN is_takeaway <> '' THEN 1
                ELSE 0
            END) / (SELECT 
                    COUNT(*)
                FROM
                    yummyeats) * 100,
            4) AS TotalOrders_pct
FROM
    yummyeats
GROUP BY restaurant_name
ORDER BY totalorders DESC;

#Find out Each restaurant's Avg_food_prepation_time, avg_delivery_time, avg_cost_of_the_order and order by avg cost in descending order
SELECT 
    restaurant_name,
    ROUND(AVG(food_preparation_time), 2) AS AvgePrepTime,
    ROUND(AVG(delivery_time), 2) AS AvgDeliveryTime,
    ROUND(AVG(cost_of_the_order), 2) AS AvgCostOfOrder
FROM
    yummyeats
GROUP BY restaurant_name
ORDER BY AvgCostOfOrder DESC;

#Find out the restaurant name that take more than half an hour for preparation on an avg. Sort the results in descending order
SELECT 
    restaurant_name,
    ROUND(AVG(food_preparation_time), 2) AS AvgPrepTime
FROM
    yummyeats
GROUP BY restaurant_name
HAVING ROUND(AVG(food_preparation_time), 2) >= 30
ORDER BY AVG(food_preparation_time) DESC;

#How much time on an avge goes in preparation of each cuisine type
SELECT 
    cuisine_type,
    ROUND(AVG(food_preparation_time), 2) AS AvgPrepTime
FROM
    yummyeats
GROUP BY cuisine_type
ORDER BY AVG(food_preparation_time) DESC
