class Event < ApplicationRecord
  belongs_to :event_organizer

  validates :name, :start_time, :end_time, :venue, presence: true
  validate :start_time_must_be_before_end_time

  before_save :calculate_duration

  private

  def start_time_must_be_before_end_time
    return if start_time.blank? || end_time.blank?

    if start_time >= end_time
      errors.add(:start_time, "must be earlier than end time")
    end
  end

  def calculate_duration
    return unless start_time && end_time
    self.duration = ((end_time - start_time) / 60).to_i
  end
end
