# Airbnb Clone Database Normalization

## 📚 What is Normalization?

**Normalization** is the process of organizing database schema to minimize redundancy and dependency by dividing tables into logically related entities and establishing well-defined relationships. This process enhances **data integrity**, **consistency**, and **query performance**.

---

## 🎯 Goal

Ensure that our Airbnb Clone database is normalized to **Third Normal Form (3NF)**.

---

## ⚙️ Normalization Steps

### 1️⃣ First Normal Form (1NF)

**Rule**: 
- Eliminate repeating groups.
- Ensure each column holds only **atomic** (indivisible) values.
- Each record must be **unique**.

✅ **Applied**:  
All our tables already use atomic values (e.g., `first_name`, `email`, `rating`) and contain no arrays or multiple values in one column.  
Each table has a primary key (`UUID`) to guarantee record uniqueness.

➡️ ✅ **Database is in 1NF**

---

### 2️⃣ Second Normal Form (2NF)

**Rule**:
- Achieve 1NF.
- Eliminate **partial dependencies** (non-key columns must depend on the entire primary key).

✅ **Applied**:  
Our tables use **single-column primary keys**, so no composite keys exist that would cause partial dependencies.

Example:
- In `Booking`, all non-key attributes (`start_date`, `status`, etc.) depend entirely on `booking_id`.

➡️ ✅ **Database is in 2NF**

---

### 3️⃣ Third Normal Form (3NF)

**Rule**:
- Achieve 2NF.
- Eliminate **transitive dependencies** (non-key attributes should not depend on other non-key attributes).

✅ **Applied**:

Let’s assess a few tables:

---

### 🔍 User Table
| Field            | Notes                                 |
|------------------|----------------------------------------|
| `user_id`        | Primary Key                           |
| `first_name`     | Depends on `user_id`                  |
| `last_name`      | Depends on `user_id`                  |
| `email`          | Unique, depends on `user_id`          |
| `role`           | Atomic ENUM, no transitive dependency |

🟢 All non-key fields depend **only** on `user_id`.

---

### 🔍 Property Table
| Field            | Notes                                               |
|------------------|------------------------------------------------------|
| `property_id`    | Primary Key                                         |
| `host_id`        | FK, links to `User`                                 |
| `pricepernight`  | Depends only on `property_id`, not on `host_id`     |

🟢 No transitive dependencies – e.g., `pricepernight` is tied to the property, not to the user.

---

### 🔍 Booking Table
| Field         | Notes                                       |
|---------------|----------------------------------------------|
| `booking_id`  | Primary Key                                 |
| `user_id`     | FK → User                                   |
| `property_id` | FK → Property                               |
| `total_price` | Depends only on `booking_id`                |

🟢 Attributes like `status` or `total_price` do not rely on `user_id` or `property_id`.

---

### 🔍 Message Table
| Field          | Notes                                        |
|----------------|-----------------------------------------------|
| `message_id`   | Primary Key                                  |
| `sender_id`    | FK → User                                    |
| `recipient_id` | FK → User                                    |

🟢 Each field is atomic and has no transitive dependencies.

---

## ✅ Summary

| Normal Form | Status |
|--------------|--------|
| 1NF          | ✅     |
| 2NF          | ✅     |
| 3NF          | ✅     |

All tables in our Airbnb Clone project adhere to **3NF**. There are:
- No multi-valued fields.
- No partial dependencies.
- No transitive dependencies.

---

## ✍️ Notes

- The `ENUM` fields such as `role`, `status`, and `payment_method` were evaluated and kept as they represent controlled, atomic values (good design choice in Postgres).
- No further decomposition was necessary based on the current schema.
- Proper **foreign keys** maintain referential integrity across entities.

---

## 🔗 Conclusion

The Airbnb Clone database design is well-structured and normalized up to **Third Normal Form (3NF)**. This ensures minimal redundancy, optimal data integrity, and ease of query maintenance in production systems.

