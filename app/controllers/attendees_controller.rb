class AttendeesController < ApplicationController
  before_action :set_event

  def create
    @attendee = @event.attendees.build(attendee_params)

    if @attendee.save
      redirect_to @event, notice: "Attendee was successfully added."
    else
      @attendees = @event.attendees.order(:name).select(&:persisted?)
      render "events/show", status: :unprocessable_content
    end
  end

  def destroy
    @attendee = @event.attendees.find(params[:id])
    @attendee.destroy
    redirect_to @event, notice: "Attendee was successfully removed.", status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def attendee_params
    params.expect(attendee: [ :name, :email ])
  end
end
