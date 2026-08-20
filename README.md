# Event Manager

A small Ruby on Rails application for organizing events, their organizers, and attendees.

## Stack

- Ruby 3.3.12 (see `.ruby-version`)
- Rails 8.1.3
- MySQL (`mysql2`)

## Domain

- **Organizer** — a person or group that owns events (`name`, unique `email`)
- **Event** — a dated gathering belonging to one organizer (`title`, `description`, `location`, `start_date`, `end_date`, `capacity`)
- **Attendee** — a unique person on the platform (`name`, unique `email`)
- **Enrollment** — the join between an event and an attendee (`status`: `confirmed` or `waitlisted`); the same person can attend many events

An event's `end_date` must be strictly after its `start_date`. Each event has a seat `capacity`; enrollments are `confirmed` until that limit is reached, then `waitlisted`. Destroying an organizer removes their events; destroying an event removes its enrollments, not the attendees themselves.

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

The app is available at [http://localhost:3000](http://localhost:3000). The root path lists events. Use **Organizers** in the header to add people who can own events, then create events and register attendees.

## DECISIONS

### Waitlist logic

1. **Signing up while there is a free seat** confirms the attendee immediately.
2. **Signing up while the event is full** adds them to the **back** of the waitlist (FIFO: whoever joined the waitlist first is promoted first).
3. **Decreasing capacity** kicks the **most recently enrolled confirmed** attendees (last in, first off a seat) until confirmed count equals capacity. People who enrolled earlier keep their confirmed seats.
4. **Those kicked go in front of anyone already on the waitlist.** They just had a seat, so they are first in line to get one back if a spot opens.
5. **If several people are kicked in the same decrease, keep their original signup order.** Whoever was added sooner is higher on the waitlist (e.g. attendee 3 above attendee 4). They still sit as a group in front of people who were already waiting.
6. **Increasing capacity or removing a confirmed attendee** promotes from the front of the waitlist until seats are filled.

This last-in, first-off rule is fair because the people who booked later are the ones who lose a seat when the event shrinks, while earlier signups keep their place. Putting attendee 4 above attendee 3 after a batch bump would discriminate against 3, who joined first and had a stronger claim to stay closer to a confirmed seat. Ranking the bumped group by signup time, then ahead of anyone already waiting, treats both “who earned a seat first” and “who was already in line” consistently.

- **Status is assigned in the model, not the controller.** `Enrollment` sets `confirmed` or `waitlisted` on create from `event.has_available_seat?`. Waitlist order is stored on `waitlisted_at`. Existing seed rows get `capacity` default 10 and `status` default `confirmed`, so current data stays valid after migrate.
- **Tests use dedicated events.** Waitlist edge cases build their own events and attendees with explicit capacities instead of mutating fixtures, so they stay isolated from the seeded summit/workshop data.
