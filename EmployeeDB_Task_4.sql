	-- Reset the database
	DROP DATABASE IF EXISTS ecommerce_db;
	CREATE DATABASE ecommerce_db;
	USE ecommerce_db;

	-- Create Users Table
	CREATE TABLE Users (
		user_id INT AUTO_INCREMENT PRIMARY KEY,
		name VARCHAR(100) NOT NULL,
		email VARCHAR(100) UNIQUE NOT NULL,
		password VARCHAR(255) NOT NULL,
		created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);

	-- Create Products Table
	CREATE TABLE Products (
		product_id INT AUTO_INCREMENT PRIMARY KEY,
		name VARCHAR(100) NOT NULL,
		description TEXT,
		price DECIMAL(10, 2) NOT NULL,
		stock INT DEFAULT 0
	);

	-- Create Orders Table
	CREATE TABLE Orders (
		order_id INT AUTO_INCREMENT PRIMARY KEY,
		user_id INT,
		order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
		FOREIGN KEY (user_id) REFERENCES Users(user_id)
	);

	-- Create OrderItems Table
	CREATE TABLE OrderItems (
		order_item_id INT AUTO_INCREMENT PRIMARY KEY,
		order_id INT,
		product_id INT,
		quantity INT NOT NULL,
		price DECIMAL(10, 2) NOT NULL,
		FOREIGN KEY (order_id) REFERENCES Orders(order_id),
		FOREIGN KEY (product_id) REFERENCES Products(product_id)
	);

	-- Create Payments Table
	CREATE TABLE Payments (
		payment_id INT AUTO_INCREMENT PRIMARY KEY,
		order_id INT,
		payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		amount DECIMAL(10, 2) NOT NULL,
		method ENUM('Credit Card', 'Debit Card', 'UPI', 'Cash on Delivery') NOT NULL,
		FOREIGN KEY (order_id) REFERENCES Orders(order_id)
	);

	-- INSERT DATA

	-- Insert Users
	INSERT INTO Users (name, email, password) VALUES
	('Aditya Kumar', 'aditya@example.com', 'pass123'),
	('Rohit Mehra', 'rohit@example.com', 'rohit123'),
	('Sana Shaikh', 'sana@example.com', 'sana456');

	-- Insert Products (one product has NULL description)
	INSERT INTO Products (name, description, price, stock) VALUES
	('Laptop', '14-inch slim laptop', 799.99, 10),
	('Wireless Mouse', NULL, 25.00, 50),
	('Keyboard', 'Mechanical RGB keyboard', 45.00, 30);

	-- Insert Orders
	INSERT INTO Orders (user_id, status) VALUES
	(1, 'Pending'),
	(2, 'Shipped'),
	(3, 'Delivered');

	-- Insert OrderItems
	INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
	(1, 1, 1, 799.99),
	(1, 2, 2, 50.00),
	(2, 3, 1, 45.00);

	-- Insert Payments
	INSERT INTO Payments (order_id, amount, method) VALUES
	(1, 849.99, 'Credit Card'),
	(2, 45.00, 'UPI'),
	(3, 45.00, 'Cash on Delivery');

	-- UPDATE STATEMENTS

	-- Change order status to Delivered for order_id = 1
	UPDATE Orders
	SET status = 'Delivered'
	WHERE order_id = 1;

	-- Update password for Rohit Mehra
	UPDATE Users
	SET password = 'newpass456'
	WHERE email = 'rohit@example.com';

	-- Set description to NULL for a product
	UPDATE Products
	SET description = NULL
	WHERE product_id = 3;

	-- DELETE STATEMENTS

	-- Delete a payment made via Cash on Delivery
	DELETE FROM Payments
	WHERE method = 'Cash on Delivery';

	-- Delete a product that has 0 stock (simulate one)
	UPDATE Products SET stock = 0 WHERE product_id = 2;
	DELETE FROM Products
	WHERE stock = 0;

	-- NULL HANDLING

	-- Select all products where description IS NULL
	SELECT * FROM Products
	WHERE description IS NULL;


-- 1. Select all users
SELECT * FROM Users;

-- 2. Select only names and emails of users
SELECT name, email FROM Users;

-- 3. Select all products with price more than 30
SELECT * FROM Products
WHERE price > 30;

-- 4. Select products that are in stock and have NULL descriptions
SELECT * FROM Products
WHERE stock > 0 AND description IS NULL;

-- 5. Select orders that are either 'Pending' or 'Shipped'
SELECT * FROM Orders
WHERE status = 'Pending' OR status = 'Shipped';

-- 6. Select orders placed between two dates (replace with real dates if needed)
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-01-01' AND '2025-12-31';

-- 7. Select all products whose name starts with 'W'
SELECT * FROM Products
WHERE name LIKE 'W%';

-- 8. Select users with email ending in '@example.com'
SELECT * FROM Users
WHERE email LIKE '%@example.com';

-- 9. Select top 2 products with highest price
SELECT * FROM Products
ORDER BY price DESC
LIMIT 2;

-- 10. Select all distinct order statuses
SELECT DISTINCT status FROM Orders;

-- 11. Select order items where quantity is greater than or equal to 2
SELECT * FROM OrderItems
WHERE quantity >= 2;

-- 12. Select all orders sorted by latest order date first
SELECT * FROM Orders
ORDER BY order_date DESC;

-- 13. Select payments where method is not 'Cash on Delivery'
SELECT * FROM Payments
WHERE method != 'Cash on Delivery';

-- 14. Select names of users who placed an order (inner join with Orders)
SELECT DISTINCT u.name
FROM Users u
JOIN Orders o ON u.user_id = o.user_id;

-- 15. Select total amount paid per order (GROUP BY)
SELECT order_id, SUM(amount) AS total_paid
FROM Payments
GROUP BY order_id;

-- 1. Count total number of users
SELECT COUNT(*) AS total_users FROM Users;

-- 2. Total number of products with NULL description
SELECT COUNT(*) AS null_description_products
FROM Products
WHERE description IS NULL;

-- 3. Total number of orders per user
SELECT user_id, COUNT(*) AS total_orders
FROM Orders
GROUP BY user_id;

-- 4. Total quantity ordered per product
SELECT product_id, SUM(quantity) AS total_quantity
FROM OrderItems
GROUP BY product_id;

-- 5. Average price of all products
SELECT AVG(price) AS average_product_price FROM Products;

-- 6. Total sales per order
SELECT order_id, SUM(price * quantity) AS total_order_amount
FROM OrderItems
GROUP BY order_id;

-- 7. Total payment amount per payment method
SELECT method, SUM(amount) AS total_paid
FROM Payments
GROUP BY method;

-- 8. Orders with more than 1 item (using HAVING)
SELECT order_id, COUNT(*) AS item_count
FROM OrderItems
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 9. Count of distinct products ordered
SELECT COUNT(DISTINCT product_id) AS unique_products_sold
FROM OrderItems;

-- 10. Round the average price to 2 decimals
SELECT ROUND(AVG(price), 2) AS rounded_avg_price
FROM Products;

