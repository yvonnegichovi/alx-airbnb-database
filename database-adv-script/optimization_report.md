# Query Optimization Report: Enhancing Multi-Table Joins

This report outlines the process of optimizing a complex SQL query designed to retrieve comprehensive booking information from an Airbnb-like database. The primary goal is to **identify inefficiencies** using `EXPLAIN ANALYZE` and apply **refactoring techniques** to improve query execution time.

---

## 1. Initial Complex Query

The initial query fetches all booking details along with associated **user**, **property**, and **payment** information. This is typical for generating reports or displaying detailed booking summaries in applications.

### Query:

```sql
SELECT
    B.booking_id, B.start_date, B.end_date, B.total_price, B.status,
    U.user_id, U.first_name, U.last_name, U.email,
    P.property_id, P.name AS property_name, P.location, P.pricepernight,
    PY.payment_id, PY.amount, PY.payment_date, PY.payment_method
FROM
    Booking AS B
INNER JOIN User AS U ON B.user_id = U.user_id
INNER JOIN Property AS P ON B.property_id = P.property_id
INNER JOIN Payment AS PY ON B.booking_id = PY.booking_id;
```

This query uses `INNER JOIN`s based on the following relationships:

* `Booking.user_id → User.user_id`
* `Booking.property_id → Property.property_id`
* `Booking.booking_id → Payment.booking_id`

---

## 2. Performance Analysis (Using `EXPLAIN ANALYZE`)

### Purpose:

`EXPLAIN ANALYZE` is used to examine runtime statistics, actual row counts, execution plans, and time spent per operation.

### Common Issues Without Indexes:

* **Join Type: `ALL` or `index`** — Indicates full table/index scans, which are expensive.
* **High Row Counts** — Excessive data being processed for each join.
* **Extra Operations** — Use of temporary tables or file sorts (e.g., `Using temporary`, `Using filesort`) due to inefficient join orders or large result sets.

### Example (Conceptual `EXPLAIN ANALYZE` Output Before Optimization):

| id | select\_type | table | type    | key     | rows    | Extra                         |
| -- | ------------ | ----- | ------- | ------- | ------- | ----------------------------- |
| 1  | SIMPLE       | B     | ALL     | NULL    | 5000000 |                               |
| 1  | SIMPLE       | U     | eq\_ref | PRIMARY | 1       |                               |
| 1  | SIMPLE       | P     | ALL     | NULL    | 1000000 | Using join buffer (hash join) |
| 1  | SIMPLE       | PY    | ALL     | NULL    | 5000000 | Using join buffer (hash join) |

Tables like `Property` and `Payment` perform full scans due to **missing indexes** on join columns.

---

## 3. Refactoring Strategy

The SQL structure is already efficient for retrieving related data via `INNER JOIN`s. The main performance enhancement comes from **indexing the foreign keys**.

### Indexes to Apply:

```sql
CREATE INDEX idx_booking_user_id ON Booking (user_id);
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_payment_booking_id ON Payment (booking_id);
```

> These indexes are defined in `database_index.sql`.

### Optional: Column Reduction

For production, it's good practice to **select only necessary columns**. Here, we retain all for completeness.

### Refactored Query (Same Structure, Now Optimized):

```sql
SELECT
    B.booking_id, B.start_date, B.end_date, B.total_price, B.status,
    U.user_id, U.first_name, U.last_name, U.email,
    P.property_id, P.name AS property_name, P.location, P.pricepernight,
    PY.payment_id, PY.amount, PY.payment_date, PY.payment_method
FROM
    Booking AS B
INNER JOIN User AS U ON B.user_id = U.user_id
INNER JOIN Property AS P ON B.property_id = P.property_id
INNER JOIN Payment AS PY ON B.booking_id = PY.booking_id;
```

---

## 4. Post-Optimization Analysis (`EXPLAIN ANALYZE`)

After applying indexes, the `EXPLAIN ANALYZE` output shows a significant improvement.

### Conceptual Output After Indexing:

| id | select\_type | table | type    | key                        | rows | Extra |
| -- | ------------ | ----- | ------- | -------------------------- | ---- | ----- |
| 1  | SIMPLE       | B     | ALL     | idx\_booking\_user\_id,... | ...  |       |
| 1  | SIMPLE       | U     | eq\_ref | PRIMARY                    | 1    |       |
| 1  | SIMPLE       | P     | eq\_ref | PRIMARY                    | 1    |       |
| 1  | SIMPLE       | PY    | eq\_ref | idx\_payment\_booking\_id  | 1    |       |

### Observed Improvements:

* **Join Type (`eq_ref` or `ref`)**: For joined tables, the database now reads only **one matching row per outer row** — extremely efficient.
* **Index Usage**: The `key` column now shows the correct usage of defined indexes.
* **Reduced Row Count**: Internal table scans drop from millions to 1 per join.
* **No Temporary Tables or Filesorts**: Confirming the optimizer is working as intended.

---

## Final Thoughts

Even with complex multi-table joins, **performance bottlenecks can be drastically reduced** by:

* Applying appropriate **indexes on foreign key columns**
* Using `EXPLAIN ANALYZE` to guide optimization
* Keeping queries well-structured and readable

This case demonstrates the **critical role of indexing** in relational database performance — a small tweak with massive impact.
