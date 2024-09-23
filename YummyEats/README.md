# YummyEats Data Insights

## Overview
This report provides key insights into YummyEats' order data using SQL queries. The dataset includes information on orders, customers, restaurants, cuisine types, and associated metrics such as order cost, preparation time, delivery time, takeaways, and ratings.

![image}(https://assets.cntraveller.in/photos/6517a5aa2f98f695fe4e5cdc/16:9/w_1024%2Cc_limit/GIGI%2520001.jpg)

### Key Metrics
1. **Average Order Metrics**:
   - **Average Cost**: Calculates the average cost of the orders.
   - **Average Food Preparation Time**: Determines the average time restaurants take to prepare food.
   - **Average Delivery Time**: Measures the average delivery duration for all orders.

2. **Takeaway vs. Dine-in**:
   - Determines whether there are more takeaway or dine-in orders.
   - Breaks down the percentage of takeaway and dine-in orders across the dataset.

3. **Ratings Distribution**:
   - Analyzes the distribution of customer ratings.
   - Provides the percentage of orders that fall under each rating category.

4. **Cuisine Types with Missing Ratings**:
   - Highlights the top 5 cuisine types where customer ratings are not provided.
   - Calculates the percentage of missing ratings for each cuisine type.

5. **Restaurants with Missing Ratings**:
   - Identifies the top 5 restaurants where ratings were not given.
   - Displays the percentage of unrated orders per restaurant.

6. **Takeaway and Dine-in Orders by Day**:
   - Breaks down the number of takeaway and dine-in orders by day of the week.
   - Helps identify customer behavior patterns on weekends vs. weekdays.

7. **Restaurant Order Types**:
   - Tracks the number of takeaway and dine-in orders for each restaurant.
   - Shows the percentage of total orders each restaurant contributes to overall activity.

8. **Restaurant Performance Metrics**:
   - **Average Food Preparation Time**: Shows how long it takes each restaurant to prepare orders on average.
   - **Average Delivery Time**: Measures the average time restaurants take to deliver food.
   - **Average Cost of the Order**: Ranks restaurants by average order cost, sorted in descending order.

9. **Slowest Restaurants**:
   - Identifies restaurants that take more than 30 minutes on average to prepare food.
   - Orders results by preparation time in descending order, showcasing the slowest performers.

10. **Cuisine Type Preparation Time**:
    - Analyzes the average preparation time for each cuisine type.
    - Highlights which cuisine takes the longest to prepare.

## Usage
The SQL queries can be used to extract insights directly from the `yummyeats` table. These insights are valuable for decision-makers looking to:
- Optimize delivery operations.
- Improve restaurant performance.
- Understand customer satisfaction trends (e.g., based on ratings and order types).
- Identify the efficiency of different cuisine preparations.

The results can further help to:
- Highlight potential bottlenecks in food preparation.
- Provide targeted feedback to restaurants with slower service times.
- Refine takeaway and delivery strategies based on customer behavior throughout the week.
