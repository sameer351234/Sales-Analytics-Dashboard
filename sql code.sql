CREATE TABLE products (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(255),
    aisle_id VARCHAR(255),
    department_id VARCHAR(50),
    price NUMERIC(10,2)
);
select * from products;

SELECT product_id FROM products LIMIT 5;
select product_id from orders_sales_data limit 5;
drop table products;
drop table orders_sales_data;


CREATE TABLE sales (
    order_id     BIGINT,
    order_date   DATE,
    customer_id  VARCHAR(10),
    product_id   BIGINT,
    quantity     INTEGER,
    sales_amount NUMERIC(12,2),
    profit       NUMERIC(12,2),
    region       VARCHAR(20)
);

select count(*) from sales;

SELECT * FROM sales LIMIT 5;


SELECT COUNT(*) FROM products;
SELECT * FROM products LIMIT 5;


SELECT COUNT(*) AS unmatched_products
FROM sales s
LEFT JOIN products p
ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

ALTER TABLE products
ALTER COLUMN product_id TYPE BIGINT
USING product_id::BIGINT;


SELECT
    s.order_id,
    p.product_name,
    s.quantity,
    s.sales_amount,
    s.profit,
    s.region
FROM sales s
JOIN products p
ON s.product_id = p.product_id
LIMIT 10;


ALTER TABLE sales
ADD CONSTRAINT fk_sp
FOREIGN KEY (product_id)
REFERENCES products(product_id);


CREATE TABLE dim_date (
    date_id      DATE PRIMARY KEY,
    year          INT,
    quarter       INT,
    month         INT,
    month_name    VARCHAR(15),
    day           INT,
    day_name      VARCHAR(15)
);

INSERT INTO dim_date
SELECT DISTINCT
    order_date,
    EXTRACT(YEAR FROM order_date),
    EXTRACT(QUARTER FROM order_date),
    EXTRACT(MONTH FROM order_date),
    TO_CHAR(order_date, 'Month'),
    EXTRACT(DAY FROM order_date),
    TO_CHAR(order_date, 'Day')
FROM sales;

SELECT * FROM dim_date LIMIT 5;


ALTER TABLE sales
ADD CONSTRAINT fk_sales_date
FOREIGN KEY (order_date)
REFERENCES dim_date(date_id);


SELECT
    SUM(sales_amount) AS total_sales,
    SUM(profit) AS total_profit
FROM sales;

SELECT
    d.year,
    SUM(s.sales_amount) AS yearly_sales
FROM sales s
JOIN dim_date d
ON s.order_date = d.date_id
GROUP BY d.year
ORDER BY d.year;


SELECT
    p.product_name,
    SUM(s.sales_amount) AS total_sales
FROM sales s
JOIN products p
ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    region,
    SUM(sales_amount) AS total_sales
FROM sales
GROUP BY region
ORDER BY total_sales DESC;













