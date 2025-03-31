# Event Booking System

## Project Overview
The Event Booking System is a RESTful API built using Ruby on Rails that allows users to browse events, book tickets, and manage their bookings. Event organizers can create and manage events, set ticket prices, and track bookings.

### Features:
- User and Event Organizer authentication using JWT
- Role-based access control (Users can book tickets, Event Organizers can manage events and tickets)
- Event and Ticket management (CRUD operations)
- Booking system with restrictions (users can modify only their bookings, event organizers can view bookings but not modify them)
- Background job processing with Sidekiq (email notifications, event updates)
- API testing using Postman and automated tests with RSpec

---

## Tech Stack
- **Backend**: Ruby (v3.2.1) on Rails (v7.1.5.1)
- **Database**: PostgreSQL
- **Authentication**: Devise + JWT
- **Background Jobs**: Sidekiq (Redis required)
- **Testing**: RSpec

---

## Prerequisites
- **Ruby**: 3.2.1
- **Rails**: 7.1.5.1
- **PostgreSQL** (Ensure it's running locally)
- **Redis** (For Sidekiq background jobs)
- **Bundler** (Install dependencies: `gem install bundler`)

---

## Setup Instructions
1. **Clone the repository:**  
   ```sh
   git clone https://github.com/pranavaher/event_booking_api
   cd event-booking-system
   ```
2. **Install dependencies:**  
   ```sh
   bundle install
   ```
3. **Set up the database:**  
   ```sh
   rails db:create db:migrate
   ```
4. **Run the server:**  
   ```sh
   rails server
   ```
5. **Start Sidekiq (for background jobs):**  
   ```sh
   bundle exec sidekiq
   ```

---

## API Authentication (JWT)
- **Login as Event Organizer:** `POST /event_organizers/sign_in`
- **Login as User:** `POST /users/sign_in`
- **Use the JWT token** from login response for authenticated requests by adding it to the `Authorization` header:  
  ```sh
  Authorization: Bearer <EO_AUTH_TOKEN>
  Authorization: Bearer <USER_TOKEN>
  ```
- **Note** Added tokens `EO_AUTH_TOKEN` and `USER_TOKEN` to test authorization of event organizers with user specific routes and vice versa

---

## API Endpoints

### **Users**
- `POST /users` - Register a new user
- `POST /users/sign_in` - Login and get JWT token

### **Event Organizers**
- `POST /event_organizers` - Register a new organizer
- `POST /event_organizers/sign_in` - Login and get JWT token

### **Events**
- `GET /events` - List all events (**Public**)
- `GET /events/:id` - Show single event (**Public**)
- `POST /events` - Create a new event (Organizer only)
- `PUT /events/:id` - Update an event (Organizer only)
- `DELETE /events/:id` - Delete an event (Organizer only)

### **Tickets**
- `GET /events/:event_id/tickets` - View tickets for an event (**Public**)
- `GET /get_all_tickets` - View all tickets (**Public**)
- `POST /events/:event_id/tickets` - Create a ticket (Organizer only)
- `PUT /events/:event_id/tickets/:id` - Update ticket (Organizer only)
- `DELETE /events/:event_id/tickets/:id` - Delete ticket (Organizer only)

### **Bookings**
- `GET /bookings` - View all user bookings (User and EventOrganizer)
- `GET /bookings/:id` - Show single booking (User and EventOrganizer)
- `POST /bookings` - Create a booking (User only)
- `PUT /bookings/:id` - Update booking (User only, before event starts)
- `DELETE /bookings/:id` - Cancel booking (User only, before event starts)

---

## Database Schema & Table Associations

### **Entity-Relationship Diagram (ERD)**
[View the ERD Online](https://dbdiagram.io/d/SIdepanda-67ea30374f7afba184c3e792)

### **Table Relationships**
- **Users** → Has many `bookings`
- **Event Organizers** → Has many `events`
- **Events** → Belongs to an `event_organizer`, has many `tickets`, has many `bookings`
- **Tickets** → Belongs to an `event`, has many `bookings`
- **Bookings** → Belongs to a `user`, belongs to a `ticket`

---

## Testing the API
1. **Run RSpec tests:**
   ```sh
   bundle exec rspec
   ```

---

## Sidekiq Setup (Background Jobs)
- **Start Redis:**
  ```sh
  redis-server
  ```
- **Run Sidekiq:**
  ```sh
  bundle exec sidekiq
  ```
- Sidekiq processes jobs like ticket booking email notifications and event update notifications to all users who booked tickets for the event.

---

