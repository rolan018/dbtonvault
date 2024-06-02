CREATE SCHEMA IF NOT EXISTS stage;

CREATE TABLE IF NOT EXISTS stage.user 
(
    user_number INTEGER,
    user_name VARCHAR(255) NOT NULL,
    user_email VARCHAR(100),
    user_phone_number BIGINT,
    date_login DATE,
	date_load DATE
);

CREATE TABLE IF NOT EXISTS stage.product 
(
    product_number INTEGER,
	product_name VARCHAR(255) NOT NULL,
	fuel_type  VARCHAR(100),
	gear_type  VARCHAR(100),
	product_category VARCHAR(100),
	date_product DATE,
	date_load DATE
);

CREATE TABLE IF NOT EXISTS stage.order
(
    order_number INTEGER,
	product_number INTEGER,
	user_number INTEGER,
	order_description TEXT,
	date_order DATE,
	date_load DATE
);