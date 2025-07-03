-- subqueries.sql

-- Query 1: Find all properties where the average rating is greater than 4.0 using a non-correlated subquery.
-- This subquery first calculates the average rating for each property.
-- The outer query then filters properties based on this pre-calculated average.
SELECT
    P.property_id,
    P.name,
    P.location,
    P.pricepernight
FROM
    Property AS P
WHERE
    P.property_id IN (
        SELECT
            R.property_id
        FROM
            Review AS R
        GROUP BY
            R.property_id
        HAVING
            AVG(R.rating) > 4.0
    );

-- Query 2: Correlated subquery to find users who have made more than 3 bookings.
-- This query iterates through each user in the outer query.
-- For each user, the subquery counts their bookings. The subquery's execution
-- depends on the outer query's 'user_id', making it correlated.
SELECT
    U.user_id,
    U.first_name,
    U.last_name,
    U.email
FROM
    User AS U
WHERE
    (SELECT COUNT(B.booking_id)
     FROM Booking AS B
     WHERE B.user_id = U.user_id) > 3;
