-- Returns reference completed orders (status=4)
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (1,  1,  1,  1, DATE '2023-01-20', 'Wrong size',            849.99, 'Approved');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (2,  2,  8,  2, DATE '2023-01-28', 'Defective product',    1499.99, 'Approved');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (3,  3,  3,  3, DATE '2023-02-18', 'Changed mind',         1199.99, 'Pending');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (4,  6,  9,  6, DATE '2023-03-25', 'Not as described',      529.99, 'Approved');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (5,  8, 19,  8, DATE '2023-05-01', 'Wrong color',           279.99, 'Rejected');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (6, 11, 13, 11, DATE '2023-06-25', 'Damaged in shipping',  3499.99, 'Approved');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (7, 14, 14, 14, DATE '2023-08-05', 'Defective product',    2799.99, 'Approved');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (8, 16,  1, 16, DATE '2023-09-06', 'Wrong size',            849.99, 'Pending');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (9, 21, 11,  1, DATE '2023-11-18', 'Changed mind',         1899.99, 'Approved');
INSERT INTO sales_returns (return_id, order_id, product_id, customer_id, return_date, reason, refund_amount, status) VALUES (10,25, 20,  9, DATE '2023-12-30', 'Not as described',     1699.99, 'Rejected');
