CREATE DATABASE smart_inventory_supply_chain;
USE smart_inventory_supply_chain;
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(255),
    city VARCHAR(100),
    contact_email VARCHAR(255),
    rating DECIMAL(2,1)
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    unit_price DECIMAL(10,2),
    supplier_id INT,
    
    FOREIGN KEY (supplier_id)
    REFERENCES Suppliers(supplier_id)
);
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(255),
    city VARCHAR(100),
    capacity INT
);
CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    warehouse_id INT,
    stock_quantity INT,
    reorder_level INT,

    FOREIGN KEY (product_id)
    REFERENCES Products(product_id),

    FOREIGN KEY (warehouse_id)
    REFERENCES Warehouses(warehouse_id)
);
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    city VARCHAR(100),
    segment VARCHAR(100)
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    shipment_status VARCHAR(100),

    FOREIGN KEY (customer_id)
    REFERENCES Customers(customer_id)
);
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    total_price DECIMAL(10,2),

    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
    REFERENCES Products(product_id)
);
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    order_id INT,
    warehouse_id INT,
    shipped_date DATE,
    delivery_date DATE,

    FOREIGN KEY (order_id)
    REFERENCES Orders(order_id),

    FOREIGN KEY (warehouse_id)
    REFERENCES Warehouses(warehouse_id)
);
SHOW TABLES;
DESC Products;
select * from suppliers limit 10;
select * from warehouses limit 10;
select * from customers limit 10;
SELECT p.product_name,
       s.supplier_name
FROM Products p
JOIN Suppliers s
ON p.supplier_id = s.supplier_id
LIMIT 10;
-- ============================================
-- SMART INVENTORY & SUPPLY CHAIN SQL PROJECT
-- STEP 3 - BASIC SQL QUERIES
-- ============================================

USE smart_inventory_supply_chain;

-- ============================================
-- 1. VIEW ALL PRODUCTS
-- ============================================

SELECT * 
FROM Products;

-- ============================================
-- 2. VIEW PRODUCT NAME AND PRICE
-- ============================================

SELECT product_name,
       unit_price
FROM Products;

-- ============================================
-- 3. PRODUCTS ABOVE 500 PRICE
-- ============================================

SELECT *
FROM Products
WHERE unit_price > 500;

-- ============================================
-- 4. DELIVERED ORDERS
-- ============================================

SELECT *
FROM Orders
WHERE shipment_status = 'Delivered';

-- ============================================
-- 5. HIGHEST PRICE PRODUCTS
-- ============================================

SELECT product_name,
       unit_price
FROM Products
ORDER BY unit_price DESC;

-- ============================================
-- 6. LOWEST STOCK PRODUCTS
-- ============================================

SELECT *
FROM Inventory
ORDER BY stock_quantity ASC;

-- ============================================
-- 7. TOP 5 EXPENSIVE PRODUCTS
-- ============================================

SELECT *
FROM Products
ORDER BY unit_price DESC
LIMIT 5;

-- ============================================
-- 8. TOTAL NUMBER OF PRODUCTS
-- ============================================

SELECT COUNT(*) AS total_products
FROM Products;

-- ============================================
-- 9. AVERAGE PRODUCT PRICE
-- ============================================

SELECT AVG(unit_price) AS average_price
FROM Products;

-- ============================================
-- 10. MAXIMUM PRODUCT PRICE
-- ============================================

SELECT MAX(unit_price) AS max_price
FROM Products;

-- ============================================
-- 11. MINIMUM PRODUCT PRICE
-- ============================================

SELECT MIN(unit_price) AS min_price
FROM Products;

-- ============================================
-- 12. PRODUCTS PER CATEGORY
-- ============================================

SELECT category,
       COUNT(*) AS total_products
FROM Products
GROUP BY category;

-- ============================================
-- 13. TOTAL REVENUE PER PRODUCT
-- ============================================

SELECT product_id,
       SUM(total_price) AS revenue
FROM Order_Items
GROUP BY product_id;

-- ============================================
-- 14. CATEGORIES WITH MORE THAN 90 PRODUCTS
-- ============================================

SELECT category,
       COUNT(*) AS total_products
FROM Products
GROUP BY category
HAVING COUNT(*) > 90;

-- ============================================
-- 15. UNIQUE SHIPMENT STATUS
-- ============================================

SELECT DISTINCT shipment_status
FROM Orders;

-- ============================================
-- 16. ORDERS BETWEEN DATE RANGE
-- ============================================

