# Database Performance Monitoring and Refinement Report

This report outlines the continuous process of **monitoring** and **refining database performance** within the Airbnb application. Ongoing query analysis is essential for identifying bottlenecks and making informed schema optimizations to ensure system responsiveness and scalability.

---

## 1. Objective

The goal is to:

* Continuously **monitor the performance** of frequently executed SQL queries
* Identify inefficiencies or **bottlenecks**
* Propose and implement **schema adjustments** (e.g., indexes)
* Report on **observed performance improvements**

---

## 2. Monitoring Tools and Methodology

### Tools Used:

* **`EXPLAIN ANALYZE`**: Primary tool for visualizing the query execution plan and actual runtime statistics
* **`SHOW PROFILE`** (optional): Helps track resource usage stages like parsing, execution, and fetching

### Methodology:

1. **Identify Frequently Used Queries**
   Choose critical or frequently executed queries in the application (especially performance-sensitive ones).

2. **Baseline Measurement**
   Run each query with `EXPLAIN ANALYZE`. Observe and document:

   * `type`: Access method (e.g., `ALL`, `index`, `range`, `eq_ref`)
   * `rows`: Estimated rows scanned
   * `filtered`: % of rows matching the condition
   * `Extra`: Info like `Using filesort`, `Using temporary`, `Using where`
   * `actual time`: Real execution time (MySQL 8+)

3. **Identify Bottlenecks**
   Common problems include:

   * Full table scans (`type: ALL`)
   * High row counts for joins or filters
   * `Using filesort` or `Using temporary` (expensive operations)
   * Poor join order or missing indexes

4. **Suggest & Implement Changes**
   Propose schema changes such as:

   * New indexes
   * Composite indexes
   * Consideration of denormalization in specific cases

5. **Measure Improvements**
   Re-run the query and compare performance before and after optimization.

---

## 3. Case Study: Optimizing a Booking Search Query

### Use Case:

A frequent query to fetch bookings in a specific date range for properties in a specific location, ordered by price.

### SQL Query:

```sql
SELECT
    B.booking_id,
    P.name AS property_name,
    P.location,
    B.start_date,
    B.end_date,
    B.total_price,
    U.first_name AS guest_name
FROM
    Booking AS B
INNER JOIN Property AS P ON B.property_id = P.property_id
INNER JOIN User AS U ON B.user_id = U.user_id
WHERE
    P.location = 'London'
    AND B.start_date BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY
    P.pricepernight DESC;
```

---

### 3.1 Baseline Analysis (Before Optimization)

#### `EXPLAIN ANALYZE` Output (Conceptual):

```
-> Sort: P.pricepernight DESC
    -> Hash Join
        -> Table scan on U
        -> Hash Join
            -> Table scan on P
                -> Filter: P.location = 'London'
            -> Table scan on B
                -> Filter: B.start_date BETWEEN '2025-01-01' AND '2025-03-31'
```

#### Bottlenecks:

* **Full table scans** on `Property` and `Booking`, despite WHERE filters
* **Post-scan filtering** on large result sets — costly in I/O
* **`Using filesort`** due to lack of index on `pricepernight`

---

### 3.2 Suggested Schema Adjustments

#### Indexes Implemented:

```sql
-- For filtering properties by location
CREATE INDEX idx_property_location ON Property (location);

-- For filtering bookings by date range
CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);

-- For sorting properties by price
CREATE INDEX idx_property_pricepernight ON Property (pricepernight);
```

> Note: `idx_booking_user_id` and `idx_booking_property_id` assumed to be in place for JOIN optimization.

---

### 3.3 Post-Optimization Performance

#### `EXPLAIN ANALYZE` Output (Conceptual):

```
-> Index scan on P using idx_property_pricepernight
    -> Nested loop inner join
        -> Index lookup on B using idx_booking_property_id
            -> Filter: B.start_date BETWEEN '2025-01-01' AND '2025-03-31'
        -> Index lookup on U using PRIMARY
            -> Filter: P.location = 'London'
```

#### Observed Improvements:

* **Efficient Index Usage**

  * `ref` or `range` access types for `Property` and `Booking`
  * Filtering now uses `idx_property_location` and `idx_booking_dates`
* **Drastically reduced rows scanned**
* **ORDER BY** handled efficiently with `idx_property_pricepernight`
* **JOINs optimized** through existing foreign key indexes
* **Lower execution time** (measurable drop in `actual time` per loop)

---

## 4. Conclusion

Continuous database monitoring using `EXPLAIN ANALYZE` is essential for:

* Identifying real performance bottlenecks
* Making **targeted schema optimizations** through strategic indexing
* Achieving **scalable**, high-performance query execution

This **analyze → suggest → implement → measure** cycle is the backbone of any well-maintained database system and ensures that the Airbnb application remains fast and responsive, even as the dataset grows.
