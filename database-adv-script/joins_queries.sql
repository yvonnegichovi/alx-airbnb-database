-- joins_queries.sql

-- Query 1: INNER JOIN to retrieve all bookings and the respective users who made those bookings.
-- This query will only return rows where there is a match in both the 'Booking' and 'User' tables.
SELECT
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status,
    U.user_id,
    U.first_name,
    U.last_name,
    U.email
FROM
    Booking AS B
INNER JOIN
    User AS U ON B.user_id = U.user_id;

-- Query 2: LEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.
-- This query will return all properties from the 'Property' table, and matching reviews from the 'Review' table.
-- If a property has no reviews, the review-related columns will be NULL.
SELECT
    P.property_id,
    P.name AS property_name,
    P.location,
    P.pricepernight,
    R.review_id,
    R.rating,
    R.comment,
    R.created_at AS review_date
FROM
    Property AS P
LEFT JOIN
    Review AS R ON P.property_id = R.property_id;

-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings,
-- even if the user has no booking or a booking is not linked to a user.
-- MySQL does not directly support FULL OUTER JOIN.
-- The common workaround is to use a UNION ALL of a LEFT JOIN and a RIGHT JOIN.
-- The LEFT JOIN gets all users and their bookings (if any).
-- The RIGHT JOIN gets all bookings and their users (if any), ensuring bookings without a user are included.
-- We use COALESCE to pick the non-NULL value for common columns like user_id and booking_id.
SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status
FROM
    User AS U
LEFT JOIN
    Booking AS B ON U.user_id = B.user_id

UNION ALL

SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status
FROM
    User AS U
RIGHT JOIN
    Booking AS B ON U.user_id = B.user_id
WHERE
    U.user_id IS NULL; -- This condition ensures we only get rows from the RIGHT JOIN that were not already in the LEFT JOIN result (i.e., bookings without a matching user).

-- Alternative for FULL OUTER JOIN (using two LEFT JOINs and a WHERE clause)
-- This approach is often preferred as it avoids the RIGHT JOIN which can sometimes be less intuitive.
-- It works by doing a LEFT JOIN from User to Booking, and then another LEFT JOIN from Booking to User,
-- combining the results, and filtering out duplicates.
/*
SELECT
    COALESCE(U.user_id, B.user_id) AS user_id,
    U.first_name,
    U.last_name,
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status
FROM
    User AS U
LEFT JOIN
    Booking AS B ON U.user_id = B.user_id

UNION

SELECT
    COALESCE(U.user_id, B.user_id) AS user_id,
    U.first_name,
    U.last_name,
    B.booking_id,
    B.start_date,
    B.end_date,
    B.total_price,
    B.status
FROM
    Booking AS B
LEFT JOIN
    User AS U ON B.user_id = U.user_id
WHERE
    U.user_id IS NULL; -- This ensures we only get bookings that didn't have a matching user in the first LEFT JOIN
*/

