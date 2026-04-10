-- ============================================================
-- E-Commerce Database: Business Requirement Queries
-- Course: COMP122 - Introduction to Database Concepts
-- ============================================================


-- ============================================================
-- 1. SEARCH PRODUCTS BASED ON CATEGORY
--    Returns all products in a given category with brand info.
--    Change the category_name value to search a different category.
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    b.brand_name,
    p.model_year,
    p.list_price
FROM production_products p
JOIN production_categories c ON p.category_id = c.category_id
JOIN production_brands     b ON p.brand_id     = b.brand_id
WHERE c.category_name = 'Mountain Bikes'
ORDER BY p.list_price;


-- ============================================================
-- 2. MANAGE SHOPPING CART
--    2a. Add an item to a customer's cart
--    2b. View the contents of a cart with subtotals
--    2c. Update item quantity in cart
--    2d. Remove an item from a cart
-- ============================================================

-- 2a. Add item to cart (cart must already exist; change values as needed)
INSERT INTO sales_cart_items(cart_id, product_id, quantity, added_date)
VALUES(1, 5, 1, SYSDATE);

-- 2b. View cart for customer_id = 2
SELECT
    ci.cart_id,
    c.first_name || ' ' || c.last_name      AS customer_name,
    p.product_id,
    p.product_name,
    ci.quantity,
    p.list_price,
    ci.quantity * p.list_price               AS subtotal
FROM sales_cart        sc
JOIN sales_customers    c  ON sc.customer_id = c.customer_id
JOIN sales_cart_items   ci ON sc.cart_id     = ci.cart_id
JOIN production_products p  ON ci.product_id = p.product_id
WHERE sc.customer_id = 2
ORDER BY ci.added_date;

-- 2c. Update quantity of a product already in the cart
UPDATE sales_cart_items
SET    quantity = 2
WHERE  cart_id = 1 AND product_id = 3;

-- 2d. Remove a specific item from the cart (removes what was added in 2a)
DELETE FROM sales_cart_items
WHERE  cart_id = 1 AND product_id = 5;


-- ============================================================
-- 3. REGISTER / UNREGISTER USER
--    3a. Register a new customer
--    3b. View newly registered customer
--    3c. Unregister (delete) a customer by email
-- ============================================================

-- 3a. Register new customer
INSERT INTO sales_customers(first_name, last_name, phone, email, street, city, state, zip_code)
VALUES('Jane', 'Doe', '(416) 555-9999', 'jane.doe@email.com', '123 Main St', 'Toronto', 'ON', '90210');

-- 3b. Confirm registration
SELECT * FROM sales_customers
WHERE  email = 'jane.doe@email.com';

-- 3c. Unregister customer (hard delete; use only when no dependent orders exist)
DELETE FROM sales_customers
WHERE  email = 'jane.doe@email.com';


-- ============================================================
-- 4. TRACK SHIPPING STATUS
--    Shows the shipping/tracking details for every order
--    belonging to a specific customer.
-- ============================================================
SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name   AS customer_name,
    o.order_date,
    o.required_date,
    s.carrier,
    s.tracking_number,
    s.shipping_status,
    s.estimated_delivery,
    s.actual_delivery
FROM sales_orders    o
JOIN sales_customers  c ON o.customer_id  = c.customer_id
JOIN sales_shipping   s ON o.order_id     = s.order_id
WHERE o.customer_id = 1
ORDER BY o.order_date DESC;


-- ============================================================
-- 5. MANAGE VENDORS
--    5a. Add a new vendor
--    5b. List all active vendors with their supplied brands
--    5c. Deactivate a vendor (soft delete)
-- ============================================================

-- 5a. Add vendor
INSERT INTO production_vendors(vendor_id, vendor_name, contact_name, phone, email, city, state, active)
VALUES(11, 'Pacific Cycle Imports', 'Amy Tran', '(604) 555-2001', 'amy@pacificcycle.com', 'Vancouver', 'BC', 1);

-- 5b. List active vendors with the brands they supply
SELECT
    v.vendor_id,
    v.vendor_name,
    v.contact_name,
    v.phone,
    v.email,
    v.city,
    v.state,
    b.brand_name
