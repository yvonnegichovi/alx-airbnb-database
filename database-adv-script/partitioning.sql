-- Objective: Implement table partitioning on the Booking table based on the start_date column.

-- Drop the existing Booking table if it exists
DROP TABLE IF EXISTS Booking;

-- Create the Booking table with partitioning by range on the YEAR of start_date.
-- This strategy creates partitions for each year, allowing the database to
-- quickly prune irrelevant partitions when querying by date ranges.
CREATE TABLE Booking (
    booking_id VARCHAR(36) PRIMARY KEY,
    property_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- --- Test Query Performance on Partitioned Table ---
-- This query fetches bookings within a specific date range.
-- On a partitioned table, the database should only scan the relevant partitions
-- (e.g., p2025 for bookings in 2025), leading to significant performance gains.

-- Example Query: Fetch bookings for a specific year
EXPLAIN ANALYZE
SELECT
    booking_id,
    start_date,
    end_date,
    total_price,
    status
FROM
    Booking
WHERE
    start_date BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY
    start_date;

-- Example Query: Fetch bookings across two years
EXPLAIN ANALYZE
SELECT
    booking_id,
    start_date,
    end_date,
    total_price,
    status
FROM
    Booking
WHERE
    start_date BETWEEN '2024-06-01' AND '2025-06-30'
ORDER BY
    start_date;

-- Example Query: Fetch bookings for a single day (highly specific)
EXPLAIN ANALYZE
SELECT
    booking_id,
    start_date,
    end_date,
    total_price,
    status
FROM
    Booking
WHERE
    start_date = '2025-03-15'
ORDER BY
    booking_id;
