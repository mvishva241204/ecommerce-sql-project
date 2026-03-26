1. Total Orders per Customer

SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

2. Top Customers by Spending

SELECT c.customer_id, c.name,
SUM(oi.quantity * oi.price) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

3. Most Sold Products

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

4. Monthly Revenue

SELECT DATE_FORMAT(o.order_date,'%Y-%m') AS month,
SUM(oi.quantity * oi.price) AS revenue
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY month;

5. Customers with No Orders

SELECT c.customer_id, c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

6. Repeat Customers (>2 orders)

SELECT customer_id, COUNT(*) AS total_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(*) > 2;

7. Customer Lifetime Value (CLV)

SELECT o.customer_id,
SUM(oi.quantity * oi.price) AS clv
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id;

8. Top 3 Products per Category

SELECT *
FROM (
    SELECT p.category, p.product_name,
    SUM(oi.quantity) AS total_sold,
    ROW_NUMBER() OVER (
        PARTITION BY p.category 
        ORDER BY SUM(oi.quantity) DESC
    ) AS rn
    FROM Products p
    JOIN Order_Items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
) t
WHERE rn <= 3;

9. Highest Order per Month

SELECT *
FROM (
    SELECT o.order_id,
    DATE_FORMAT(o.order_date,'%Y-%m') AS month,
    SUM(oi.quantity * oi.price) AS value,
    RANK() OVER (
        PARTITION BY DATE_FORMAT(o.order_date,'%Y-%m')
        ORDER BY SUM(oi.quantity * oi.price) DESC
    ) rnk
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, month
) t
WHERE rnk = 1;

10. Co-purchased Products

SELECT oi1.product_id, oi2.product_id, COUNT(*) freq
FROM Order_Items oi1
JOIN Order_Items oi2
ON oi1.order_id = oi2.order_id
AND oi1.product_id < oi2.product_id
GROUP BY oi1.product_id, oi2.product_id;

11. Churned Customers

SELECT customer_id
FROM Orders
GROUP BY customer_id
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

12. RFM Analysis

SELECT o.customer_id,
DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency,
COUNT(o.order_id) AS frequency,
SUM(oi.quantity * oi.price) AS monetary
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id;

13. Running Revenue

SELECT order_date,
SUM(daily_revenue) OVER (ORDER BY order_date) AS running_total
FROM (
    SELECT o.order_date,
    SUM(oi.quantity * oi.price) AS daily_revenue
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    GROUP BY o.order_date
) t;

14. Predict Next Purchase Date

SELECT customer_id,
DATE_ADD(MAX(order_date), INTERVAL AVG(days_between) DAY) AS next_order
FROM (
    SELECT customer_id, order_date,
    DATEDIFF(order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id ORDER BY order_date
        )
    ) AS days_between
    FROM Orders
) t
GROUP BY customer_id;