class OrganizersController < ApplicationController
  before_action :set_organizer, only: %i[show edit update destroy]

  def index
    @organizers = Organizer.includes(:events).order(:name)
  end

  def show
    @events = @organizer.events.order(:start_date)
  end

  def new
    @organizer = Organizer.new
  end

  def create
    @organizer = Organizer.new(organizer_params)

    if @organizer.save
      redirect_to @organizer, notice: "Organizer was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @organizer.update(organizer_params)
      redirect_to @organizer, notice: "Organizer was successfully updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @organizer.destroy
    redirect_to organizers_path, notice: "Organizer was successfully deleted.", status: :see_other
  end

  private

  def set_organizer
    @organizer = Organizer.find(params[:id])
  end

  def organizer_params
    params.expect(organizer: [ :name, :email ])
  end
end
