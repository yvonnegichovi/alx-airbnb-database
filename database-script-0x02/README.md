# Airbnb Clone – Sample Seed Data

This directory contains SQL scripts to populate the PostgreSQL database with realistic sample data.

---

## 📄 seed.sql

Populates tables:

- `users`
- `properties`
- `bookings`
- `payments`
- `reviews`
- `messages`

---

## 🛠️ How to Use

1. Ensure your database is already created and schema is loaded.

2. Run the seed script:

```bash
psql -U your_user -d your_database -f seed.sql

