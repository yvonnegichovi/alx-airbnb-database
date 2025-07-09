# Index Performance Analysis: Enhancing Query Efficiency
This document details the process of identifying high-usage columns, creating appropriate indexes, and analyzing their impact on query performance within the Airbnb database. The goal is to optimize data retrieval operations, which is crucial for the responsiveness and scalability of high-volume applications.

## 1. Identifying High-Usage Columns
Indexes are most effective on columns frequently used in WHERE clauses, JOIN conditions, and ORDER BY clauses. Based on the Airbnb database schema and typical application usage patterns, the following columns were identified as candidates for indexing:

* User Table:

** email: Frequently used for user login and unique identification.

* Property Table:

host_id: A foreign key, heavily used in joins to link properties to their hosts.

location: Essential for searching properties by geographical area.

* Booking Table:

user_id: A foreign key, used to retrieve bookings made by a specific user.

property_id: A foreign key, used to retrieve bookings for a specific property.

start_date, end_date: Critical for date-range queries (e.g., availability checks, historical bookings).

status: Used for filtering bookings by their current state (pending, confirmed, canceled).

* Payment Table:

booking_id: A foreign key, used to retrieve payment details for a specific booking.

* Review Table:

property_id: A foreign key, used to retrieve reviews for a specific property.

user_id: A foreign key, used to retrieve reviews written by a specific user.

* Message Table:

sender_id: A foreign key, used to retrieve messages sent by a user.

recipient_id: A foreign key, used to retrieve messages received by a user.

Primary keys are automatically indexed by the database system, so the focus here is on creating secondary indexes.

## 2. SQL Index Creation Commands
The following CREATE INDEX commands were used to add indexes to the identified columns. These commands are located in the database_index.sql file.

```
-- Example from database_index.sql
-- User Table:
CREATE INDEX idx_user_email ON User (email);

-- Property Table:
CREATE INDEX idx_property_host_id ON Property (host_id);
CREATE INDEX idx_property_location ON Property (location);

-- Booking Table:
CREATE INDEX idx_booking_user_id ON Booking (user_id);
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);
CREATE INDEX idx_booking_status ON Booking (status);

-- ... (and so on for other tables as detailed in database_index.sql)
```

To apply these indexes, execute the database_index.sql script against your MySQL database.

## 3. Measuring Query Performance (Before and After Indexing)
To demonstrate the impact of indexing, one would typically select a few representative complex queries that involve the indexed columns and analyze their execution plans using EXPLAIN (or EXPLAIN ANALYZE for more detailed runtime statistics).

### Methodology:
#### 1. Baseline Measurement (Before Indexes):

* Ensure no custom indexes exist on the target columns (or drop them temporarily if testing from a clean slate).

* Choose a representative query. For example:

```
SELECT
    P.name AS property_name,
    P.location,
    B.start_date,
    B.end_date,
    U.first_name AS guest_first_name,
    U.last_name AS guest_last_name
FROM
    Booking AS B
INNER JOIN
    Property AS P ON B.property_id = P.property_id
INNER JOIN
    User AS U ON B.user_id = U.user_id
WHERE
    P.location = 'New York' AND B.start_date >= '2025-01-01'
ORDER BY
    B.start_date;
```

* Run EXPLAIN on the query:

```
EXPLAIN SELECT
    P.name AS property_name,
    P.location,
    B.start_date,
    B.end_date,
    U.first_name AS guest_first_name,
    U.last_name AS guest_last_name
FROM
    Booking AS B
INNER JOIN
    Property AS P ON B.property_id = P.property_id
INNER JOIN
    User AS U ON B.user_id = U.user_id
WHERE
    P.location = 'New York' AND B.start_date >= '2025-01-01'
ORDER BY
    B.start_date;
```

* Analyze the EXPLAIN output: Look for:

type: ALL (full table scan) or index (full index scan) for tables involved in WHERE or JOIN conditions.

rows: A large number indicates many rows scanned.

Extra: Using filesort (expensive sorting on disk), Using temporary (expensive temporary table creation).

## 2. Post-Indexing Measurement (After Indexes):

Apply the indexes by running the database_index.sql script.

Re-run the exact same EXPLAIN query.

Analyze the EXPLAIN output again: Compare it to the baseline.

### Expected Improvements:
After applying the indexes, you would typically observe the following changes in the EXPLAIN output:

* type change: For tables involved in WHERE clauses (e.g., Property for location, Booking for start_date), the type should change from ALL to range or ref, indicating that the index is being used to quickly locate relevant rows.

*Reduced rows: The number of rows scanned by the database engine should significantly decrease, as the index allows it to jump directly to the data it needs.

*Extra improvements:

Using filesort should disappear if an index covers the ORDER BY clause (e.g., idx_booking_dates for ORDER BY B.start_date).

Using temporary might be reduced or eliminated if indexes facilitate join operations.

Faster key usage: You should see the names of the newly created indexes (idx_property_location, idx_booking_dates, etc.) appearing in the key column of the EXPLAIN output, confirming their usage.

By strategically applying indexes, the database can avoid full table scans, quickly locate data using index trees, and perform sorting and joining operations much more efficiently, leading to substantial performance gains for frequently executed queries.
