module ApplicationHelper
  def date_range(event)
    if event.start_date == event.end_date
      l(event.start_date, format: :long)
    else
      "#{l(event.start_date, format: :long)} – #{l(event.end_date, format: :long)}"
    end
  end

  def seat_availability(event)
    if event.full?
      "FULL (#{event.waitlisted_count} on waitlist)"
    else
      "#{event.seats_remaining} / #{event.capacity} seats remaining"
    end
  end
end
