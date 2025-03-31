class EventsController < ApplicationController
  before_action :authenticate_event_organizer!, except: [:index, :show]
  before_action :set_event, only: [:show, :update, :destroy]
  before_action :authorize_event_organizer!, only: [:update, :destroy]

  def index
    events = Event.all
    unless events.empty?
      render json: { event: events }, status: :created
    else
      render json: { message: 'No events to display' }, status: :created
    end  
  end

  def show
    render json: @event, status: :ok
  end

  def create
    event = current_event_organizer.events.build(event_params)
    if event.save
      render json: { message: 'Event created successfully.', event: event }, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: { message: 'Event updated successfully.', event: @event }, status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    render json: { message: 'Event deleted successfully.' }, status: :ok
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
    render json: { error: "Event not found." }, status: :not_found unless @event
  end

  def authenticate_event_organizer!
    if current_event_organizer
      return
    elsif current_user
      render json: { error: 'Only event organizers can manage events' }, status: :forbidden
    else
      render json: { error: 'You need to sign in before continuing' }, status: :unauthorized
    end
  end

  def authorize_event_organizer!
    unless current_event_organizer == @event.event_organizer
      render json: { error: 'You are not creator of this event to manage' }, status: :forbidden
    end
  end

  def event_params
    params.require(:event).permit(:name, :description, :start_time, :end_time, :venue)
  end
end
