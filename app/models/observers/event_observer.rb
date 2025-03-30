class EventObserver < ActiveRecord::Observer
  def after_update(event)
    EventUpdateNotificationJob.perform_async(event.id)
  end
end