SELECT *
FROM Orders
WHERE order_date BETWEEN '2025-01-01'
AND '2025-06-30';

-- ============================================
-- 17. PRODUCTS STARTING WITH Product_1
-- ============================================

SELECT *
FROM Products
WHERE product_name LIKE 'Product_1%';

-- ============================================
-- 18. ORDERS WITH DELIVERED OR SHIPPED STATUS
-- ============================================

SELECT *
FROM Orders
WHERE shipment_status IN ('Delivered', 'Shipped');

-- ============================================
-- 19. PRODUCTS UNDER 100
-- ============================================

SELECT *
FROM Products
WHERE unit_price < 100;

-- ============================================
-- 20. TOP 10 LOWEST STOCK PRODUCTS
-- ============================================

SELECT *
FROM Inventory
ORDER BY stock_quantity ASC
LIMIT 10;

-- ============================================
-- 21. TOTAL CUSTOMERS
-- ============================================

SELECT COUNT(*) AS total_customers
FROM Customers;

-- ============================================
-- 22. AVERAGE STOCK QUANTITY
-- ============================================

SELECT AVG(stock_quantity) AS avg_stock
FROM Inventory;

-- ============================================
-- 23. CATEGORIES WITH AVG PRICE > 400
-- ============================================

SELECT category,
       AVG(unit_price) AS avg_price
FROM Products
GROUP BY category
HAVING AVG(unit_price) > 400;
-- ============================================
-- STEP 4 - SQL JOINS
-- SMART INVENTORY & SUPPLY CHAIN PROJECT
-- ============================================

USE smart_inventory_supply_chain;

-- ============================================
-- 1. INNER JOIN
-- PRODUCTS WITH SUPPLIER NAMES
-- ============================================

SELECT p.product_id,
       p.product_name,
       p.category,
       p.unit_price,
       s.supplier_name,
       s.city
FROM Products p
INNER JOIN Suppliers s
ON p.supplier_id = s.supplier_id;

-- ============================================
-- 2. PRODUCTS WITH WAREHOUSE STOCK
-- ============================================

SELECT p.product_name,
       w.warehouse_name,
       i.stock_quantity
FROM Inventory i
INNER JOIN Products p
ON i.product_id = p.product_id
INNER JOIN Warehouses w
ON i.warehouse_id = w.warehouse_id;

-- ============================================
-- 3. CUSTOMER ORDERS
-- ============================================

SELECT o.order_id,
       c.customer_name,
       c.segment,
       o.order_date,
       o.shipment_status
FROM Orders o
INNER JOIN Customers c
ON o.customer_id = c.customer_id;

-- ============================================
-- 4. ORDER DETAILS WITH PRODUCT INFO
-- ============================================

SELECT oi.order_item_id,
       oi.order_id,
       p.product_name,
       oi.quantity,
       oi.total_price
FROM Order_Items oi
INNER JOIN Products p
ON oi.product_id = p.product_id;

-- ============================================
-- 5. COMPLETE SALES REPORT
-- ============================================

SELECT o.order_id,
       c.customer_name,
       p.product_name,
       oi.quantity,
       oi.total_price,
       o.order_date
FROM Orders o
INNER JOIN Customers c
ON o.customer_id = c.customer_id
INNER JOIN Order_Items oi
ON o.order_id = oi.order_id
INNER JOIN Products p
ON oi.product_id = p.product_id;

-- ============================================
-- 6. SHIPMENT DETAILS
-- ============================================

SELECT s.shipment_id,
       o.order_id,
       w.warehouse_name,
       s.shipped_date,
       s.delivery_date
FROM Shipments s
INNER JOIN Orders o
ON s.order_id = o.order_id
INNER JOIN Warehouses w
ON s.warehouse_id = w.warehouse_id;

-- ============================================
-- 7. LOW STOCK PRODUCTS
-- ============================================

SELECT p.product_name,
       i.stock_quantity,
       i.reorder_level,
       w.warehouse_name
FROM Inventory i
INNER JOIN Products p
ON i.product_id = p.product_id
INNER JOIN Warehouses w
ON i.warehouse_id = w.warehouse_id
WHERE i.stock_quantity < i.reorder_level;

-- ============================================
-- 8. TOP SELLING PRODUCTS
-- ============================================

SELECT p.product_name,
       SUM(oi.quantity) AS total_quantity_sold,
       SUM(oi.total_price) AS total_revenue
