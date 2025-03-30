class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :update, :destroy]

  def index
    bookings = current_user.bookings.includes(ticket: :event)
    if bookings.any?
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

  def set_booking
    @booking = Booking.find_by(id: params[:id])
  
    if @booking.nil?
      render json: { error: "Booking not found" }, status: :not_found
    elsif @booking.user_id != current_user.id
      render json: { error: "Unauthorized access" }, status: :forbidden
    end
  end
  

  def booking_params
    params.require(:booking).permit(:ticket_id, :quantity)
  end
end
