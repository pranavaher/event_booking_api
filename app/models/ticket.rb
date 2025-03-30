class Ticket < ApplicationRecord
  belongs_to :event
  has_many :bookings, dependent: :destroy  # Delete associated bookings when ticket is deleted

  validates :ticket_type, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_available, numericality: { greater_than_or_equal_to: 0 }

  # Reduce ticket availability when a booking is made
  def reduce_availability!(quantity)
    update!(quantity_available: quantity_available - quantity)
  end
end
