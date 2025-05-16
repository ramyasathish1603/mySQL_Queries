
-- Create the database
CREATE DATABASE ecommerce;
USE ecommerce;

-- Create customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(100)
);

-- Create products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert sample customers
INSERT INTO customers (name, email, address) VALUES
('Arundhati Roy', 'arundhati@example.com', '123 Gandhi St'),
('Salman Rushdie', 'salman@example.com', '456 Anna Rd'),
('Amrita Pritam', 'amrita@example.com', '789 Kamraj St');

-- Insert sample products
INSERT INTO products (name, price, description) VALUES
('Product A', 30.00, 'Description A'),
('Product B', 60.00, 'Description B'),
('Product C', 40.00, 'Description C'),
('Product D', 90.00, 'Description D');

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, CURDATE() - INTERVAL 10 DAY, 120.00),
(2, CURDATE() - INTERVAL 35 DAY, 200.00),
(1, CURDATE() - INTERVAL 5 DAY, 75.00),
(3, CURDATE() - INTERVAL 3 DAY, 160.00);

-- Update Product C's price
UPDATE products SET price = 45.00 WHERE name = 'Product C';

-- Add discount column to products
ALTER TABLE products ADD COLUMN discount DECIMAL(5,2) DEFAULT 0.00;

-- Create order_items table for normalization
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert sample order_items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 30.00),
(1, 3, 1, 45.00),
(2, 2, 2, 60.00),
(3, 4, 1, 90.00),
(4, 1, 1, 30.00);

-- Queries

-- Customers who placed orders in last 30 days
SELECT DISTINCT c.*
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;

-- Total amount of all orders per customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id;

-- Top 3 most expensive products
SELECT * FROM products
ORDER BY price DESC
LIMIT 3;

-- Customers who ordered Product A
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- Customer name and order date for each order
SELECT c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- Orders with total amount > 150.00
SELECT * FROM orders
WHERE total_amount > 150.00;

-- Average total of all orders
SELECT AVG(total_amount) AS average_order_total
FROM orders;