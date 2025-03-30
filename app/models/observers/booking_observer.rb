class BookingObserver < ActiveRecord::Observer
  def after_create(booking)
    BookingConfirmationJob.perform_async(booking.id)
  end
end
