horizon = Organizer.find_or_create_by!(email: "maya.chen@horizonevents.com") do |organizer|
  organizer.name = "Maya Chen"
end

lumen = Organizer.find_or_create_by!(email: "jonas.berg@lumenstudio.io") do |organizer|
  organizer.name = "Jonas Berg"
end

events = [
  {
    organizer: horizon,
    title: "North Sea Product Summit",
    description: "A two-day gathering for product leaders covering discovery, delivery, and team health.",
    location: "Oslo Spektrum, Oslo",
    start_date: Date.new(2026, 9, 14),
    end_date: Date.new(2026, 9, 16),
    attendees: [
      [ "Elena Rossi", "elena.rossi@nordicmail.com" ],
      [ "Tomáš Novák", "tomas.novak@example.cz" ],
      [ "Priya Shah", "priya.shah@brightline.dev" ]
    ]
  },
  {
    organizer: horizon,
    title: "Community Ops Workshop",
    description: "Hands-on workshop for community managers running in-person meetups.",
    location: "Impact Hub, Prague",
    start_date: Date.new(2026, 10, 3),
    end_date: Date.new(2026, 10, 4),
    attendees: [
      [ "Sofia Almeida", "sofia.almeida@mail.pt" ],
      [ "Lukas Weber", "lukas.weber@example.de" ]
    ]
  },
  {
    organizer: lumen,
    title: "Design Systems Intensive",
    description: "A practical course on tokens, documentation, and adoption across product teams.",
    location: "Kulturhuset, Stockholm",
    start_date: Date.new(2026, 11, 9),
    end_date: Date.new(2026, 11, 11),
    attendees: [
      [ "Amina Diallo", "amina.diallo@example.com" ],
      [ "Noah Jensen", "noah.jensen@lumenstudio.io" ],
      [ "Hana Kim", "hana.kim@example.kr" ],
      [ "Omar Haddad", "omar.haddad@example.com" ]
    ]
  },
  {
    organizer: lumen,
    title: "Winter Demo Night",
    description: "An evening of lightning demos from independent makers and studio teams.",
    location: "Kampnagel, Hamburg",
    start_date: Date.new(2026, 12, 4),
    end_date: Date.new(2026, 12, 5),
    attendees: [
      [ "Clara Moreau", "clara.moreau@example.fr" ],
      [ "Mateo Silva", "mateo.silva@example.cl" ]
    ]
  }
]

events.each do |attrs|
  attrs = attrs.dup
  attendee_rows = attrs.delete(:attendees)
  event = Event.find_or_create_by!(title: attrs[:title], organizer: attrs[:organizer]) do |record|
    record.assign_attributes(attrs)
  end

  attendee_rows.each do |name, email|
    event.attendees.find_or_create_by!(email: email) do |attendee|
      attendee.name = name
    end
  end
end
