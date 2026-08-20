horizon = Organizer.find_or_create_by!(email: "maya.chen@horizonevents.com") do |organizer|
  organizer.name = "Maya Chen"
end

lumen = Organizer.find_or_create_by!(email: "jonas.berg@lumenstudio.io") do |organizer|
  organizer.name = "Jonas Berg"
end

attendees = {
  elena: [ "Elena Rossi", "elena.rossi@nordicmail.com" ],
  tomas: [ "Tomáš Novák", "tomas.novak@example.cz" ],
  priya: [ "Priya Shah", "priya.shah@brightline.dev" ],
  sofia: [ "Sofia Almeida", "sofia.almeida@mail.pt" ],
  lukas: [ "Lukas Weber", "lukas.weber@example.de" ],
  amina: [ "Amina Diallo", "amina.diallo@example.com" ],
  noah: [ "Noah Jensen", "noah.jensen@lumenstudio.io" ],
  hana: [ "Hana Kim", "hana.kim@example.kr" ],
  omar: [ "Omar Haddad", "omar.haddad@example.com" ],
  clara: [ "Clara Moreau", "clara.moreau@example.fr" ],
  mateo: [ "Mateo Silva", "mateo.silva@example.cl" ],
  irene: [ "Irene Papadopoulos", "irene.papadopoulos@example.com" ],
  yara: [ "Yara Nasser", "yara.nasser@example.com" ]
}.transform_values do |name, email|
  Attendee.find_or_create_by!(email: email) do |attendee|
    attendee.name = name
  end
end

events = [
  {
    organizer: horizon,
    title: "North Sea Product Summit",
    description: "A two-day gathering for product leaders covering discovery, delivery, and team health.",
    location: "Oslo Spektrum, Oslo",
    start_date: Date.new(2026, 9, 14),
    end_date: Date.new(2026, 9, 16),
    capacity: 4,
    attendee_keys: [ :elena, :tomas, :priya, :sofia, :irene ]
  },
  {
    organizer: horizon,
    title: "Community Ops Workshop",
    description: "Hands-on workshop for community managers running in-person meetups.",
    location: "Impact Hub, Prague",
    start_date: Date.new(2026, 10, 3),
    end_date: Date.new(2026, 10, 4),
    capacity: 10,
    attendee_keys: [ :sofia, :lukas, :elena ]
  },
  {
    organizer: lumen,
    title: "Design Systems Intensive",
    description: "A practical course on tokens, documentation, and adoption across product teams.",
    location: "Kulturhuset, Stockholm",
    start_date: Date.new(2026, 11, 9),
    end_date: Date.new(2026, 11, 11),
    capacity: 5,
    attendee_keys: [ :amina, :noah, :hana, :omar, :priya, :yara ]
  },
  {
    organizer: lumen,
    title: "Winter Demo Night",
    description: "An evening of lightning demos from independent makers and studio teams.",
    location: "Kampnagel, Hamburg",
    start_date: Date.new(2026, 12, 4),
    end_date: Date.new(2026, 12, 5),
    capacity: 10,
    attendee_keys: [ :clara, :mateo, :noah ]
  }
]

events.each do |attrs|
  attrs = attrs.dup
  attendee_keys = attrs.delete(:attendee_keys)
  event = Event.find_or_initialize_by(title: attrs[:title], organizer: attrs[:organizer])
  event.assign_attributes(attrs)
  event.save!

  attendee_keys.each do |key|
    Enrollment.find_or_create_by!(event: event, attendee: attendees[key])
  end
end
