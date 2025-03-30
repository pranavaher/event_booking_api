class EventUpdateNotificationJob
  include Sidekiq::Job

  def perform(event_id)
    event = Event.find_by(id: event_id)
    return unless event

    event.bookings.find_each do |booking|
      puts "[Sidekiq] Sending event update notification: Event '#{event.name}' (ID: #{event.id}) has been updated with description: #{event.description} Notifying User ID: #{booking.user_id}, User Email: #{booking.user_id} Booking ID: #{booking.id}, Email: #{booking.user.email}"
    end
  end
end