FROM Order_Items oi
INNER JOIN Products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================
-- 9. TOTAL SALES BY CUSTOMER
-- ============================================

SELECT c.customer_name,
       SUM(oi.total_price) AS total_spending
FROM Customers c
INNER JOIN Orders o
ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY total_spending DESC;

-- ============================================
-- 10. SUPPLIER PERFORMANCE
-- ============================================

SELECT s.supplier_name,
       COUNT(p.product_id) AS total_products
FROM Suppliers s
INNER JOIN Products p
ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY total_products DESC;

-- ============================================
-- 11. WAREHOUSE UTILIZATION
-- ============================================

SELECT w.warehouse_name,
       SUM(i.stock_quantity) AS total_stock
FROM Warehouses w
INNER JOIN Inventory i
ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_name
ORDER BY total_stock DESC;

-- ============================================
-- 12. DELAYED SHIPMENTS
-- ============================================

SELECT shipment_id,
       order_id,
       shipped_date,
       delivery_date,
       DATEDIFF(delivery_date, shipped_date) AS delivery_days
FROM Shipments
WHERE DATEDIFF(delivery_date, shipped_date) > 7;

-- ============================================
-- 13. MONTHLY SALES REPORT
-- ============================================

SELECT MONTH(o.order_date) AS month_number,
       SUM(oi.total_price) AS monthly_sales
FROM Orders o
INNER JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY MONTH(o.order_date)
ORDER BY month_number;

-- ============================================
-- 14. CATEGORY WISE REVENUE
-- ============================================

SELECT p.category,
       SUM(oi.total_price) AS category_revenue
FROM Products p
INNER JOIN Order_Items oi
ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- ============================================
-- 15. CUSTOMER SEGMENT ANALYSIS
-- ============================================

SELECT c.segment,
       COUNT(DISTINCT c.customer_id) AS total_customers,
       SUM(oi.total_price) AS total_revenue
FROM Customers c
INNER JOIN Orders o
ON c.customer_id = o.customer_id
INNER JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY c.segment;
-- ============================================
-- STEP 5 - ADVANCED SQL
-- SMART INVENTORY & SUPPLY CHAIN PROJECT
-- ============================================

USE smart_inventory_supply_chain;

-- ============================================
-- 1. SUBQUERY
-- PRODUCTS ABOVE AVERAGE PRICE
-- ============================================

SELECT product_name,
       unit_price
FROM Products
WHERE unit_price >
(
    SELECT AVG(unit_price)
    FROM Products
);

-- ============================================
-- 2. SUBQUERY
-- CUSTOMERS WITH HIGH SPENDING
-- ============================================

SELECT customer_id,
       total_spending
FROM
(
    SELECT o.customer_id,
           SUM(oi.total_price) AS total_spending
    FROM Orders o
    JOIN Order_Items oi
    ON o.order_id = oi.order_id
    GROUP BY o.customer_id
) AS customer_sales
WHERE total_spending > 50000;

-- ============================================
-- 3. EXISTS
-- CUSTOMERS WHO PLACED ORDERS
-- ============================================

SELECT customer_name
FROM Customers c
WHERE EXISTS
(
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
);

-- ============================================
-- 4. CTE
-- MONTHLY SALES ANALYSIS
-- ============================================

WITH MonthlySales AS
(
    SELECT MONTH(o.order_date) AS month_number,
           SUM(oi.total_price) AS total_sales
    FROM Orders o
    JOIN Order_Items oi
    ON o.order_id = oi.order_id
    GROUP BY MONTH(o.order_date)
)

SELECT *
FROM MonthlySales
ORDER BY total_sales DESC;

-- ============================================
-- 5. CTE
-- LOW STOCK PRODUCTS
-- ============================================

WITH LowStock AS
(
    SELECT p.product_name,
           i.stock_quantity,
           i.reorder_level
    FROM Inventory i
    JOIN Products p
    ON i.product_id = p.product_id
    WHERE i.stock_quantity < i.reorder_level
)

SELECT *
FROM LowStock;

-- ============================================
-- 6. WINDOW FUNCTION
-- RANK PRODUCTS BY REVENUE
-- ============================================

SELECT p.product_name,
       SUM(oi.total_price) AS revenue,

       RANK() OVER
       (
           ORDER BY SUM(oi.total_price) DESC
       ) AS revenue_rank

FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id

GROUP BY p.product_name;

