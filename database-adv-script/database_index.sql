-- Objective: Create indexes to improve query performance on high-usage columns.

-- User Table:
-- Index on 'email' for faster lookups, as it's unique and likely used in login/user retrieval.
CREATE INDEX idx_user_email ON User (email);

-- Property Table:
-- Index on 'host_id' as it's a foreign key and frequently used in joins (e.g., finding properties by a specific host).
CREATE INDEX idx_property_host_id ON Property (host_id);
-- Index on 'location' for faster searches when users filter properties by location.
CREATE INDEX idx_property_location ON Property (location);

-- Booking Table:
-- Index on 'user_id' as it's a foreign key and used in joins/WHERE clauses (e.g., finding bookings made by a user).
CREATE INDEX idx_booking_user_id ON Booking (user_id);
-- Index on 'property_id' as it's a foreign key and used in joins/WHERE clauses (e.g., finding bookings for a property).
CREATE INDEX idx_booking_property_id ON Booking (property_id);
-- Index on 'start_date' and 'end_date' for efficient range queries (e.g., checking availability, finding bookings within a date range).
CREATE INDEX idx_booking_dates ON Booking (start_date, end_date);
-- Index on 'status' as it's likely used for filtering bookings (e.g., pending, confirmed, canceled).
CREATE INDEX idx_booking_status ON Booking (status);

-- Payment Table:
-- Index on 'booking_id' as it's a foreign key and used in joins/WHERE clauses (e.g., finding payments for a booking).
CREATE INDEX idx_payment_booking_id ON Payment (booking_id);

-- Review Table:
-- Index on 'property_id' as it's a foreign key and used in joins/WHERE clauses (e.g., finding reviews for a property).
CREATE INDEX idx_review_property_id ON Review (property_id);
-- Index on 'user_id' as it's a foreign key and used in joins/WHERE clauses (e.g., finding reviews written by a user).
CREATE INDEX idx_review_user_id ON Review (user_id);

-- Message Table:
-- Index on 'sender_id' for efficient retrieval of messages sent by a user.
CREATE INDEX idx_message_sender_id ON Message (sender_id);
-- Index on 'recipient_id' for efficient retrieval of messages received by a user.
CREATE INDEX idx_message_recipient_id ON Message (recipient_id);
