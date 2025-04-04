class BookingConfirmationJob
  include Sidekiq::Job

  def perform(booking_id)
    booking = Booking.find_by(id: booking_id)
    return unless booking

    BookingMailer.booking_confirmation(booking).deliver_now
    puts "[Sidekiq] Sending booking confirmation email for Booking ID: #{booking.id} | User Name: #{booking.user.name} | Event: #{booking.ticket.event.name} | Ticket Type: #{booking.ticket.ticket_type} | Quantity: #{booking.quantity} | Total Price: #{booking.total_price}"

  end
end