-- ============================================
-- 7. DENSE RANK
-- ============================================

SELECT p.product_name,
       SUM(oi.total_price) AS revenue,

       DENSE_RANK() OVER
       (
           ORDER BY SUM(oi.total_price) DESC
       ) AS dense_rank_value

FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id

GROUP BY p.product_name;

-- ============================================
-- 8. ROW NUMBER
-- ============================================

SELECT p.product_name,
       SUM(oi.total_price) AS revenue,

       ROW_NUMBER() OVER
       (
           ORDER BY SUM(oi.total_price) DESC
       ) AS row_num

FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id

GROUP BY p.product_name;

-- ============================================
-- 9. RUNNING TOTAL SALES
-- ============================================

SELECT o.order_date,

       SUM(oi.total_price) AS daily_sales,

       SUM(SUM(oi.total_price))
       OVER
       (
           ORDER BY o.order_date
       ) AS running_total

FROM Orders o
JOIN Order_Items oi
ON o.order_id = oi.order_id

GROUP BY o.order_date
ORDER BY o.order_date;

-- ============================================
-- 10. LEAD FUNCTION
-- NEXT MONTH SALES
-- ============================================

WITH MonthlyRevenue AS
(
    SELECT MONTH(o.order_date) AS month_number,
           SUM(oi.total_price) AS sales
    FROM Orders o
    JOIN Order_Items oi
    ON o.order_id = oi.order_id
    GROUP BY MONTH(o.order_date)
)

SELECT month_number,
       sales,

       LEAD(sales)
       OVER
       (
           ORDER BY month_number
       ) AS next_month_sales

FROM MonthlyRevenue;

-- ============================================
-- 11. LAG FUNCTION
-- PREVIOUS MONTH SALES
-- ============================================

WITH MonthlyRevenue AS
(
    SELECT MONTH(o.order_date) AS month_number,
           SUM(oi.total_price) AS sales
    FROM Orders o
    JOIN Order_Items oi
    ON o.order_id = oi.order_id
    GROUP BY MONTH(o.order_date)
)

SELECT month_number,
       sales,

       LAG(sales)
       OVER
       (
           ORDER BY month_number
       ) AS previous_month_sales

FROM MonthlyRevenue;

-- ============================================
-- 12. CREATE VIEW
-- SALES SUMMARY VIEW
-- ============================================

CREATE VIEW Sales_Summary AS

SELECT o.order_id,
       c.customer_name,
       p.product_name,
       oi.quantity,
       oi.total_price,
       o.order_date

FROM Orders o
JOIN Customers c
ON o.customer_id = c.customer_id

JOIN Order_Items oi
ON o.order_id = oi.order_id

JOIN Products p
ON oi.product_id = p.product_id;

-- ============================================
-- 13. USE VIEW
-- ============================================

SELECT *
FROM Sales_Summary
LIMIT 20;

-- ============================================
-- 14. CREATE VIEW
-- LOW STOCK ALERT VIEW
-- ============================================

CREATE VIEW Low_Stock_Alert AS

SELECT p.product_name,
       w.warehouse_name,
       i.stock_quantity,
       i.reorder_level

FROM Inventory i
JOIN Products p
ON i.product_id = p.product_id

JOIN Warehouses w
ON i.warehouse_id = w.warehouse_id

WHERE i.stock_quantity < i.reorder_level;

-- ============================================
-- 15. USE VIEW
-- ============================================

SELECT *
FROM Low_Stock_Alert;

-- ============================================
-- STEP 6 - STORED PROCEDURES, TRIGGERS,
-- INDEXES & OPTIMIZATION
-- SMART INVENTORY & SUPPLY CHAIN PROJECT
-- ============================================

USE smart_inventory_supply_chain;

-- ============================================
-- 1. STORED PROCEDURE
-- MONTHLY SALES REPORT
-- ============================================

DELIMITER $$

CREATE PROCEDURE Monthly_Sales_Report()

BEGIN

    SELECT MONTH(o.order_date) AS month_number,
           SUM(oi.total_price) AS total_sales

    FROM Orders o
    JOIN Order_Items oi
    ON o.order_id = oi.order_id

    GROUP BY MONTH(o.order_date)
    ORDER BY month_number;

END $$

DELIMITER ;

-- EXECUTE PROCEDURE

CALL Monthly_Sales_Report();

-- ============================================
-- 2. STORED PROCEDURE
-- CUSTOMER PURCHASE HISTORY
-- ============================================

