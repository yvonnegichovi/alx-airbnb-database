-- Query 1: Find the total number of bookings made by each user,
-- using the COUNT function and GROUP BY clause.
SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    U.email,
    COUNT(B.booking_id) AS total_bookings
FROM
    User AS U
LEFT JOIN
    Booking AS B ON U.user_id = B.user_id
GROUP BY
    U.user_id, U.first_name, U.last_name, U.email
ORDER BY
    total_bookings DESC, U.user_id;

-- Query 2: Use a window function (RANK) to rank properties
-- based on the total number of bookings they have received.
-- This query first calculates the total bookings for each property in a subquery (or CTE).
-- Then, it applies the RANK() window function over these results.
WITH PropertyBookingCounts AS (
    SELECT
        P.property_id,
        P.name AS property_name,
        COUNT(B.booking_id) AS total_bookings
    FROM
        Property AS P
    LEFT JOIN
        Booking AS B ON P.property_id = B.property_id
    GROUP BY
        P.property_id, P.name
)
SELECT
    property_id,
    property_name,
    total_bookings,
    ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM
    PropertyBookingCounts
ORDER BY
    booking_rank, property_id;

