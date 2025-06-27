# Airbnb Clone – PostgreSQL Schema

This directory contains the SQL schema for the Airbnb Clone backend project using PostgreSQL.

---

## 📄 schema.sql

This file defines all necessary tables and relationships between:

- Users
- Properties
- Bookings
- Payments
- Reviews
- Messages

Each table uses UUIDs as primary keys and follows normalization rules up to 3NF.

---

## ✅ Features

- ✅ Foreign keys for all relationships
- ✅ ENUM-style constraints using `CHECK`
- ✅ Timestamps for record creation
- ✅ Indexes on frequently queried columns

---

## 🚀 How to Use

1. Ensure PostgreSQL is running and supports UUIDs:
   ```bash
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

