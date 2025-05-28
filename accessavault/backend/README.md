# Accessavault Backend

This is a simple Node.js + Express backend for Accessavault, providing REST APIs for users, roles, and groups, connected to a MySQL database.

## Prerequisites
- Node.js (v16+ recommended)
- MySQL server running and database/tables created

## Setup
1. Open a terminal in this `backend` directory.
2. Install dependencies:
   ```
   npm install
   ```
3. Edit `app.js` and set your MySQL credentials if needed.
4. Start the server:
   ```
   npm start
   ```
   The server will run on [http://localhost:3000](http://localhost:3000).

## API Endpoints
- `GET /users` — List users
- `POST /users` — Create user
- `GET /users/:id` — Get user details
- `PUT /users/:id` — Update user
- `DELETE /users/:id` — Delete user
- `GET /roles` — List roles
- `POST /roles` — Create role
- `GET /groups` — List groups
- `POST /groups` — Create group

## Notes
- Make sure your MySQL database (`accessavault_db`) and tables (`users`, `roles`, `groups`) exist.
- You can now connect your Flutter frontend to these endpoints using HTTP requests.