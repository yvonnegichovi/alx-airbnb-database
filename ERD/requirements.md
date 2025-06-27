# Airbnb Clone – ER Diagram Requirements

This document outlines the entity-relationship model for the Airbnb Clone backend database using PostgreSQL.

---

## 📦 Entities & Attributes

### 🧍‍♂️ User
- `user_id`: UUID, Primary Key, Indexed
- `first_name`: VARCHAR, NOT NULL
- `last_name`: VARCHAR, NOT NULL
- `email`: VARCHAR, UNIQUE, NOT NULL
- `password_hash`: VARCHAR, NOT NULL
- `phone_number`: VARCHAR, NULL
- `role`: ENUM ('guest', 'host', 'admin'), NOT NULL
- `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

---

### 🏠 Property
- `property_id`: UUID, Primary Key, Indexed
- `host_id`: UUID, Foreign Key → User(user_id)
- `name`: VARCHAR, NOT NULL
- `description`: TEXT, NOT NULL
- `location`: VARCHAR, NOT NULL
- `pricepernight`: DECIMAL, NOT NULL
- `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- `updated_at`: TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP

---

### 📅 Booking
- `booking_id`: UUID, Primary Key, Indexed
- `property_id`: UUID, Foreign Key → Property(property_id)
- `user_id`: UUID, Foreign Key → User(user_id)
- `start_date`: DATE, NOT NULL
- `end_date`: DATE, NOT NULL
- `total_price`: DECIMAL, NOT NULL
- `status`: ENUM ('pending', 'confirmed', 'canceled'), NOT NULL
- `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

---

### 💳 Payment
- `payment_id`: UUID, Primary Key, Indexed
- `booking_id`: UUID, Foreign Key → Booking(booking_id)
- `amount`: DECIMAL, NOT NULL
- `payment_date`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP
- `payment_method`: ENUM ('credit_card', 'paypal', 'stripe'), NOT NULL

---

### ⭐ Review
- `review_id`: UUID, Primary Key, Indexed
- `property_id`: UUID, Foreign Key → Property(property_id)
- `user_id`: UUID, Foreign Key → User(user_id)
- `rating`: INTEGER, CHECK rating BETWEEN 1 AND 5, NOT NULL
- `comment`: TEXT, NOT NULL
- `created_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

---

### 💬 Message
- `message_id`: UUID, Primary Key, Indexed
- `sender_id`: UUID, Foreign Key → User(user_id)
- `recipient_id`: UUID, Foreign Key → User(user_id)
- `message_body`: TEXT, NOT NULL
- `sent_at`: TIMESTAMP, DEFAULT CURRENT_TIMESTAMP

---

## 🔗 Relationships

- A **User** can:
  - own many **Properties**
  - make many **Bookings**
  - write many **Reviews**
  - send/receive **Messages**

- A **Property**:
  - belongs to one **User** (host)
  - can have many **Bookings**
  - can receive many **Reviews**

- A **Booking**:
  - is made by one **User**
  - is for one **Property**
  - has one **Payment**

- A **Payment**:
  - is associated with one **Booking**

- A **Review**:
  - is written by one **User**
  - is for one **Property**

- A **Message**:
  - is sent by one **User**
  - is received by one **User**

---

## ⚙️ Constraints

- **User Table**:
  - `email`: UNIQUE
  - `first_name`, `last_name`, `email`, `password_hash`, `role`: NOT NULL

- **Property Table**:
  - `host_id`: must reference an existing user
  - essential attributes must be NOT NULL

- **Booking Table**:
  - must reference existing `User` and `Property`
  - `status` must be 'pending', 'confirmed', or 'canceled'

- **Payment Table**:
  - must reference a valid `Booking`

- **Review Table**:
  - `rating` must be between 1 and 5
  - must reference valid `User` and `Property`

- **Message Table**:
  - must reference valid `sender

