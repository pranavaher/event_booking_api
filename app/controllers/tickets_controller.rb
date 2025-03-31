class TicketsController < ApplicationController
  before_action :authenticate_event_organizer!, except: [:index, :show, :get_all_tickets]
  before_action :set_event, except: [:get_all_tickets]
  before_action :set_ticket, only: [:show, :update, :destroy]
  before_action :authorize_event_organizer!, only: [:create, :update, :destroy]

  def index
    tickets = @event.tickets
    render json: tickets
  end

  def get_all_tickets
    tickets = Ticket.joins(:event).select('tickets.id, events.name AS event_name, tickets.ticket_type, tickets.price, tickets.quantity_available')
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

  def authenticate_event_organizer!
    if current_event_organizer
      return
    elsif current_user
      render json: { error: 'Only event organizers can manage tickets' }, status: :forbidden
    else
      render json: { error: 'You need to sign in before continuing' }, status: :unauthorized
    end
  end
  

  def authorize_event_organizer!
    unless current_event_organizer
      return render json: { error: 'Only event organizers can manage tickets' }, status: :forbidden
    end

    unless current_event_organizer == @event.event_organizer
      render json: { error: 'You are not creator of this event to manage tickets' }, status: :forbidden
    end
  end

  def ticket_params
    params.require(:ticket).permit(:ticket_type, :price, :quantity_available)
  end
end
