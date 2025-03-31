class BookingsController < ApplicationController
  before_action :authenticate_user_or_event_organizer!, only: [:index, :show]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_booking, only: [:show, :update, :destroy]

  def index
    if current_user
      bookings = current_user.bookings.includes(ticket: :event)
    elsif current_event_organizer
      bookings = Booking.joins(ticket: :event)
                        .where(events: { event_organizer_id: current_event_organizer.id })

      bookings = bookings.where(events: { id: params[:event_id] }) if params[:event_id].present?
    end

    if bookings.present?
      render json: bookings
    else
      render json: { message: "No bookings found" }, status: :not_found
    end
  end

  def show
    render json: @booking
  end

  def create
    booking = current_user.bookings.build(booking_params)
    if booking.save
      render json: booking, status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @booking.ticket.event.start_time > Time.current
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Cannot modify booking after event starts" }, status: :forbidden
    end
  end

  def destroy
    if @booking.ticket.event.start_time > Time.current
      @booking.destroy
      head :no_content
    else
      render json: { error: "Cannot cancel booking after event starts" }, status: :forbidden
    end
  end

  private

  def authenticate_user_or_event_organizer!
    if current_user || current_event_organizer
      return
    else
      render json: { error: "You need to sign in before continuing" }, status: :unauthorized
    end
  end

  def set_booking
    @booking = Booking.find_by(id: params[:id])

    if @booking.nil?
      render json: { error: "Booking not found" }, status: :not_found
    elsif current_user
      # Users can only see their own bookings
      unless @booking.user_id == current_user.id
        render json: { error: "You are not authorized as this is not your booking" }, status: :forbidden
      end
    elsif current_event_organizer
      # Event organizers can only see bookings for their own events
      unless @booking.ticket.event.event_organizer_id == current_event_organizer.id
        render json: { error: "You are not authorized as this booking does not belong to ticket/event that you created" }, status: :forbidden
      end
    end
  end

  def authenticate_user!
    if current_user
      return
    elsif current_event_organizer
      render json: { error: "Event organizers cannot create, update, or delete bookings" }, status: :forbidden
    else
      render json: { error: "You need to sign in before continuing" }, status: :unauthorized
    end
  end

  def booking_params
    params.require(:booking).permit(:ticket_id, :quantity)
  end
end