FROM production_vendors      v
JOIN production_vendor_brands vb ON v.vendor_id = vb.vendor_id
JOIN production_brands        b  ON vb.brand_id  = b.brand_id
WHERE v.active = 1
ORDER BY v.vendor_name;

-- 5c. Deactivate vendor (does not delete historical data)
UPDATE production_vendors
SET    active = 0
WHERE  vendor_id = 10;


-- ============================================================
-- 6. GENERATE MONTHLY SALES REPORT
--    Aggregates completed orders (status = 4) by month,
--    showing order count and total revenue.
-- ============================================================
SELECT
    TO_CHAR(o.order_date, 'YYYY-MM')                            AS sales_month,
    COUNT(DISTINCT o.order_id)                                  AS total_orders,
    SUM(oi.quantity)                                            AS units_sold,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS total_revenue
FROM sales_orders      o
JOIN sales_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 4
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY sales_month;


-- ============================================================
-- 7. IDENTIFY THE MOST POPULAR PRODUCTS
--    Ranks products by total units sold across all orders.
-- ============================================================
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    b.brand_name,
    SUM(oi.quantity)                                            AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS total_revenue
FROM sales_order_items   oi
JOIN production_products  p  ON oi.product_id  = p.product_id
JOIN production_categories c ON p.category_id  = c.category_id
JOIN production_brands     b ON p.brand_id     = b.brand_id
GROUP BY p.product_id, p.product_name, c.category_name, b.brand_name
ORDER BY total_units_sold DESC
FETCH FIRST 10 ROWS ONLY;


-- ============================================================
-- 8. CATEGORIZE CUSTOMERS BASED ON PURCHASE HISTORY
--    Segments customers into tiers based on lifetime spend:
--      Platinum: >= $5,000  |  Gold: >= $2,000
--      Silver:   >= $500    |  Bronze: < $500
-- ============================================================
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name                          AS customer_name,
    c.email,
    COUNT(DISTINCT o.order_id)                                  AS total_orders,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS lifetime_spend,
    CASE
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 5000 THEN 'Platinum'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 2000 THEN 'Gold'
        WHEN SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 500  THEN 'Silver'
        ELSE 'Bronze'
    END                                                         AS customer_tier
FROM sales_customers    c
JOIN sales_orders       o  ON c.customer_id = o.customer_id
JOIN sales_order_items  oi ON o.order_id    = oi.order_id
WHERE o.order_status = 4
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY lifetime_spend DESC;


-- ============================================================
-- 9. LIST ALL ITEMS ON A USER'S WISH LIST
--    Returns all wish-listed products for a given customer.
--    Change the WHERE clause customer_id to target another user.
-- ============================================================
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name  AS customer_name,
    p.product_name,
    cat.category_name,
    b.brand_name,
    p.list_price,
    wi.added_date
FROM sales_wishlists      wl
JOIN sales_wishlist_items wi  ON wl.wishlist_id = wi.wishlist_id
JOIN production_products  p   ON wi.product_id  = p.product_id
JOIN production_categories cat ON p.category_id = cat.category_id
JOIN production_brands     b   ON p.brand_id    = b.brand_id
JOIN sales_customers       c   ON wl.customer_id = c.customer_id
WHERE wl.customer_id = 1
ORDER BY wi.added_date DESC;


-- ============================================================
-- 10. HANDLE RETURNS AND REFUNDS
--    10a. Submit a return request
--    10b. Approve a return / issue refund
--    10c. View all returns with current status
-- ============================================================

-- 10a. Submit a return request
INSERT INTO sales_returns(return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status)
VALUES(11, 22, 19, 3, SYSDATE, 'Defective product', 279.99, 'Pending');

-- 10b. Approve a return and mark as refunded
UPDATE sales_returns
SET    status = 'Refunded'
WHERE  return_id = 1;

-- 10c. View all returns with customer and product details
SELECT
    r.return_id,
    c.first_name || ' ' || c.last_name  AS customer_name,
    p.product_name,
    r.return_date,
    r.reason,
    r.refund_amount,
    r.status
FROM sales_returns       r
JOIN sales_customers     c ON r.customer_id = c.customer_id
JOIN production_products p ON r.product_id  = p.product_id
ORDER BY r.return_date DESC;
