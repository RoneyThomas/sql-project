-- Managers first (manager_id is NULL)
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (1, 'Fabiola', 'Jackson',  'fabiola.jackson@bikes.com',  '(831) 555-5557', 1, 1, NULL);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (2, 'Mireille','Hahn',     'mireille.hahn@bikes.com',    '(516) 555-5558', 1, 2, NULL);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (3, 'Genna',   'Serrano',  'genna.serrano@bikes.com',    '(972) 555-5559', 1, 3, NULL);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (4, 'Virgie',  'Wiggins',  'virgie.wiggins@bikes.com',   '(303) 555-5560', 1, 4, NULL);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (5, 'Layla',   'Hassan',   'layla.hassan@bikes.com',     '(206) 555-5561', 1, 5, NULL);
-- Associates
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (6,  'Venita',  'Daniel',  'venita.daniel@bikes.com',    '(831) 555-5562', 1, 1, 1);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (7,  'Kali',    'Vargas',  'kali.vargas@bikes.com',      '(516) 555-5563', 1, 2, 2);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (8,  'Cesar',   'Emery',   'cesar.emery@bikes.com',      '(972) 555-5564', 1, 3, 3);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (9,  'Bernardine','Boss',  'bernardine.boss@bikes.com',  '(303) 555-5565', 0, 4, 4);
INSERT INTO sales_staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES (10, 'Ivy',     'Nguyen',  'ivy.nguyen@bikes.com',       '(206) 555-5566', 1, 5, 5);