DELIMITER $$

CREATE PROCEDURE Customer_Purchase_History
(
    IN customer_input INT
)

BEGIN

    SELECT c.customer_name,
           o.order_id,
           o.order_date,
           p.product_name,
           oi.quantity,
           oi.total_price

    FROM Customers c
    JOIN Orders o
    ON c.customer_id = o.customer_id

    JOIN Order_Items oi
    ON o.order_id = oi.order_id

    JOIN Products p
    ON oi.product_id = p.product_id

    WHERE c.customer_id = customer_input;

END $$

DELIMITER ;

-- EXECUTE PROCEDURE

CALL Customer_Purchase_History(10);

-- ============================================
-- 3. STORED PROCEDURE
-- LOW STOCK PRODUCTS
-- ============================================

DELIMITER $$

CREATE PROCEDURE Low_Stock_Report()

BEGIN

    SELECT p.product_name,
           i.stock_quantity,
           i.reorder_level,
           w.warehouse_name

    FROM Inventory i
    JOIN Products p
    ON i.product_id = p.product_id

    JOIN Warehouses w
    ON i.warehouse_id = w.warehouse_id

    WHERE i.stock_quantity < i.reorder_level;

END $$

DELIMITER ;

-- EXECUTE PROCEDURE

CALL Low_Stock_Report();

-- ============================================
-- 4. TRIGGER
-- AUTO REDUCE INVENTORY AFTER ORDER
-- ============================================

DELIMITER $$

CREATE TRIGGER Reduce_Inventory_After_Order

AFTER INSERT ON Order_Items

FOR EACH ROW

BEGIN

    UPDATE Inventory

    SET stock_quantity = stock_quantity - NEW.quantity

    WHERE product_id = NEW.product_id

    LIMIT 1;

END $$

DELIMITER ;

-- ============================================
-- 5. TEST TRIGGER
-- ============================================

INSERT INTO Order_Items
(
    order_item_id,
    order_id,
    product_id,
    quantity,
    total_price
)

VALUES
(
    20001,
    1,
    10,
    2,
    1000
);

-- CHECK INVENTORY

SELECT *
FROM Inventory
WHERE product_id = 10;

-- ============================================
-- 6. INDEX CREATION
-- IMPROVE QUERY PERFORMANCE
-- ============================================

CREATE INDEX idx_product_name
ON Products(product_name);

CREATE INDEX idx_order_date
ON Orders(order_date);

CREATE INDEX idx_customer_id
ON Orders(customer_id);

CREATE INDEX idx_product_id
ON Order_Items(product_id);

-- ============================================
-- 7. CHECK INDEXES
-- ============================================

SHOW INDEXES FROM Products;

SHOW INDEXES FROM Orders;

-- ============================================
-- 8. EXPLAIN QUERY
-- QUERY OPTIMIZATION
-- ============================================

EXPLAIN

SELECT p.product_name,
       SUM(oi.total_price) AS revenue

FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id

GROUP BY p.product_name;

-- ============================================
-- 9. TRANSACTION
-- ============================================

START TRANSACTION;

UPDATE Inventory
SET stock_quantity = stock_quantity - 5
WHERE product_id = 1;

UPDATE Inventory
SET stock_quantity = stock_quantity + 5
WHERE product_id = 2;

COMMIT;

-- ============================================
-- 10. ROLLBACK EXAMPLE
-- ============================================

START TRANSACTION;

UPDATE Inventory
SET stock_quantity = stock_quantity - 100
WHERE product_id = 5;

ROLLBACK;

-- ============================================
-- 11. CREATE USER ROLE REPORT
-- ============================================

SELECT c.customer_name,
       COUNT(o.order_id) AS total_orders,
       SUM(oi.total_price) AS total_spending

FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id

JOIN Order_Items oi
ON o.order_id = oi.order_id

GROUP BY c.customer_name
ORDER BY total_spending DESC;

-- ============================================
-- 12. TOP 10 REVENUE PRODUCTS
-- ============================================

SELECT p.product_name,
       SUM(oi.total_price) AS revenue

FROM Products p
JOIN Order_Items oi
ON p.product_id = oi.product_id

GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- ============================================
-- 13. DELIVERY PERFORMANCE REPORT
-- ============================================

SELECT shipment_id,
       order_id,
       DATEDIFF(delivery_date, shipped_date) AS delivery_days

FROM Shipments
ORDER BY delivery_days DESC;
