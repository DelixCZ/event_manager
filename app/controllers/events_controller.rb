class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.includes(:organizer).order(:start_date)
  end

  def show
    @attendees = @event.attendees.order(:name)
    @attendee = @event.attendees.build
  end

  def new
    @event = Event.new
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

  def event_params
    params.expect(event: [ :title, :description, :location, :start_date, :end_date, :organizer_id ])
  end
end
