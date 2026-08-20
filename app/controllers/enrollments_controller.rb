class EnrollmentsController < ApplicationController
  before_action :set_event

  def create
    @attendee = find_or_initialize_attendee

    unless @attendee.save
      load_show_assigns
      render "events/show", status: :unprocessable_content
      return
    end

    if @event.enrollments.exists?(attendee: @attendee)
      redirect_to @event, alert: "This attendee is already registered for this event."
      return
    end

    enrollment = @event.enrollments.create!(attendee: @attendee)
    notice = if enrollment.confirmed?
      "Attendee was successfully added."
    else
      "Event is full. Attendee was added to the waitlist."
    end
    redirect_to @event, notice: notice
  end

  def destroy
    enrollment = @event.enrollments.find(params[:id])
    enrollment.destroy
    redirect_to @event, notice: "Attendee was successfully removed.", status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def load_show_assigns
    @confirmed_enrollments = @event.enrollments.confirmed.includes(:attendee).joins(:attendee).order("attendees.name")
    @waitlisted_enrollments = @event.enrollments.waitlisted.includes(:attendee).in_waitlist_order
  end

  def find_or_initialize_attendee
    attendee = Attendee.find_or_initialize_by(email: attendee_params[:email])
    attendee.name = attendee_params[:name] if attendee.new_record?
    attendee
  end

  def attendee_params
    params.expect(attendee: [ :name, :email ])
  end
end
