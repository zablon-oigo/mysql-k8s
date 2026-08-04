CREATE DATABASE IF NOT EXISTS inventory;

USE inventory;

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO products (name, category, price, quantity)
VALUES
('Dell Latitude 7440', 'Laptop', 1200.00, 15),
('Logitech MX Master 3S', 'Mouse', 99.99, 50),
('Samsung 27-inch Monitor', 'Monitor', 289.99, 20);