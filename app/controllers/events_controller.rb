class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.includes(:organizer, :enrollments).order(:start_date)
  end

  def show
    load_show_assigns
    @attendee = Attendee.new
  end

  def new
    @event = Event.new(organizer_id: params[:organizer_id])
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event was successfully deleted.", status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def load_show_assigns
    @confirmed_enrollments = @event.enrollments.confirmed.includes(:attendee).joins(:attendee).order("attendees.name")
    @waitlisted_enrollments = @event.enrollments.waitlisted.includes(:attendee).in_waitlist_order
  end

  def event_params
    params.expect(event: [ :title, :description, :location, :start_date, :end_date, :capacity, :organizer_id ])
  end
end
