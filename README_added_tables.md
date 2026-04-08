Script load order — run Createtable.sql first, then load inserts in this order:

 1. production_categories.sql
 2. production_brands.txt
 3. production_products.sql
 4. sales_stores.sql
 5. sales_staff.txt
 6. sales_customer.sql
 7. sales_orders.sql
 8. sales_order_items.sql
 9. production_stocks.sql
10. sales_wishlists.sql
11. sales_wishlist_items.sql
12. sales_returns.sql
13. production_vendors.sql      (vendors + vendor_brands; added for req #5)
14. sales_cart.sql              (cart + cart_items;       added for req #2)
15. sales_shipping.sql          (shipping tracking;       added for req #4)

Tables added to support all 10 business requirements:
  - production_vendors          Vendor/supplier records
  - production_vendor_brands    Links vendors to the brands they supply
  - sales_cart                  Shopping cart header per customer
  - sales_cart_items            Products and quantities in each cart
  - sales_shipping              Carrier/tracking/status per order

Queries for all 10 business requirements are in queries.sql.
