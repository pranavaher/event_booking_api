class BookingConfirmationJob
  include Sidekiq::Job

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking

    puts "[Sidekiq] Sending booking confirmation email for Booking ID: #{booking.id} | User ID: #{booking.user_id} | Event: #{booking.ticket.event.name} | Ticket Type: #{booking.ticket.ticket_type} | Quantity: #{booking.quantity} | Total Price: #{booking.total_price}"

  end
end