# Event Manager

A small Ruby on Rails application for organizing events, their organizers, and attendees.

## Stack

- Ruby 3.3.12 (see `.ruby-version`)
- Rails 8.1.3
- MySQL (`mysql2`)

## Domain

- **Organizer** — a person or group that owns events (`name`, unique `email`)
- **Event** — a dated gathering belonging to one organizer (`title`, `description`, `location`, `start_date`, `end_date`)
- **Attendee** — a person registered for a specific event (`name`, `email`)

An event's `end_date` must be strictly after its `start_date`. Destroying an organizer removes their events; destroying an event removes its attendees.

## Setup

1. Install Ruby 3.3.12 and a local MySQL server.
2. Install gems:

   ```bash
   bundle install
   ```

3. The app connects as MySQL `root` with the local development password. Override with `DB_USERNAME`, `DB_PASSWORD`, `DB_HOST`, or `DB_PORT` if needed.

4. Create, migrate, and seed the database:

   ```bash
   bin/rails db:create db:migrate db:seed
   ```

5. Start the server:

   ```bash
   bin/rails server
   ```

The app is available at [http://localhost:3000](http://localhost:3000). The root path lists events. Open an event to view attendees and add a new one from the same page.
