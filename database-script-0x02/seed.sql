-- Airbnb Clone Sample Seed Data

-- USERS
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  (uuid_generate_v4(), 'Alice', 'Kamau', 'alice@example.com', 'hashed_pwd_123', '0700000001', 'guest'),
  (uuid_generate_v4(), 'Bob', 'Njenga', 'bob@example.com', 'hashed_pwd_456', '0700000002', 'host'),
  (uuid_generate_v4(), 'Clara', 'Otieno', 'clara@example.com', 'hashed_pwd_789', '0700000003', 'guest'),
  (uuid_generate_v4(), 'Daniel', 'Mwangi', 'daniel@example.com', 'hashed_pwd_321', '0700000004', 'host');

-- PROPERTIES
INSERT INTO properties (property_id, host_id, name, description, location, pricepernight)
VALUES
  (uuid_generate_v4(), (SELECT user_id FROM users WHERE email = 'bob@example.com'), 'Hillview Villa', 'Scenic 3-bedroom house with a view', 'Naivasha, Kenya', 8500.00),
  (uuid_generate_v4(), (SELECT user_id FROM users WHERE email = 'daniel@example.com'), 'City Studio', 'Compact studio in the city center', 'Nairobi, Kenya', 4000.00);

-- BOOKINGS
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Hillview Villa'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    '2025-07-01',
    '2025-07-03',
    17000.00,
    'confirmed'
  ),
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'City Studio'),
    (SELECT user_id FROM users WHERE email = 'clara@example.com'),
    '2025-07-10',
    '2025-07-12',
    8000.00,
    'pending'
  );

-- PAYMENTS
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
VALUES
  (
    uuid_generate_v4(),
    (SELECT booking_id FROM bookings WHERE total_price = 17000.00),
    17000.00,
    'credit_card'
  );

-- REVIEWS
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
VALUES
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Hillview Villa'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    5,
    'Amazing stay with great views!'
  );

-- MESSAGES
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
  (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    (SELECT user_id FROM users WHERE email = 'bob@example.com'),
    'Hi Bob, is the Hillview Villa available next weekend?'
  ),
  (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'bob@example.com'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    'Hi Alice, yes it is available. Feel free to book!'
  );

