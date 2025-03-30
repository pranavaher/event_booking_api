class BookingMailer < ApplicationMailer
  default from: "pranavaher@example.com"

  def booking_confirmation(booking)
    @booking = booking
    mail(to: booking.user.email, subject: "Booking Confirmation ##{booking.id}")
  end
end
