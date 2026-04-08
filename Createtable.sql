ALTER SESSION SET NLS_DATE_FORMAT = 'YYYYMMDD';

CREATE TABLE production_categories (
	category_id INT PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);

CREATE TABLE production_brands (
	brand_id INT PRIMARY KEY,
	brand_name VARCHAR (255) NOT NULL
);


CREATE TABLE production_products (
	product_id INT PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) REFERENCES production_categories (category_id),
	FOREIGN KEY (brand_id) REFERENCES production_brands (brand_id)
);


CREATE TABLE sales_customers (
	customer_id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 CACHE 1000) PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);

CREATE TABLE sales_stores (
	store_id INT PRIMARY KEY,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
);

CREATE TABLE sales_staffs (
	staff_id INT PRIMARY KEY,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active INT NOT NULL,
	store_id INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id) REFERENCES sales_stores (store_id) ON DELETE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES sales_staffs (staff_id)
);


CREATE TABLE sales_orders (
	order_id INT PRIMARY KEY,
	customer_id INT,
	order_status INT NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE NOT NULL,
	shipped_date DATE,
	store_id INT NOT NULL,
	staff_id INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES sales_customers (customer_id),
	FOREIGN KEY (store_id) REFERENCES sales_stores (store_id),
	FOREIGN KEY (staff_id) REFERENCES sales_staffs (staff_id)
);


CREATE TABLE sales_order_items (
	order_id INT,
	item_id INT,
	product_id INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) DEFAULT 0,
	PRIMARY KEY (order_id, item_id),
	FOREIGN KEY (order_id) REFERENCES sales_orders (order_id),
	FOREIGN KEY (product_id) REFERENCES production_products (product_id)
);

CREATE TABLE production_stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	PRIMARY KEY (store_id, product_id),
	FOREIGN KEY (store_id) REFERENCES sales_stores (store_id) ,
	FOREIGN KEY (product_id) REFERENCES production_products (product_id) 
);
CREATE TABLE sales_wishlists (
	wishlist_id INT PRIMARY KEY,
	customer_id INT NOT NULL,
	created_date DATE DEFAULT SYSDATE,
	FOREIGN KEY (customer_id) REFERENCES sales_customers (customer_id)
);

CREATE TABLE sales_wishlist_items (
	wishlist_id INT NOT NULL,
	product_id INT NOT NULL,
	added_date DATE DEFAULT SYSDATE,
	PRIMARY KEY (wishlist_id, product_id),
	FOREIGN KEY (wishlist_id) REFERENCES sales_wishlists (wishlist_id),
	FOREIGN KEY (product_id) REFERENCES production_products (product_id)
);

CREATE TABLE sales_returns (
	return_id INT PRIMARY KEY,
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	customer_id INT NOT NULL,
	return_date DATE DEFAULT SYSDATE,
	reason VARCHAR (255),
	refund_amount DECIMAL (10, 2),
	status VARCHAR (50),
	FOREIGN KEY (order_id) REFERENCES sales_orders (order_id),
	FOREIGN KEY (product_id) REFERENCES production_products (product_id),
	FOREIGN KEY (customer_id) REFERENCES sales_customers (customer_id)
);

-- Vendors: suppliers of products/brands
CREATE TABLE production_vendors (
	vendor_id INT PRIMARY KEY,
	vendor_name VARCHAR (255) NOT NULL,
	contact_name VARCHAR (255),
	phone VARCHAR (25),
	email VARCHAR (255),
	city VARCHAR (100),
	state VARCHAR (25),
	active INT DEFAULT 1 NOT NULL
);

-- Links vendors to the brands they supply
CREATE TABLE production_vendor_brands (
	vendor_id INT,
	brand_id INT,
	PRIMARY KEY (vendor_id, brand_id),
	FOREIGN KEY (vendor_id) REFERENCES production_vendors (vendor_id),
	FOREIGN KEY (brand_id) REFERENCES production_brands (brand_id)
);

-- Shopping cart header
CREATE TABLE sales_cart (
	cart_id INT PRIMARY KEY,
	customer_id INT NOT NULL,
	created_date DATE DEFAULT SYSDATE,
	FOREIGN KEY (customer_id) REFERENCES sales_customers (customer_id)
);

-- Shopping cart line items
CREATE TABLE sales_cart_items (
	cart_id INT,
	product_id INT,
	quantity INT NOT NULL,
	added_date DATE DEFAULT SYSDATE,
	PRIMARY KEY (cart_id, product_id),
	FOREIGN KEY (cart_id) REFERENCES sales_cart (cart_id),
	FOREIGN KEY (product_id) REFERENCES production_products (product_id)
);

-- Shipping / tracking per order
CREATE TABLE sales_shipping (
	shipping_id INT PRIMARY KEY,
	order_id INT NOT NULL,
	carrier VARCHAR (100),
	tracking_number VARCHAR (100),
	-- Statuses: Preparing, Shipped, In Transit, Delivered
	shipping_status VARCHAR (50),
	estimated_delivery DATE,
	actual_delivery DATE,
	FOREIGN KEY (order_id) REFERENCES sales_orders (order_id)
);
