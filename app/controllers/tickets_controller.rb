class TicketsController < ApplicationController
  before_action :authenticate_event_organizer!, except: [:index, :show]
  before_action :set_event
  before_action :set_ticket, only: [:show, :update, :destroy]
  before_action :authorize_event_organizer!, only: [:create, :update, :destroy]

  def index
    tickets = @event.tickets
    render json: tickets
  end

  def show
    if @ticket
      render json: @ticket
    else
      render json: { error: 'Ticket not found for thihs event' }, status: :not_found
    end
  end

  def create
    ticket = @event.tickets.build(ticket_params)
    if ticket.save
      render json: ticket, status: :created
    else
      render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end

  def set_ticket
    @ticket = @event.tickets.find_by(id: params[:id])
    render json: { error: 'Ticket not found for this event' }, status: :not_found if @ticket.nil?
  end

  def authorize_event_organizer!
    unless current_event_organizer == @event.event_organizer
      render json: { error: 'You are unauthorized to manage tickets for this event' }, status: :forbidden
    end
  end

  def ticket_params
    params.require(:ticket).permit(:ticket_type, :price, :quantity_available)
  end
end
