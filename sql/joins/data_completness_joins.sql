Objective: When to use FULL OUTER JOIN vs CROSS JOIN

Let's say you have two tables:

Products:
product_id | product_name    | category
-----------+----------------+----------
1         | Laptop         | Electronics
2         | Desk Chair     | Furniture
3         | Printer        | Electronics

Warehouses:
warehouse_id | warehouse_name | region
-------------+---------------+--------
101         | South West        | Midwest
102         | East Coast        | East

1. Create all possible product-warehouse combinations (6 rows total)

SELECT
    p.product_id,
    p.product_name,
    w.warehouse_id,
    w.warehouse_name
FROM
    Products p
CROSS JOIN
    Warehouses w
ORDER BY
    p.product_id, w.warehouse_id;

This generates all possible (6 rows total), useful for planning where each product could be stocked, perfect for generating a complete allocation matrix.

Expected result:
product_id | product_name | warehouse_id | warehouse_name
-----------+--------------+-------------+---------------
1         | Laptop       | 101         | North Central
1         | Laptop       | 102         | East Coast
2         | Desk Chair   | 101         | North Central
2         | Desk Chair   | 102         | East Coast
3         | Printer      | 101         | North Central
3         | Printer      | 102         | East Coast



2. Assume we have an Inventory table tracking which products are in which warehouses: Write a query to capture actual state of affairs with missing relationships

Inventory:
product_id | warehouse_id | quantity
-----------+-------------+----------
1         | 101         | 15
2         | 102         | 8

SELECT
p.product_id,
p.product_name,
w.warehouse_id,
w.warehouse_name,
COALESCE(i.quantity,0) AS quantity
FROM Inventory i
FULL OUTER JOIN Products  p  ON p.product_id = i.product_id
FULL OUTER JOIN Warehouses w ON  w.product_id = i.warehouse_id
ORDER BY p.product_id, w.warehouse_id

Expected result:
product_id | product_name | warehouse_id | warehouse_name  | quantity
-----------+--------------+-------------+----------------+----------
1         | Laptop       | 101         | North Central  | 15
2         | Desk Chair   | 102         | East Coast     | 8
3         | Printer      | NULL        | NULL           | 0

-- FULL OUTER JOIN is especially valuable when you need to identify gaps
-- Empty warehouses that need product allocation (in this case Printer isn't stocked anywhere)
-- Comprehensive gap analysis in your distribution network
-- Complete data integrity checks across related tables (can be prevented by foreign key checks)