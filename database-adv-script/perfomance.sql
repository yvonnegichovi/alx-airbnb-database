-- Objective: Refactor complex queries to improve performance.

-- --- Initial Query ---
-- This query retrieves all bookings along with user details, property details, and payment details.
-- It uses INNER JOINs to combine data from four tables.
SELECT
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status,
    U.user_id,
    U.first_name,
    U.last_name,
    U.email,
    P.property_id,
    P.name AS property_name,
    P.location,
    P.pricepernight,
    PY.payment_id,
    PY.amount,
    PY.payment_date,
    PY.payment_method
FROM
    Booking AS B
INNER JOIN
    User AS U ON B.user_id = U.user_id
INNER JOIN
    Property AS P ON B.property_id = P.property_id
INNER JOIN
    Payment AS PY ON B.booking_id = PY.booking_id;

-- --- Performance Analysis: EXPLAIN ANALYZE for Initial Query ---
-- Run this to see the execution plan and runtime statistics *before* any specific refactoring
-- (other than existing indexes). Look for 'type: ALL', high 'rows', or 'Using temporary/filesort'.
EXPLAIN ANALYZE
SELECT
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status,
    U.user_id,
    U.first_name,
    U.last_name,
    U.email,
    P.property_id,
    P.name AS property_name,
    P.location,
    P.pricepernight,
    PY.payment_id,
    PY.amount,
    PY.payment_date,
    PY.payment_method
FROM
    Booking AS B
INNER JOIN
    User AS U ON B.user_id = U.user_id
INNER JOIN
    Property AS P ON B.property_id = P.property_id
INNER JOIN
    Payment AS PY ON B.booking_id = PY.booking_id;

-- --- Refactored Query ---
SELECT
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status,
    U.user_id,
    U.first_name,
    U.last_name,
    U.email,
    P.property_id,
    P.name AS property_name,
    P.location,
    P.pricepernight,
    PY.payment_id,
    PY.amount,
    PY.payment_date,
    PY.payment_method
FROM
    Booking AS B
INNER JOIN
    User AS U ON B.user_id = U.user_id
INNER JOIN
    Property AS P ON B.property_id = P.property_id
INNER JOIN
    Payment AS PY ON B.booking_id = PY.booking_id;

-- --- Performance Analysis: EXPLAIN ANALYZE for Refactored Query ---
EXPLAIN ANALYZE
SELECT
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status,
    U.user_id,
    U.first_name,
    U.last_name,
    U.email,
    P.property_id,
    P.name AS property_name,
    P.location,
    P.pricepernight,
    PY.payment_id,
    PY.amount,
    PY.payment_date,
    PY.payment_method
FROM
    Booking AS B
INNER JOIN
    User AS U ON B.user_id = U.user_id
INNER JOIN
    Property AS P ON B.property_id = P.property_id
INNER JOIN
    Payment AS PY ON B.booking_id = PY.booking_id;
