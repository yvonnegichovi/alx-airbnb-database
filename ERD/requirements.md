# ER Diagram Requirements

## Entities and Attributes

### User
- id (PK)
- name
- email
- password_hash
- created_at

### Property
- id (PK)
- user_id (FK → User)
- title
- description
- location
- price_per_night
- created_at

### Booking
- id (PK)
- user_id (FK → User)
- property_id (FK → Property)
- check_in_date
- check_out_date
- total_price
- status

### Payment
- id (PK)
- booking_id (FK → Booking)
- amount
- payment_method
- payment_status
- created_at

### Review
- id (PK)
- user_id (FK → User)
- property_id (FK → Property)
- rating
- comment
- created_at

## Relationships

- One User can own many Properties
- One User can have many Bookings
- One User can leave many Reviews
- One Property belongs to one User
- One Property can have many Bookings
- One Property can have many Reviews
- One Booking is made by one User and refers to one Property
- One Booking has one Payment
- One Payment belongs to one Booking
- One Review is made by a User for a Property

